// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_gcp_cloud_sql_suppression.dart';

class GcpCloudSqlResult {
  const GcpCloudSqlResult({
    this.project,
    this.region,
    this.instanceName,
    this.databaseEngine,
    this.databaseVersion,
    this.availabilityType,
    this.tier,
    this.diskSizeGb,
    this.diskType,
    this.databaseName,
    this.statementKind,
    this.rowCount,
    this.affectedRows,
    this.queryDurationMs,
    this.connectorType,
    this.iamAuth,
    this.usesSsl,
    this.operationType,
    this.operationStatus,
    this.replicaName,
    this.backupId,
    this.statusCode,
    this.errorCode,
    this.errorMessage,
  });

  final String? project;
  final String? region;
  final String? instanceName;
  final String? databaseEngine;
  final String? databaseVersion;
  final String? availabilityType;
  final String? tier;
  final int? diskSizeGb;
  final String? diskType;
  final String? databaseName;
  final String? statementKind;
  final int? rowCount;
  final int? affectedRows;
  final int? queryDurationMs;
  final String? connectorType;
  final bool? iamAuth;
  final bool? usesSsl;
  final String? operationType;
  final String? operationStatus;
  final String? replicaName;
  final String? backupId;
  final int? statusCode;
  final String? errorCode;
  final String? errorMessage;
}

class GcpCloudSqlCallResult<T> {
  const GcpCloudSqlCallResult({required this.value, this.result});
  final T value;
  final GcpCloudSqlResult? result;
}

Future<T> tracedGcpCloudSql<T>({
  required String operation,
  required Future<GcpCloudSqlCallResult<T>> Function() invoke,
  Tracer? tracer,
}) async {
  if (gcpCloudSqlInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTel.tracerProvider().getTracer('otel_gcp_cloud_sql');
  final span = t.startSpan('gcp_cloud_sql $operation', kind: SpanKind.client);
  try {
    span.setStringAttribute('rpc.system', 'gcp');
    span.setStringAttribute('rpc.service', 'CloudSQL');
    span.setStringAttribute('rpc.method', operation);
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.project != null) {
        span.setStringAttribute('gcp.project_id', res.project!);
      }
      if (res.region != null) {
        span.setStringAttribute('gcp.region', res.region!);
      }
      if (res.instanceName != null) {
        span.setStringAttribute(
            'gcp.cloud_sql.instance.name', res.instanceName!);
      }
      if (res.databaseEngine != null) {
        span.setStringAttribute('db.system', res.databaseEngine!);
        span.setStringAttribute('gcp.cloud_sql.engine', res.databaseEngine!);
      }
      if (res.databaseVersion != null) {
        span.setStringAttribute('gcp.cloud_sql.version', res.databaseVersion!);
      }
      if (res.availabilityType != null) {
        span.setStringAttribute(
            'gcp.cloud_sql.availability_type', res.availabilityType!);
      }
      if (res.tier != null) {
        span.setStringAttribute('gcp.cloud_sql.tier', res.tier!);
      }
      if (res.diskSizeGb != null) {
        span.setIntAttribute('gcp.cloud_sql.disk_size_gb', res.diskSizeGb!);
      }
      if (res.diskType != null) {
        span.setStringAttribute('gcp.cloud_sql.disk_type', res.diskType!);
      }
      if (res.databaseName != null) {
        span.setStringAttribute('db.name', res.databaseName!);
      }
      if (res.statementKind != null) {
        span.setStringAttribute(
            'gcp.cloud_sql.statement.kind', res.statementKind!);
      }
      if (res.rowCount != null) {
        span.setIntAttribute('gcp.cloud_sql.row_count', res.rowCount!);
      }
      if (res.affectedRows != null) {
        span.setIntAttribute('gcp.cloud_sql.affected_rows', res.affectedRows!);
      }
      if (res.queryDurationMs != null) {
        span.setIntAttribute(
            'gcp.cloud_sql.query_duration_ms', res.queryDurationMs!);
      }
      if (res.connectorType != null) {
        span.setStringAttribute(
            'gcp.cloud_sql.connector.type', res.connectorType!);
      }
      if (res.iamAuth != null) {
        span.setBoolAttribute('gcp.cloud_sql.iam_auth', res.iamAuth!);
      }
      if (res.usesSsl != null) {
        span.setBoolAttribute('gcp.cloud_sql.ssl', res.usesSsl!);
      }
      if (res.operationType != null) {
        span.setStringAttribute(
            'gcp.cloud_sql.operation.type', res.operationType!);
      }
      if (res.operationStatus != null) {
        span.setStringAttribute(
            'gcp.cloud_sql.operation.status', res.operationStatus!);
      }
      if (res.replicaName != null) {
        span.setStringAttribute('gcp.cloud_sql.replica.name', res.replicaName!);
      }
      if (res.backupId != null) {
        span.setStringAttribute('gcp.cloud_sql.backup.id', res.backupId!);
      }
      if (res.statusCode != null) {
        span.setIntAttribute('http.response.status_code', res.statusCode!);
      }
      if (res.errorCode != null) {
        span.setStringAttribute('gcp.cloud_sql.error.code', res.errorCode!);
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.operationStatus == 'FAILED' ||
          res.operationStatus == 'ERROR';
      if (fail) {
        span.setStringAttribute(ErrorResource.errorType.key,
            res.errorCode ?? 'gcp_cloud_sql.error');
        span.setStatus(SpanStatusCode.Error, res.errorMessage);
      }
    }
    return r.value;
  } catch (e, st) {
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
