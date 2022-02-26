import 'package:flutter/material.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:palette/utils/konstants.dart';

class LiquidSwipeTransition extends StatefulWidget {
  final List<Widget> pages;

  LiquidSwipeTransition({required this.pages});
  @override
  _LiquidSwipeTransitionState createState() => _LiquidSwipeTransitionState();
}

class _LiquidSwipeTransitionState extends State<LiquidSwipeTransition> {
  int page = 0;
  LiquidController? liquidController;

  @override
  void initState() {
    liquidController = LiquidController();
    super.initState();
  }

  pageChangeCallback(int lpage) {
    setState(() {
      page = lpage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return LiquidSwipe(
      pages: widget.pages,
      positionSlideIcon: 0.98,
      enableLoop: false,
      slideIconWidget: page == 0
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.arrow_back_ios,
                  color: defaultDark,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'Explore',
                    style: roboto700.copyWith(fontSize: 11),
                  ),
                )
              ],
            )
          : Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              children: [
                Icon(
                  Icons.arrow_forward_ios,
                  color: defaultDark,
                ),
                SizedBox(width: 10.0),
                Text(
                  'My Profile',
                  style: roboto700,
                )
              ],
            ),
      onPageChangeCallback: pageChangeCallback,
      waveType: WaveType.liquidReveal,
      liquidController: liquidController,
      ignoreUserGestureWhileAnimating: true,
    );
  }
}
