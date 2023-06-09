import 'package:auto_route/auto_route.dart';
import 'package:auto_route/empty_router_widgets.dart';
import 'package:wave/pages/holder/home/duty.dart';
import 'package:wave/pages/holder/history/history.dart';
import 'package:wave/pages/holder/holder.dart';
import 'package:wave/pages/holder/home/home.dart';
import 'package:wave/pages/login.dart';
import 'package:wave/pages/holder/home/patrol.dart';
import 'package:wave/pages/holder/planned.dart';
import 'package:wave/pages/settings.dart';

@MaterialAutoRouter(
  deferredLoading: true,
  replaceInRouteName: 'Page,Route',
  routes: <AutoRoute>[
    AutoRoute(
      path: '/',
      page: LoginPage,
      name: 'LoginRouter',
    ),
    AutoRoute(
      page: HolderPage,
      path: 'holder',
      name: 'HolderRoute',
      children: [
        AutoRoute(
          name: 'HomeRouter',
          path: 'home',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              name: 'FormRouter',
              path: '',
              page: HomePage,
            ),
            AutoRoute(
              name: 'PatrolRouter',
              path: 'patrol',
              page: PatrolPage,
            ),
            CustomRoute(
              name: 'DutyRouter',
              path: 'duty',
              page: DutyPage,
            ),
          ],
        ),
        AutoRoute(
          path: 'history',
          name: 'HistoryRouter',
          page: HistoryPage,
        ),
        AutoRoute(
          name: 'PlannedRouter',
          path: 'planned',
          page: EmptyRouterPage,
          children: [
            AutoRoute(
              path: '',
              page: DutyFuturePage,
            ),
            AutoRoute(
              name: 'DutyRouterPlanned',
              path: 'dutyPlanned',
              page: DutyPage,
            ),
          ],
        ),
        AutoRoute(
          name: 'SettingsRouter',
          path: 'settings',
          page: SettingsPage,
        )
      ],
    ),
  ],
)
class $AppRouter {}
