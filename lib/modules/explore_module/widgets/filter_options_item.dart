import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_components/common_components_link.dart';

class StatusTypeExploreFilterOption extends StatefulWidget {
  const StatusTypeExploreFilterOption({
    Key? key,
    required this.text,
    required this.index,
    required this.selectedIndex,
  }) : super(key: key);

  final String text;
  final int index;
  final int selectedIndex;

  @override
  _StatusTypeExploreFilterOptionState createState() =>
      _StatusTypeExploreFilterOptionState();
}

class _StatusTypeExploreFilterOptionState
    extends State<StatusTypeExploreFilterOption> with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    final decoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(8)),
      color: widget.selectedIndex == widget.index ? defaultDark : Colors.white,
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          blurRadius: 8,
          color: Colors.black.withOpacity(0.08),
        )
      ],
    );

    if (widget.index == 0) {
      return Container(
        padding: EdgeInsets.symmetric(
          vertical: 5,
          horizontal: 18,
        ),
        decoration: decoration,
        child: Center(
          child: Text(
            widget.text,
            style: montserratSemiBoldTextStyle.copyWith(
              fontSize: 14,
              color: widget.selectedIndex == widget.index ? white : defaultDark,
            ),
          ),
        ),
      );
    }

    final unSelectedBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      color: Colors.white,
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          blurRadius: 8,
          color: Colors.black.withOpacity(0.08),
        )
      ],
    );

    final selectedBoxDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(18)),
      color: defaultDark,
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          blurRadius: 8,
          color: Colors.black.withOpacity(0.08),
        )
      ],
    );

    return AnimatedSize(
      vsync: this,
      duration: const Duration(milliseconds: 250),
      child: Container(
        height: 36,
        width: widget.selectedIndex == widget.index ? null : 36,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: widget.selectedIndex == widget.index
            ? selectedBoxDecoration
            : unSelectedBoxDecoration,
        padding: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: widget.selectedIndex == widget.index ? 8 : 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              _getIconString(),
              color: widget.selectedIndex == widget.index ? white : defaultDark,
              height: 17,
              width: 17,
            ),
            if (widget.selectedIndex == widget.index) SizedBox(width: 5),
            if (widget.selectedIndex == widget.index)
              Text(
                widget.text,
                style: montserratSemiBoldTextStyle.copyWith(
                  fontSize: 14,
                  color: widget.selectedIndex == widget.index
                      ? white
                      : defaultDark,
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _getIconString() {
    if (widget.index == 1) {
      return 'images/done_enrolled.svg';
    } else {
      return 'images/recommended_by_icon.svg';
    }
  }
}
