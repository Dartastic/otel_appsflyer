// Licensed under the Dartastic Pro Software License Agreement.
// Copyright 2025-2026 Mindful Software LLC d/b/a Dartastic.io, All rights reserved.

import 'package:dartastic_opentelemetry/dartastic_opentelemetry.dart';

import 'otel_appsflyer_suppression.dart';

const _tracerName = 'dartastic_otel_libs_appsflyer';

Tracer _tracer() => OTel.tracerProvider().getTracer(_tracerName);

class AppsflyerResult {
  const AppsflyerResult({
    this.appId,
    this.appsflyerUid,
    this.customerUserId,
    this.installSource,
    this.mediaSource,
    this.campaign,
    this.adset,
    this.adId,
    this.isFirstLaunch,
    this.eventName,
    this.eventStandard,
    this.eventRevenue,
    this.eventCurrency,
    this.skanConversionValue,
    this.ddlEventName,
    this.errorCode,
    this.errorMessage,
    this.statusCode,
  });

  /// Bundle id / package name.
  final String? appId;

  /// AppsFlyer unique device id.
  final String? appsflyerUid;

  /// `setCustomerUserId()` value (your end-user id).
  final String? customerUserId;

  /// `Organic` / `Non-organic` / `Restricted` — top-level attribution
  /// bucket.
  final String? installSource;

  /// Specific media source (`googleadwords_int`, `Facebook Ads`,
  /// `tiktokglobal_int`, `Email`, `applovin_int`, `unityads_int`,
  /// `mintegral_int`, etc.).
  final String? mediaSource;

  final String? campaign;
  final String? adset;

  /// AdSet ad id / creative id.
  final String? adId;

  /// `true` for the first launch (install) — fires the GCD callback.
  final bool? isFirstLaunch;

  final String? eventName;

  /// `true` when the event is one of AppsFlyer's standard events
  /// (`af_purchase` / `af_add_to_cart` / `af_complete_registration`
  /// / `af_search` / etc.).
  final bool? eventStandard;

  final double? eventRevenue;
  final String? eventCurrency;

  /// SKAdNetwork conversion value (0-63 for iOS 15, 0-127 for SKAN
  /// 4.0 coarse).
  final int? skanConversionValue;

  /// Deferred deep link event name from `onDeepLinking`.
  final String? ddlEventName;

  final int? errorCode;
  final String? errorMessage;

  final int? statusCode;
}

class AppsflyerCallResult<T> {
  const AppsflyerCallResult({required this.value, this.result});
  final T value;
  final AppsflyerResult? result;
}

/// Wraps an AppsFlyer SDK call in a CLIENT span. [operation] is one
/// of `initSdk`, `start`, `logEvent`, `setCustomerUserId`,
/// `validatePurchase`, `getConversionData`, `onDeepLinking`,
/// `setSharingFilter`, `subscribeForDeepLink`, `appendParametersToDeepLinkingURL`,
/// `setAdditionalData`, `anonymizeUser`, `stop`,
/// `requestATTracking`.
Future<T> tracedAppsflyer<T>({
  required String operation,
  required Future<AppsflyerCallResult<T>> Function() invoke,
}) async {
  if (appsflyerInstrumentationSuppressed()) {
    final r = await invoke();
    return r.value;
  }
  final m = <String, Object>{
    'rpc.system': 'appsflyer',
    'rpc.method': operation,
    'appsflyer.operation': operation,
  };

  final span = _tracer().startSpan(
    'appsflyer $operation',
    kind: SpanKind.client,
    attributes: OTel.attributesFromMap(m),
  );
  try {
    final r = await invoke();
    if (r.result != null) {
      final extras = <Attribute<Object>>[];
      if (r.result!.appId != null) {
        extras.add(OTel.attributeString(
          'appsflyer.app.id',
          r.result!.appId!,
        ));
      }
      if (r.result!.appsflyerUid != null) {
        extras.add(OTel.attributeString(
          'appsflyer.uid',
          r.result!.appsflyerUid!,
        ));
      }
      if (r.result!.customerUserId != null) {
        extras.add(OTel.attributeString(
          'appsflyer.customer_user_id',
          r.result!.customerUserId!,
        ));
      }
      if (r.result!.installSource != null) {
        extras.add(OTel.attributeString(
          'appsflyer.install.source',
          r.result!.installSource!,
        ));
      }
      if (r.result!.mediaSource != null) {
        extras.add(OTel.attributeString(
          'appsflyer.media_source',
          r.result!.mediaSource!,
        ));
      }
      if (r.result!.campaign != null) {
        extras.add(OTel.attributeString(
          'appsflyer.campaign',
          r.result!.campaign!,
        ));
      }
      if (r.result!.adset != null) {
        extras.add(OTel.attributeString(
          'appsflyer.adset',
          r.result!.adset!,
        ));
      }
      if (r.result!.adId != null) {
        extras.add(OTel.attributeString(
          'appsflyer.ad.id',
          r.result!.adId!,
        ));
      }
      if (r.result!.isFirstLaunch != null) {
        extras.add(OTel.attributeBool(
          'appsflyer.is_first_launch',
          r.result!.isFirstLaunch!,
        ));
      }
      if (r.result!.eventName != null) {
        extras.add(OTel.attributeString(
          'appsflyer.event.name',
          r.result!.eventName!,
        ));
      }
      if (r.result!.eventStandard != null) {
        extras.add(OTel.attributeBool(
          'appsflyer.event.standard',
          r.result!.eventStandard!,
        ));
      }
      if (r.result!.eventRevenue != null) {
        extras.add(OTel.attributeDouble(
          'appsflyer.event.revenue',
          r.result!.eventRevenue!,
        ));
      }
      if (r.result!.eventCurrency != null) {
        extras.add(OTel.attributeString(
          'appsflyer.event.currency',
          r.result!.eventCurrency!,
        ));
      }
      if (r.result!.skanConversionValue != null) {
        extras.add(OTel.attributeInt(
          'appsflyer.skan.conversion_value',
          r.result!.skanConversionValue!,
        ));
      }
      if (r.result!.ddlEventName != null) {
        extras.add(OTel.attributeString(
          'appsflyer.ddl.event_name',
          r.result!.ddlEventName!,
        ));
      }
      if (r.result!.errorCode != null) {
        extras.add(OTel.attributeInt(
          'appsflyer.error.code',
          r.result!.errorCode!,
        ));
        span.setStatus(
          SpanStatusCode.Error,
          'AppsFlyer error ${r.result!.errorCode}',
        );
      }
      if (r.result!.errorMessage != null) {
        extras.add(OTel.attributeString(
          'appsflyer.error.message',
          r.result!.errorMessage!,
        ));
      }
      if (r.result!.statusCode != null) {
        extras.add(OTel.attributeInt(
          'http.response.status_code',
          r.result!.statusCode!,
        ));
        if (r.result!.statusCode! >= 400) {
          span.setStatus(
            SpanStatusCode.Error,
            'AppsFlyer HTTP ${r.result!.statusCode}',
          );
        }
      }
      if (extras.isNotEmpty) span.addAttributes(OTel.attributes(extras));
    }
    return r.value;
  } catch (e, st) {
    span.addAttributes(OTel.attributes([
      OTel.attributeString(
        ErrorResource.errorType.key,
        e.runtimeType.toString(),
      ),
    ]));
    span.recordException(e, stackTrace: st);
    span.setStatus(SpanStatusCode.Error, e.toString());
    rethrow;
  } finally {
    span.end();
  }
}
