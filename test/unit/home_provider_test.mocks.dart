// Mocks generated by Mockito 5.4.6 from annotations
// in spacex_app/test/unit/home_provider_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i3;

import 'package:mockito/mockito.dart' as _i1;
import 'package:spacex_app/data/provider/cache_provider.dart' as _i2;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

/// A class which mocks [AppCacheProvider].
///
/// See the documentation for Mockito's code generation for more information.
class MockAppCacheProvider extends _i1.Mock implements _i2.AppCacheProvider {
  MockAppCacheProvider() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i3.Future<void> init() => (super.noSuchMethod(
        Invocation.method(
          #init,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<String?> getLastUpdate() => (super.noSuchMethod(
        Invocation.method(
          #getLastUpdate,
          [],
        ),
        returnValue: _i3.Future<String?>.value(),
      ) as _i3.Future<String?>);

  @override
  _i3.Future<void> cacheLaunches(List<dynamic>? launches) =>
      (super.noSuchMethod(
        Invocation.method(
          #cacheLaunches,
          [launches],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<dynamic>?> getCachedLaunches() => (super.noSuchMethod(
        Invocation.method(
          #getCachedLaunches,
          [],
        ),
        returnValue: _i3.Future<List<dynamic>?>.value(),
      ) as _i3.Future<List<dynamic>?>);

  @override
  _i3.Future<void> cacheRockets(List<dynamic>? rockets) => (super.noSuchMethod(
        Invocation.method(
          #cacheRockets,
          [rockets],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<List<dynamic>?> getCachedRockets() => (super.noSuchMethod(
        Invocation.method(
          #getCachedRockets,
          [],
        ),
        returnValue: _i3.Future<List<dynamic>?>.value(),
      ) as _i3.Future<List<dynamic>?>);

  @override
  _i3.Future<void> cacheCompany(Map<String, dynamic>? company) =>
      (super.noSuchMethod(
        Invocation.method(
          #cacheCompany,
          [company],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);

  @override
  _i3.Future<Map<String, dynamic>?> getCachedCompany() => (super.noSuchMethod(
        Invocation.method(
          #getCachedCompany,
          [],
        ),
        returnValue: _i3.Future<Map<String, dynamic>?>.value(),
      ) as _i3.Future<Map<String, dynamic>?>);

  @override
  _i3.Future<bool> shouldRefreshData() => (super.noSuchMethod(
        Invocation.method(
          #shouldRefreshData,
          [],
        ),
        returnValue: _i3.Future<bool>.value(false),
      ) as _i3.Future<bool>);

  @override
  _i3.Future<void> clearCache() => (super.noSuchMethod(
        Invocation.method(
          #clearCache,
          [],
        ),
        returnValue: _i3.Future<void>.value(),
        returnValueForMissingStub: _i3.Future<void>.value(),
      ) as _i3.Future<void>);
}
