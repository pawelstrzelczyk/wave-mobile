// **************************************************************************
// AutoRouteGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouteGenerator
// **************************************************************************
//
// ignore_for_file: type=lint

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:auto_route/auto_route.dart' as _i10;
import 'package:auto_route/empty_router_widgets.dart' deferred as _i3;
import 'package:flutter/material.dart' as _i11;

import 'pages/holder/history/history.dart' deferred as _i4;
import 'pages/holder/holder.dart' deferred as _i2;
import 'pages/holder/home/duty.dart' deferred as _i8;
import 'pages/holder/home/home.dart' deferred as _i6;
import 'pages/holder/home/patrol.dart' deferred as _i7;
import 'pages/holder/planned.dart' deferred as _i9;
import 'pages/login.dart' deferred as _i1;
import 'pages/settings.dart' deferred as _i5;

class AppRouter extends _i10.RootStackRouter {
  AppRouter([_i11.GlobalKey<_i11.NavigatorState>? navigatorKey])
      : super(navigatorKey);

  @override
  final Map<String, _i10.PageFactory> pagesMap = {
    LoginRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i1.loadLibrary,
          () => _i1.LoginPage(),
        ),
      );
    },
    HolderRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i2.loadLibrary,
          () => _i2.HolderPage(),
        ),
      );
    },
    HomeRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i3.loadLibrary,
          () => _i3.EmptyRouterPage(),
        ),
      );
    },
    HistoryRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i4.loadLibrary,
          () => _i4.HistoryPage(),
        ),
      );
    },
    PlannedRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i3.loadLibrary,
          () => _i3.EmptyRouterPage(),
        ),
      );
    },
    SettingsRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i5.loadLibrary,
          () => _i5.SettingsPage(),
        ),
      );
    },
    FormRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i6.loadLibrary,
          () => _i6.HomePage(),
        ),
      );
    },
    PatrolRouter.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i7.loadLibrary,
          () => _i7.PatrolPage(),
        ),
      );
    },
    DutyRouter.name: (routeData) {
      final args = routeData.argsAs<DutyRouterArgs>(
          orElse: () => const DutyRouterArgs());
      return _i10.CustomPage<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i8.loadLibrary,
          () => _i8.DutyPage(key: args.key),
        ),
        opaque: true,
        barrierDismissible: false,
      );
    },
    DutyFutureRoute.name: (routeData) {
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i9.loadLibrary,
          () => _i9.DutyFuturePage(),
        ),
      );
    },
    DutyRouterPlanned.name: (routeData) {
      final args = routeData.argsAs<DutyRouterPlannedArgs>(
          orElse: () => const DutyRouterPlannedArgs());
      return _i10.MaterialPageX<dynamic>(
        routeData: routeData,
        child: _i10.DeferredWidget(
          _i8.loadLibrary,
          () => _i8.DutyPage(key: args.key),
        ),
      );
    },
  };

  @override
  List<_i10.RouteConfig> get routes => [
        _i10.RouteConfig(
          LoginRouter.name,
          path: '/',
          deferredLoading: true,
        ),
        _i10.RouteConfig(
          HolderRoute.name,
          path: 'holder',
          deferredLoading: true,
          children: [
            _i10.RouteConfig(
              HomeRouter.name,
              path: 'home',
              parent: HolderRoute.name,
              deferredLoading: true,
              children: [
                _i10.RouteConfig(
                  FormRouter.name,
                  path: '',
                  parent: HomeRouter.name,
                  deferredLoading: true,
                ),
                _i10.RouteConfig(
                  PatrolRouter.name,
                  path: 'patrol',
                  parent: HomeRouter.name,
                  deferredLoading: true,
                ),
                _i10.RouteConfig(
                  DutyRouter.name,
                  path: 'duty',
                  parent: HomeRouter.name,
                  deferredLoading: true,
                ),
              ],
            ),
            _i10.RouteConfig(
              HistoryRouter.name,
              path: 'history',
              parent: HolderRoute.name,
              deferredLoading: true,
            ),
            _i10.RouteConfig(
              PlannedRouter.name,
              path: 'planned',
              parent: HolderRoute.name,
              deferredLoading: true,
              children: [
                _i10.RouteConfig(
                  DutyFutureRoute.name,
                  path: '',
                  parent: PlannedRouter.name,
                  deferredLoading: true,
                ),
                _i10.RouteConfig(
                  DutyRouterPlanned.name,
                  path: 'dutyPlanned',
                  parent: PlannedRouter.name,
                  deferredLoading: true,
                ),
              ],
            ),
            _i10.RouteConfig(
              SettingsRouter.name,
              path: 'settings',
              parent: HolderRoute.name,
              deferredLoading: true,
            ),
          ],
        ),
      ];
}

/// generated route for
/// [_i1.LoginPage]
class LoginRouter extends _i10.PageRouteInfo<void> {
  const LoginRouter()
      : super(
          LoginRouter.name,
          path: '/',
        );

  static const String name = 'LoginRouter';
}

/// generated route for
/// [_i2.HolderPage]
class HolderRoute extends _i10.PageRouteInfo<void> {
  const HolderRoute({List<_i10.PageRouteInfo>? children})
      : super(
          HolderRoute.name,
          path: 'holder',
          initialChildren: children,
        );

  static const String name = 'HolderRoute';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class HomeRouter extends _i10.PageRouteInfo<void> {
  const HomeRouter({List<_i10.PageRouteInfo>? children})
      : super(
          HomeRouter.name,
          path: 'home',
          initialChildren: children,
        );

  static const String name = 'HomeRouter';
}

/// generated route for
/// [_i4.HistoryPage]
class HistoryRouter extends _i10.PageRouteInfo<void> {
  const HistoryRouter()
      : super(
          HistoryRouter.name,
          path: 'history',
        );

  static const String name = 'HistoryRouter';
}

/// generated route for
/// [_i3.EmptyRouterPage]
class PlannedRouter extends _i10.PageRouteInfo<void> {
  const PlannedRouter({List<_i10.PageRouteInfo>? children})
      : super(
          PlannedRouter.name,
          path: 'planned',
          initialChildren: children,
        );

  static const String name = 'PlannedRouter';
}

/// generated route for
/// [_i5.SettingsPage]
class SettingsRouter extends _i10.PageRouteInfo<void> {
  const SettingsRouter()
      : super(
          SettingsRouter.name,
          path: 'settings',
        );

  static const String name = 'SettingsRouter';
}

/// generated route for
/// [_i6.HomePage]
class FormRouter extends _i10.PageRouteInfo<void> {
  const FormRouter()
      : super(
          FormRouter.name,
          path: '',
        );

  static const String name = 'FormRouter';
}

/// generated route for
/// [_i7.PatrolPage]
class PatrolRouter extends _i10.PageRouteInfo<void> {
  const PatrolRouter()
      : super(
          PatrolRouter.name,
          path: 'patrol',
        );

  static const String name = 'PatrolRouter';
}

/// generated route for
/// [_i8.DutyPage]
class DutyRouter extends _i10.PageRouteInfo<DutyRouterArgs> {
  DutyRouter({_i11.Key? key})
      : super(
          DutyRouter.name,
          path: 'duty',
          args: DutyRouterArgs(key: key),
        );

  static const String name = 'DutyRouter';
}

class DutyRouterArgs {
  const DutyRouterArgs({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return 'DutyRouterArgs{key: $key}';
  }
}

/// generated route for
/// [_i9.DutyFuturePage]
class DutyFutureRoute extends _i10.PageRouteInfo<void> {
  const DutyFutureRoute()
      : super(
          DutyFutureRoute.name,
          path: '',
        );

  static const String name = 'DutyFutureRoute';
}

/// generated route for
/// [_i8.DutyPage]
class DutyRouterPlanned extends _i10.PageRouteInfo<DutyRouterPlannedArgs> {
  DutyRouterPlanned({_i11.Key? key})
      : super(
          DutyRouterPlanned.name,
          path: 'dutyPlanned',
          args: DutyRouterPlannedArgs(key: key),
        );

  static const String name = 'DutyRouterPlanned';
}

class DutyRouterPlannedArgs {
  const DutyRouterPlannedArgs({this.key});

  final _i11.Key? key;

  @override
  String toString() {
    return 'DutyRouterPlannedArgs{key: $key}';
  }
}
