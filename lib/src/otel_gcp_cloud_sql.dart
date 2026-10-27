// Licensed under the Apache License, Version 2.0
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry_api/dartastic_opentelemetry_api.dart';

import 'otel_gcp_cloud_sql_suppression.dart';

class GcpCloudSqlResult {
  /// Creates a result.
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

/// What a traced call returned: the value for the caller plus fields
/// recorded on the span.
class GcpCloudSqlCallResult<T> {
  /// Creates a call result.
  const GcpCloudSqlCallResult({required this.value, this.result});

  /// The value returned to the caller.
  final T value;
  final GcpCloudSqlResult? result;
}

Future<T> tracedGcpCloudSql<T>({
  required String operation,
  required Future<GcpCloudSqlCallResult<T>> Function() invoke,
  APITracer? tracer,
}) async {
  if (gcpCloudSqlInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final t = tracer ?? OTelAPI.tracerProvider().getTracer('otel_gcp_cloud_sql');
  final span = t.startSpan('gcp_cloud_sql $operation', kind: SpanKind.client);
  try {
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.system', 'gcp')]));
    span.addAttributes(OTelAPI.attributes(
        [OTelAPI.attributeString('rpc.service', 'CloudSQL')]));
    span.addAttributes(
        OTelAPI.attributes([OTelAPI.attributeString('rpc.method', operation)]));
    final r = await invoke();
    final res = r.result;
    if (res != null) {
      if (res.project != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('gcp.project_id', res.project!)]));
      }
      if (res.region != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('gcp.region', res.region!)]));
      }
      if (res.instanceName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'gcp.cloud_sql.instance.name', res.instanceName!)
        ]));
      }
      if (res.databaseEngine != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('db.system', res.databaseEngine!)]));
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('gcp.cloud_sql.engine', res.databaseEngine!)
        ]));
      }
      if (res.databaseVersion != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('gcp.cloud_sql.version', res.databaseVersion!)
        ]));
      }
      if (res.availabilityType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'gcp.cloud_sql.availability_type', res.availabilityType!)
        ]));
      }
      if (res.tier != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('gcp.cloud_sql.tier', res.tier!)]));
      }
      if (res.diskSizeGb != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('gcp.cloud_sql.disk_size_gb', res.diskSizeGb!)
        ]));
      }
      if (res.diskType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('gcp.cloud_sql.disk_type', res.diskType!)
        ]));
      }
      if (res.databaseName != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeString('db.name', res.databaseName!)]));
      }
      if (res.statementKind != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'gcp.cloud_sql.statement.kind', res.statementKind!)
        ]));
      }
      if (res.rowCount != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeInt('gcp.cloud_sql.row_count', res.rowCount!)]));
      }
      if (res.affectedRows != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('gcp.cloud_sql.affected_rows', res.affectedRows!)
        ]));
      }
      if (res.queryDurationMs != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt(
              'gcp.cloud_sql.query_duration_ms', res.queryDurationMs!)
        ]));
      }
      if (res.connectorType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'gcp.cloud_sql.connector.type', res.connectorType!)
        ]));
      }
      if (res.iamAuth != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeBool('gcp.cloud_sql.iam_auth', res.iamAuth!)]));
      }
      if (res.usesSsl != null) {
        span.addAttributes(OTelAPI.attributes(
            [OTelAPI.attributeBool('gcp.cloud_sql.ssl', res.usesSsl!)]));
      }
      if (res.operationType != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'gcp.cloud_sql.operation.type', res.operationType!)
        ]));
      }
      if (res.operationStatus != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'gcp.cloud_sql.operation.status', res.operationStatus!)
        ]));
      }
      if (res.replicaName != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(
              'gcp.cloud_sql.replica.name', res.replicaName!)
        ]));
      }
      if (res.backupId != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('gcp.cloud_sql.backup.id', res.backupId!)
        ]));
      }
      if (res.statusCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeInt('http.response.status_code', res.statusCode!)
        ]));
      }
      if (res.errorCode != null) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString('gcp.cloud_sql.error.code', res.errorCode!)
        ]));
      }
      final fail = res.errorCode != null ||
          (res.statusCode != null && res.statusCode! >= 400) ||
          res.operationStatus == 'FAILED' ||
          res.operationStatus == 'ERROR';
      if (fail) {
        span.addAttributes(OTelAPI.attributes([
          OTelAPI.attributeString(ErrorAttributes.errorType.key,
              res.errorCode ?? 'gcp_cloud_sql.error')
        ]));
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
