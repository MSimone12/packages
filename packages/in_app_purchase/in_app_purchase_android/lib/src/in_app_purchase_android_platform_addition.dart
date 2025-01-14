// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/services.dart';
import 'package:in_app_purchase_platform_interface/in_app_purchase_platform_interface.dart';

import '../billing_client_wrappers.dart';
import '../in_app_purchase_android.dart';

/// Contains InApp Purchase features that are only available on PlayStore.
class InAppPurchaseAndroidPlatformAddition
    extends InAppPurchasePlatformAddition {
  /// Creates a [InAppPurchaseAndroidPlatformAddition] which uses the supplied
  /// `BillingClientManager` to provide Android specific features.
  InAppPurchaseAndroidPlatformAddition(this._billingClientManager);

  /// Whether pending purchase is enabled.
  ///
  ///  **Deprecation warning:** it is no longer required to call
  /// [enablePendingPurchases] when initializing your application. From now on
  /// this is handled internally and the [enablePendingPurchase] property will
  /// always return `true`.
  ///
  // ignore: deprecated_member_use_from_same_package
  /// See also [enablePendingPurchases] for more on pending purchases.
  @Deprecated(
      'The requirement to call `enablePendingPurchases()` has become obsolete '
      "since Google Play no longer accepts app submissions that don't support "
      'pending purchases.')
  static bool get enablePendingPurchase => true;

  /// Enable the [InAppPurchaseConnection] to handle pending purchases.
  ///
  /// **Deprecation warning:** it is no longer required to call
  /// [enablePendingPurchases] when initializing your application.
  @Deprecated(
      'The requirement to call `enablePendingPurchases()` has become obsolete '
      "since Google Play no longer accepts app submissions that don't support "
      'pending purchases.')
  static void enablePendingPurchases() {
    // No-op, until it is time to completely remove this method from the API.
  }

  final BillingClientManager _billingClientManager;

  /// Mark that the user has consumed a product.
  ///
  /// You are responsible for consuming all consumable purchases once they are
  /// delivered. The user won't be able to buy the same product again until the
  /// purchase of the product is consumed.
  Future<BillingResultWrapper> consumePurchase(PurchaseDetails purchase) {
    if (purchase.verificationData == null) {
      throw ArgumentError(
          'consumePurchase unsuccessful. The `purchase.verificationData` is not valid');
    }
    return _billingClientManager.runWithClient(
      (BillingClient client) =>
          client.consumeAsync(purchase.verificationData.serverVerificationData),
    );
  }

  /// Query all previous purchases.
  ///
  /// The `applicationUserName` should match whatever was sent in the initial
  /// `PurchaseParam`, if anything. If no `applicationUserName` was specified in
  /// the initial `PurchaseParam`, use `null`.
  ///
  /// This does not return consumed products. If you want to restore unused
  /// consumable products, you need to persist consumable product information
  /// for your user on your own server.
  ///
  /// See also:
  ///
  ///  * [refreshPurchaseVerificationData], for reloading failed
  ///    [PurchaseDetails.verificationData].
  Future<QueryPurchaseDetailsResponse> queryPastPurchases(
      {String? applicationUserName}) async {
    List<PurchasesResultWrapper> responses;
    PlatformException? exception;

    try {
      responses = await Future.wait(<Future<PurchasesResultWrapper>>[
        _billingClientManager.runWithClient(
          (BillingClient client) => client.queryPurchases(ProductType.inapp),
        ),
        _billingClientManager.runWithClient(
          (BillingClient client) => client.queryPurchases(ProductType.subs),
        ),
      ]);
    } on PlatformException catch (e) {
      exception = e;
      responses = <PurchasesResultWrapper>[
        PurchasesResultWrapper(
          responseCode: BillingResponse.error,
          purchasesList: const <PurchaseWrapper>[],
          billingResult: BillingResultWrapper(
            responseCode: BillingResponse.error,
            debugMessage: e.details.toString(),
          ),
        ),
        PurchasesResultWrapper(
          responseCode: BillingResponse.error,
          purchasesList: const <PurchaseWrapper>[],
          billingResult: BillingResultWrapper(
            responseCode: BillingResponse.error,
            debugMessage: e.details.toString(),
          ),
        )
      ];
    }

    final Set<String> errorCodeSet = responses
        .where((PurchasesResultWrapper response) =>
            response.responseCode != BillingResponse.ok)
        .map((PurchasesResultWrapper response) =>
            response.responseCode.toString())
        .toSet();

    final String errorMessage =
        errorCodeSet.isNotEmpty ? errorCodeSet.join(', ') : '';

    final List<GooglePlayPurchaseDetails> pastPurchases = responses
        .expand((PurchasesResultWrapper response) => response.purchasesList)
        .expand((PurchaseWrapper purchaseWrapper) =>
            GooglePlayPurchaseDetails.fromPurchase(purchaseWrapper))
        .toList();

    IAPError? error;
    if (exception != null) {
      error = IAPError(
          source: kIAPSource,
          code: exception.code,
          message: exception.message ?? '',
          details: exception.details);
    } else if (errorMessage.isNotEmpty) {
      error = IAPError(
          source: kIAPSource,
          code: kRestoredPurchaseErrorCode,
          message: errorMessage);
    }

    return QueryPurchaseDetailsResponse(
        pastPurchases: pastPurchases, error: error);
  }

  /// Checks if the specified feature or capability is supported by the Play Store.
  /// Call this to check if a [BillingClientFeature] is supported by the device.
  Future<bool> isFeatureSupported(BillingClientFeature feature) async {
    return _billingClientManager.runWithClientNonRetryable(
      (BillingClient client) => client.isFeatureSupported(feature),
    );
  }
}
