import 'package:flutter/material.dart';
import 'package:wave/components/material_components/status_page_appbar.dart';
import 'package:wave/pages/holder/history/history_tabs/duty_history.dart';
import 'package:wave/pages/holder/history/history_tabs/patrol_history.dart';
import 'package:wave/extensions/context.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: WaveAppBar(
          tabs: true,
          title: context.translated.historyPageTitle,
          icon: Icons.history_outlined,
          topColor: const Color(0xff005F8E),
          bottomColor: const Color(0xfc051f37).withOpacity(0),
          height: context.height * 0.2,
        ),
        body: const TabBarView(
          children: [
            PatrolHistory(),
            DutyHistory(),
          ],
        ),
      ),
    );
  }
}
