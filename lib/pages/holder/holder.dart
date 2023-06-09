import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:wave/auto_router.gr.dart';
import 'package:wave/extensions/context.dart';

class HolderPage extends StatefulWidget {
  const HolderPage({Key? key}) : super(key: key);

  @override
  State<HolderPage> createState() => _HolderPageState();
}

class _HolderPageState extends State<HolderPage> {
  @override
  Widget build(BuildContext context) {
    return AutoTabsScaffold(
      routes: const [
        HomeRouter(),
        PlannedRouter(),
        HistoryRouter(),
        SettingsRouter(),
      ],
      bottomNavigationBuilder: (context, tabsRouter) {
        return NavigationBar(
          height: context.height * .1,
          selectedIndex: tabsRouter.activeIndex,
          animationDuration: const Duration(milliseconds: 600),
          onDestinationSelected: (value) {
            tabsRouter.setActiveIndex(value);
          },
          destinations: [
            NavigationDestination(
              icon: const Icon(Icons.menu_outlined),
              selectedIcon: const Icon(Icons.menu),
              tooltip: context.translated.menuDestinationTooltip,
              label: context.translated.menuDestinationLabel,
            ),
            NavigationDestination(
              icon: const Icon(MdiIcons.calendarClock),
              selectedIcon: const Icon(MdiIcons.calendarClock),
              tooltip: context.translated.plannedDestinationTooltip,
              label: context.translated.plannedDestinationLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.history_outlined),
              selectedIcon: const Icon(Icons.history),
              tooltip: context.translated.historyDestinationTooltip,
              label: context.translated.historyDestinationLabel,
            ),
            NavigationDestination(
              icon: const Icon(Icons.settings_outlined),
              label: context.translated.settingsDestinationLabel,
              tooltip: context.translated.settingsDestinationTooltip,
              selectedIcon: const Icon(Icons.settings),
            )
          ],
        );
      },
      resizeToAvoidBottomInset: false,
    );
  }
}
