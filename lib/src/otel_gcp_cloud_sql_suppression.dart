// Licensed under the Apache License, Version 2.0
// Copyright 2025, Mindful Software LLC, All rights reserved.

import 'dart:async';

const _key = #dartastic_otel_libs_gcp_cloud_sql_suppress;

bool gcpCloudSqlInstrumentationSuppressed() => Zone.current[_key] == true;

T runWithoutGcpCloudSqlInstrumentation<T>(T Function() body) =>
    runZoned(body, zoneValues: {_key: true});

Future<T> runWithoutGcpCloudSqlInstrumentationAsync<T>(
  Future<T> Function() body,
) =>
    runZoned(body, zoneValues: {_key: true});
