import 'package:flutter/material.dart';
import 'package:wave/components/custom_ui_constants/button_container_decoration.dart';
import 'package:wave/components/custom_ui_constants/icons.dart';
import 'package:wave/extensions/context.dart';

///Generic [AppBar] widget shared across the app
class WaveAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final IconData icon;
  final Color topColor;
  final Color bottomColor;
  final double height;
  final bool tabs;
  const WaveAppBar(
      {super.key,
      required this.title,
      required this.icon,
      required this.topColor,
      required this.bottomColor,
      required this.height,
      required this.tabs});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      shadowColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: CustomContainerGradientDecoration(topColor, bottomColor)
            .getCustomAppBarDecoration,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 40,
          fontWeight: FontWeight.w900,
          color: context.textTheme.bodySmall!.color,
        ),
      ),
      leadingWidth: 90,
      leading: Icon(
        icon,
      ),
      titleSpacing: 50,
      toolbarHeight: context.height * .15,
      bottom: tabs
          ? TabBar(
              indicatorSize: TabBarIndicatorSize.label,
              tabs: [
                Tab(
                  text: context.translated.patrols,
                  icon: Icon(WaveIcons().patrolIcon),
                ),
                Tab(
                  text: context.translated.duties,
                  icon: Icon(WaveIcons().dutyIcon),
                ),
              ],
            )
          : null,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
