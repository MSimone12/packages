// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import Flutter
import UIKit

extension FlutterError: Error {}

/**
 * This plugin handles the native side of the integration tests in
 * example/integration_test/.
 */
public class TestPlugin: NSObject, FlutterPlugin, HostIntegrationCoreApi {
  var flutterAPI: FlutterIntegrationCoreApi

  public static func register(with registrar: FlutterPluginRegistrar) {
    let plugin = TestPlugin(binaryMessenger: registrar.messenger())
    HostIntegrationCoreApiSetup.setUp(binaryMessenger: registrar.messenger(), api: plugin)
  }

  init(binaryMessenger: FlutterBinaryMessenger) {
    flutterAPI = FlutterIntegrationCoreApi(binaryMessenger: binaryMessenger)
  }

  // MARK: HostIntegrationCoreApi implementation

  public func noop() {

  }

  public func echo(_ everything: AllTypes) -> AllTypes {
    return everything
  }

  public func echo(_ everything: AllNullableTypes?) -> AllNullableTypes? {
    return everything
  }

  public func throwError() throws -> Any? {
    throw FlutterError(code: "code", message: "message", details: "details")
  }

  public func throwErrorFromVoid() throws {
    throw FlutterError(code: "code", message: "message", details: "details")
  }

  public func throwFlutterError() throws -> Any? {
    throw FlutterError(code: "code", message: "message", details: "details")
  }

  public func echo(_ anInt: Int64) -> Int64 {
    return anInt
  }

  public func echo(_ aDouble: Double) -> Double {
    return aDouble
  }

  public func echo(_ aBool: Bool) -> Bool {
    return aBool
  }

  public func echo(_ aString: String) -> String {
    return aString
  }

  public func echo(_ aUint8List: FlutterStandardTypedData) -> FlutterStandardTypedData {
    return aUint8List
  }

  public func echo(_ anObject: Any) -> Any {
    return anObject
  }

  public func echo(_ aList: [Any?]) throws -> [Any?] {
    return aList
  }

  public func echo(_ aMap: [String?: Any?]) throws -> [String?: Any?] {
    return aMap
  }

  public func extractNestedNullableString(from wrapper: AllNullableTypesWrapper) -> String? {
    return wrapper.values.aNullableString;
  }

  public func createNestedObject(with nullableString: String?) -> AllNullableTypesWrapper {
    return AllNullableTypesWrapper(values: AllNullableTypes(aNullableString: nullableString))
  }

  public func sendMultipleNullableTypes(aBool aNullableBool: Bool?, anInt aNullableInt: Int64?, aString aNullableString: String?) -> AllNullableTypes {
    let someThings = AllNullableTypes(aNullableBool: aNullableBool, aNullableInt: aNullableInt, aNullableString: aNullableString)
    return someThings
  }

  public func echo(_ aNullableInt: Int64?) -> Int64? {
    return aNullableInt
  }

  public func echo(_ aNullableDouble: Double?) -> Double? {
    return aNullableDouble
  }

  public func echo(_ aNullableBool: Bool?) -> Bool? {
    return aNullableBool
  }

  public func echo(_ aNullableString: String?) -> String? {
    return aNullableString
  }

  public func echo(_ aNullableUint8List: FlutterStandardTypedData?) -> FlutterStandardTypedData? {
    return aNullableUint8List
  }

  public func echo(_ aNullableObject: Any?) -> Any? {
    return aNullableObject
  }

  public func echoNullable(_ aNullableList: [Any?]?) throws -> [Any?]? {
    return aNullableList
  }

  public func echoNullable(_ aNullableMap: [String?: Any?]?) throws -> [String?: Any?]? {
    return aNullableMap
  }

  public func noopAsync(completion: @escaping (Result<Void, Error>) -> Void) {
    completion(.success(Void()))
  }

  public func throwAsyncError(completion: @escaping (Result<Any?, Error>) -> Void) {
    completion(.failure(FlutterError(code: "code", message: "message", details: "details")))
  }

  public func throwAsyncErrorFromVoid(completion: @escaping (Result<Void, Error>) -> Void) {
    completion(.failure(FlutterError(code: "code", message: "message", details: "details")))
  }

  public func throwAsyncFlutterError(completion: @escaping (Result<Any?, Error>) -> Void) {
    completion(.failure(FlutterError(code: "code", message: "message", details: "details")))
  }

  public func echoAsync(_ everything: AllTypes, completion: @escaping (Result<AllTypes, Error>) -> Void) {
    completion(.success(everything))
  }

  public func echoAsync(_ everything: AllNullableTypes?, completion: @escaping (Result<AllNullableTypes?, Error>) -> Void) {
    completion(.success(everything))
  }

  public func echoAsync(_ anInt: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
    completion(.success(anInt))
  }

  public func echoAsync(_ aDouble: Double, completion: @escaping (Result<Double, Error>) -> Void) {
    completion(.success(aDouble))
  }

  public func echoAsync(_ aBool: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
    completion(.success(aBool))
  }

  public func echoAsync(_ aString: String, completion: @escaping (Result<String, Error>) -> Void) {
    completion(.success(aString))
  }

  public func echoAsync(_ aUint8List: FlutterStandardTypedData, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
    completion(.success(aUint8List))
  }

  public func echoAsync(_ anObject: Any, completion: @escaping (Result<Any, Error>) -> Void) {
    completion(.success(anObject))
  }

  public func echoAsync(_ aList: [Any?], completion: @escaping (Result<[Any?], Error>) -> Void) {
    completion(.success(aList))
  }

  public func echoAsync(_ aMap: [String?: Any?], completion: @escaping (Result<[String?: Any?], Error>) -> Void) {
    completion(.success(aMap))
  }

  public func echoAsyncNullable(_ anInt: Int64?, completion: @escaping (Result<Int64?, Error>) -> Void) {
    completion(.success(anInt))
  }

  public func echoAsyncNullable(_ aDouble: Double?, completion: @escaping (Result<Double?, Error>) -> Void) {
    completion(.success(aDouble))
  }

  public func echoAsyncNullable(_ aBool: Bool?, completion: @escaping (Result<Bool?, Error>) -> Void) {
    completion(.success(aBool))
  }

  public func echoAsyncNullable(_ aString: String?, completion: @escaping (Result<String?, Error>) -> Void) {
    completion(.success(aString))
  }

  public func echoAsyncNullable(_ aUint8List: FlutterStandardTypedData?, completion: @escaping (Result<FlutterStandardTypedData?, Error>) -> Void) {
    completion(.success(aUint8List))
  }

  public func echoAsyncNullable(_ anObject: Any?, completion: @escaping (Result<Any?, Error>) -> Void) {
    completion(.success(anObject))
  }

  public func echoAsyncNullable(_ aList: [Any?]?, completion: @escaping (Result<[Any?]?, Error>) -> Void) {
    completion(.success(aList))
  }

  public func echAsyncoNullable(_ aMap: [String?: Any?]?, completion: @escaping (Result<[String?: Any?]?, Error>) -> Void) {
    completion(.success(aMap))
  }

  public func callFlutterNoop(completion: @escaping (Result<Void, Error>) -> Void) {
    flutterAPI.noop() {
      completion(.success(Void()))
    }
  }

  public func callFlutterThrowError(completion: @escaping (Result<Any?, Error>) -> Void) {
    // TODO: (tarrinneal) Once flutter api error handling is added, enable these tests.
    // See issue https://github.com/flutter/flutter/issues/118243
  }

  public func callFlutterThrowErrorFromVoid(completion: @escaping (Result<Void, Error>) -> Void) {
    // TODO: (tarrinneal) Once flutter api error handling is added, enable these tests.
    // See issue https://github.com/flutter/flutter/issues/118243
  }

  public func callFlutterEcho(_ everything: AllTypes, completion: @escaping (Result<AllTypes, Error>) -> Void) {
    flutterAPI.echo(everything) { 
      completion(.success($0)) 
    }
  }

  public func callFlutterSendMultipleNullableTypes(
    aBool aNullableBool: Bool?,
    anInt aNullableInt: Int64?,
    aString aNullableString: String?,
    completion: @escaping (Result<AllNullableTypes, Error>) -> Void
  ) {
    flutterAPI.sendMultipleNullableTypes(
      aBool: aNullableBool,
      anInt: aNullableInt,
      aString: aNullableString
    ) {
      completion(.success($0))
    }
  }

  public func callFlutterEcho(_ aBool: Bool, completion: @escaping (Result<Bool, Error>) -> Void) {
    flutterAPI.echo(aBool) {
      completion(.success($0))
    }
  }

  public func callFlutterEcho(_ anInt: Int64, completion: @escaping (Result<Int64, Error>) -> Void) {
    flutterAPI.echo(anInt) {
      completion(.success($0))
    }
  }

  public func callFlutterEcho(_ aDouble: Double, completion: @escaping (Result<Double, Error>) -> Void) {
    flutterAPI.echo(aDouble) {
      completion(.success($0))
    }
  }

  public func callFlutterEcho(_ aString: String, completion: @escaping (Result<String, Error>) -> Void) {
    flutterAPI.echo(aString) {
      completion(.success($0))
    }
  }

  public func callFlutterEcho(_ aList: FlutterStandardTypedData, completion: @escaping (Result<FlutterStandardTypedData, Error>) -> Void) {
    flutterAPI.echo(aList) {
      completion(.success($0))
    }
  }

  public func callFlutterEcho(_ aList: [Any?], completion: @escaping (Result<[Any?], Error>) -> Void) {
    flutterAPI.echo(aList) {
      completion(.success($0))
    }
  }

  public func callFlutterEcho(_ aMap: [String? : Any?], completion: @escaping (Result<[String? : Any?], Error>) -> Void) {
    flutterAPI.echo(aMap) {
      completion(.success($0))
    }
  }

  public func callFlutterEchoNullable(_ aBool: Bool?, completion: @escaping (Result<Bool?, Error>) -> Void) {
    flutterAPI.echoNullable(aBool) {
      completion(.success($0))
    }
  }

  public func callFlutterEchoNullable(_ anInt: Int64?, completion: @escaping (Result<Int64?, Error>) -> Void) {
    flutterAPI.echoNullable(anInt) {
      completion(.success($0))
    }
  }

  public func callFlutterEchoNullable(_ aDouble: Double?, completion: @escaping (Result<Double?, Error>) -> Void) {
    flutterAPI.echoNullable(aDouble) {
      completion(.success($0))
    }
  }

  public func callFlutterEchoNullable(_ aString: String?, completion: @escaping (Result<String?, Error>) -> Void) {
    flutterAPI.echoNullable(aString) {
      completion(.success($0))
    }
  }
  
  public func callFlutterEchoNullable(_ aList: FlutterStandardTypedData?, completion: @escaping (Result<FlutterStandardTypedData?, Error>) -> Void) {
    flutterAPI.echoNullable(aList) {
      completion(.success($0))
    }
  }

  public func callFlutterEchoNullable(_ aList: [Any?]?, completion: @escaping (Result<[Any?]?, Error>) -> Void) {
    flutterAPI.echoNullable(aList) {
      completion(.success($0))
    }
  }

  public func callFlutterEchoNullable(_ aMap: [String? : Any?]?, completion: @escaping (Result<[String? : Any?]?, Error>) -> Void) {
    flutterAPI.echoNullable(aMap) {
      completion(.success($0))
    }
  }
}
