// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_gcp_cloud_sql/otel_gcp_cloud_sql.dart';

/// Traces Gcp Cloud Sql calls with OpenTelemetry.
///
/// `otel_gcp_cloud_sql` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each Gcp Cloud Sql call in
/// [tracedGcpCloudSql]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'gcp-cloud-sql-example');

  // Traces a Gcp Cloud Sql call.
  final gcpCloudSqlId = await tracedGcpCloudSql<String>(
    operation: 'create',
    invoke: () async {
      // Make the Gcp Cloud Sql call here, then report what it returned.
      const id = 'gcp_cloud_sql_8f3a2c';
      return const GcpCloudSqlCallResult(
          value: id,
          result: GcpCloudSqlResult(
              project: 'example',
              region: 'us-east-1',
              instanceName: 'example',
              databaseEngine: 'example',
              databaseVersion: '1',
              availabilityType: 'standard',
              tier: 'example',
              diskSizeGb: 512,
              diskType: 'standard',
              databaseName: 'example',
              statementKind: 'active',
              rowCount: 3,
              affectedRows: 1,
              queryDurationMs: 120,
              connectorType: 'standard',
              iamAuth: true,
              usesSsl: true,
              operationType: 'standard',
              operationStatus: 'succeeded',
              replicaName: 'example',
              backupId: 'backup_8f3a2c',
              statusCode: 201,
              errorCode: 'example',
              errorMessage: 'example'));
    },
  );
  OTelLog.info('tracedGcpCloudSql create returned $gcpCloudSqlId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutGcpCloudSqlInstrumentationAsync.
  await runWithoutGcpCloudSqlInstrumentationAsync(
    () => tracedGcpCloudSql<String>(
      operation: 'create',
      invoke: () async {
        const id = 'gcp_cloud_sql_8f3a2c';
        return const GcpCloudSqlCallResult(
            value: id,
            result: GcpCloudSqlResult(
                project: 'example',
                region: 'us-east-1',
                instanceName: 'example',
                databaseEngine: 'example',
                databaseVersion: '1',
                availabilityType: 'standard',
                tier: 'example',
                diskSizeGb: 512,
                diskType: 'standard',
                databaseName: 'example',
                statementKind: 'active',
                rowCount: 3,
                affectedRows: 1,
                queryDurationMs: 120,
                connectorType: 'standard',
                iamAuth: true,
                usesSsl: true,
                operationType: 'standard',
                operationStatus: 'succeeded',
                replicaName: 'example',
                backupId: 'backup_8f3a2c',
                statusCode: 201,
                errorCode: 'example',
                errorMessage: 'example'));
      },
    ),
  );

  await OTel.shutdown();
}
