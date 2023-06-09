import 'package:flutter/cupertino.dart';

///Custom gradient decoration for [WaveAppBar] and [CustomActionButton]
class CustomContainerGradientDecoration {
  final Color topColor;
  final Color bottomColor;

  CustomContainerGradientDecoration(this.topColor, this.bottomColor);

  BoxDecoration get getCustomButtonDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          topColor,
          bottomColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(30.0),
    );
  }

  BoxDecoration get getCustomAppBarDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          topColor,
          bottomColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
    );
  }

  BoxDecoration get getCustomContainerDecoration {
    return BoxDecoration(
      gradient: LinearGradient(
        colors: [
          topColor,
          bottomColor,
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      borderRadius: BorderRadius.circular(12),
    );
  }
}
