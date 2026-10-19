// Licensed under the MIT License.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:otel_appsflyer/otel_appsflyer.dart';

/// Traces AppsFlyer calls with OpenTelemetry.
///
/// `otel_appsflyer` depends on the OpenTelemetry API only, so the application
/// initializes an SDK once at startup. Wrap each AppsFlyer call in
/// [tracedAppsflyer]; the `invoke` callback makes the real call and reports what
/// came back, which is recorded on the span.
Future<void> main() async {
  await OTel.initialize(serviceName: 'appsflyer-example');

  // Wraps an AppsFlyer SDK call in a CLIENT span.
  final appsflyerId = await tracedAppsflyer<String>(
    operation: 'create',
    invoke: () async {
      // Make the AppsFlyer call here, then report what it returned.
      const id = 'appsflyer_8f3a2c';
      return const AppsflyerCallResult(
          value: id,
          result: AppsflyerResult(
              appId: 'app_8f3a2c',
              appsflyerUid: 'appsflyeru_8f3a2c',
              customerUserId: 'customeruser_8f3a2c',
              installSource: 'Organic',
              mediaSource: 'googleadwords_int',
              campaign: 'example',
              adset: 'example',
              adId: 'ad_8f3a2c',
              isFirstLaunch: true,
              eventName: 'order.created',
              eventStandard: true,
              eventRevenue: 0.5,
              eventCurrency: 'usd',
              skanConversionValue: 1,
              ddlEventName: 'onDeepLinking',
              errorCode: 1,
              errorMessage: 'example',
              statusCode: 201));
    },
  );
  OTelLog.info('tracedAppsflyer create returned $appsflyerId');

  // Calls that should not be traced, such as health checks, run inside
  // runWithoutAppsflyerInstrumentationAsync.
  await runWithoutAppsflyerInstrumentationAsync(
    () => tracedAppsflyer<String>(
      operation: 'create',
      invoke: () async {
        const id = 'appsflyer_8f3a2c';
        return const AppsflyerCallResult(
            value: id,
            result: AppsflyerResult(
                appId: 'app_8f3a2c',
                appsflyerUid: 'appsflyeru_8f3a2c',
                customerUserId: 'customeruser_8f3a2c',
                installSource: 'Organic',
                mediaSource: 'googleadwords_int',
                campaign: 'example',
                adset: 'example',
                adId: 'ad_8f3a2c',
                isFirstLaunch: true,
                eventName: 'order.created',
                eventStandard: true,
                eventRevenue: 0.5,
                eventCurrency: 'usd',
                skanConversionValue: 1,
                ddlEventName: 'onDeepLinking',
                errorCode: 1,
                errorMessage: 'example',
                statusCode: 201));
      },
    ),
  );

  await OTel.shutdown();
}
