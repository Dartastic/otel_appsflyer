// Licensed under the MIT License.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';
import 'package:dartastic_opentelemetry/testing.dart';
import 'package:otel_appsflyer/otel_appsflyer.dart';
import 'package:test/test.dart';

void main() {
  late TestHarness harness;
  late InMemorySpanExporter spans;

  setUpAll(() async {
    harness = await maybeInitializeOtelForTest(
      serviceName: 'otel_appsflyer-test',
    );
    spans = harness.spans;
  });

  setUp(() => harness.clear());

  Map<String, Object> attrsOf(Span s) =>
      {for (final a in s.attributes.toList()) a.key: a.value};

  test('getConversionData records media source + first launch', () async {
    await tracedAppsflyer<String>(
      operation: 'getConversionData',
      invoke: () async => const AppsflyerCallResult(
        value: 'ok',
        result: AppsflyerResult(
          appId: 'com.example.app',
          installSource: 'Non-organic',
          mediaSource: 'tiktokglobal_int',
          campaign: 'spring_2026',
          isFirstLaunch: true,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('appsflyer getConversionData')!);
    expect(a['appsflyer.media_source'], 'tiktokglobal_int');
    expect(a['appsflyer.install.source'], 'Non-organic');
    expect(a['appsflyer.is_first_launch'], true);
  });

  test('logEvent records standard af_purchase + SKAN value', () async {
    await tracedAppsflyer<String>(
      operation: 'logEvent',
      invoke: () async => const AppsflyerCallResult(
        value: 'ok',
        result: AppsflyerResult(
          eventName: 'af_purchase',
          eventStandard: true,
          eventRevenue: 49.99,
          eventCurrency: 'USD',
          skanConversionValue: 12,
        ),
      ),
    );
    final a = attrsOf(spans.findSpanByName('appsflyer logEvent')!);
    expect(a['appsflyer.event.standard'], true);
    expect(a['appsflyer.event.revenue'], 49.99);
    expect(a['appsflyer.skan.conversion_value'], 12);
  });

  test('error sets span error', () async {
    await tracedAppsflyer<String>(
      operation: 'validatePurchase',
      invoke: () async => const AppsflyerCallResult(
        value: 'ok',
        result: AppsflyerResult(
          errorCode: 41,
          errorMessage: 'Invalid receipt',
        ),
      ),
    );
    expect(
      spans.findSpanByName('appsflyer validatePurchase')!.status,
      SpanStatusCode.Error,
    );
  });

  test('suppression skips spans', () async {
    await runWithoutAppsflyerInstrumentationAsync(() async {
      await tracedAppsflyer<String>(
        operation: 'initSdk',
        invoke: () async => const AppsflyerCallResult(value: 'v'),
      );
    });
    expect(spans.findSpansStartingWith('appsflyer '), isEmpty);
  });
}
