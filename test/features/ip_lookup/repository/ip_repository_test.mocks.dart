// Mocks generated by Mockito 5.4.4 from annotations
// in iptracker/test/features/ip_lookup/repository/ip_repository_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i7;
import 'dart:ui' as _i6;

import 'package:iptracker/core/result/result.dart' as _i3;
import 'package:iptracker/core/services/ip_service.dart' as _i2;
import 'package:iptracker/core/services/ip_service_provider.dart' as _i4;
import 'package:iptracker/features/ip_lookup/models/ip_data.dart' as _i8;
import 'package:mockito/mockito.dart' as _i1;
import 'package:mockito/src/dummies.dart' as _i5;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeIPService_0 extends _i1.SmartFake implements _i2.IPService {
  _FakeIPService_0(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

class _FakeResult_1<T> extends _i1.SmartFake implements _i3.Result<T> {
  _FakeResult_1(
    Object parent,
    Invocation parentInvocation,
  ) : super(
          parent,
          parentInvocation,
        );
}

/// A class which mocks [IPServiceProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockIPServiceProvider extends _i1.Mock implements _i4.IPServiceProvider {
  MockIPServiceProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  List<String> get availableServiceNames => (super.noSuchMethod(
        Invocation.getter(#availableServiceNames),
        returnValue: <String>[],
      ) as List<String>);

  @override
  _i2.IPService get currentService => (super.noSuchMethod(
        Invocation.getter(#currentService),
        returnValue: _FakeIPService_0(
          this,
          Invocation.getter(#currentService),
        ),
      ) as _i2.IPService);

  @override
  String get currentServiceName => (super.noSuchMethod(
        Invocation.getter(#currentServiceName),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.getter(#currentServiceName),
        ),
      ) as String);

  @override
  bool get hasListeners => (super.noSuchMethod(
        Invocation.getter(#hasListeners),
        returnValue: false,
      ) as bool);

  @override
  void switchService(String? serviceName) => super.noSuchMethod(
        Invocation.method(
          #switchService,
          [serviceName],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void addListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #addListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void removeListener(_i6.VoidCallback? listener) => super.noSuchMethod(
        Invocation.method(
          #removeListener,
          [listener],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void dispose() => super.noSuchMethod(
        Invocation.method(
          #dispose,
          [],
        ),
        returnValueForMissingStub: null,
      );

  @override
  void notifyListeners() => super.noSuchMethod(
        Invocation.method(
          #notifyListeners,
          [],
        ),
        returnValueForMissingStub: null,
      );
}

/// A class which mocks [IPService].
///
/// See the documentation for Mockito's code generation for more information.
class MockIPService extends _i1.Mock implements _i2.IPService {
  MockIPService() {
    _i1.throwOnMissingStub(this);
  }

  @override
  String get providerName => (super.noSuchMethod(
        Invocation.getter(#providerName),
        returnValue: _i5.dummyValue<String>(
          this,
          Invocation.getter(#providerName),
        ),
      ) as String);

  @override
  _i7.Future<_i3.Result<_i8.IPData>> getMyIPData() => (super.noSuchMethod(
        Invocation.method(
          #getMyIPData,
          [],
        ),
        returnValue:
            _i7.Future<_i3.Result<_i8.IPData>>.value(_FakeResult_1<_i8.IPData>(
          this,
          Invocation.method(
            #getMyIPData,
            [],
          ),
        )),
      ) as _i7.Future<_i3.Result<_i8.IPData>>);

  @override
  _i7.Future<_i3.Result<_i8.IPData>> getIPData(String? ipAddress) =>
      (super.noSuchMethod(
        Invocation.method(
          #getIPData,
          [ipAddress],
        ),
        returnValue:
            _i7.Future<_i3.Result<_i8.IPData>>.value(_FakeResult_1<_i8.IPData>(
          this,
          Invocation.method(
            #getIPData,
            [ipAddress],
          ),
        )),
      ) as _i7.Future<_i3.Result<_i8.IPData>>);

  @override
  bool isValidIPAddress(String? ipAddress) => (super.noSuchMethod(
        Invocation.method(
          #isValidIPAddress,
          [ipAddress],
        ),
        returnValue: false,
      ) as bool);
}
