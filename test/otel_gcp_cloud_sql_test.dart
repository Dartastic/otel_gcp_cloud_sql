// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_gcp_cloud_sql/otel_gcp_cloud_sql.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_gcp_cloud_sql-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('executeSql records engine + rows + iam', () async {
    await tracedGcpCloudSql<String>(
      operation: 'executeSql',
      invoke: () async => const GcpCloudSqlCallResult(
        value: 'ok',
        result: GcpCloudSqlResult(
          instanceName: 'prod-pg',
          databaseEngine: 'postgresql',
          databaseVersion: 'POSTGRES_16',
          tier: 'db-custom-8-32768',
          statementKind: 'query',
          rowCount: 250,
          queryDurationMs: 18,
          iamAuth: true,
          usesSsl: true,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('gcp_cloud_sql executeSql')!);
    expect(a['db.system'], 'postgresql');
    expect(a['gcp.cloud_sql.iam_auth'], true);
    expect(a['gcp.cloud_sql.row_count'], 250);
  });

  test('FAILED operation sets span error', () async {
    await tracedGcpCloudSql<String>(
      operation: 'instances.import',
      invoke: () async => const GcpCloudSqlCallResult(
        value: 'ok',
        result: GcpCloudSqlResult(
          instanceName: 'prod-pg',
          operationType: 'IMPORT',
          operationStatus: 'FAILED',
        ),
      ),
    );
    expect(
      spans.findSpanByName('gcp_cloud_sql instances.import')!.status,
      SpanStatusCode.Error,
    );
  });

  test('replica + backup record names', () async {
    await tracedGcpCloudSql<String>(
      operation: 'instances.createReplica',
      invoke: () async => const GcpCloudSqlCallResult(
        value: 'ok',
        result: GcpCloudSqlResult(
          replicaName: 'prod-pg-replica',
          backupId: 'bk_1',
          availabilityType: 'REGIONAL',
        ),
      ),
    );
    final a =
        attrsOf(spans.findSpanByName('gcp_cloud_sql instances.createReplica')!);
    expect(a['gcp.cloud_sql.replica.name'], 'prod-pg-replica');
    expect(a['gcp.cloud_sql.availability_type'], 'REGIONAL');
  });

  test('suppression skips spans', () async {
    await runWithoutGcpCloudSqlInstrumentationAsync(() async {
      await tracedGcpCloudSql<String>(
        operation: 'instances.list',
        invoke: () async => const GcpCloudSqlCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('gcp_cloud_sql '), isEmpty);
  });
}
