import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/modules/explore_module/models/opportunity_filter_model.dart';
import 'package:palette/utils/konstants.dart';

class EventTypeExploreFilterOption extends StatefulWidget {
  EventTypeExploreFilterOption(
      {Key? key, required this.opportunityFilterModel})
      : super(key: key);

  final OpportunityEventFilterModel opportunityFilterModel;

  @override
  _EventTypeExploreFilterOptionState createState() =>
      _EventTypeExploreFilterOptionState();
}

class _EventTypeExploreFilterOptionState
    extends State<EventTypeExploreFilterOption>
    with TickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
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
        width: widget.opportunityFilterModel.isSelected ? null : 36,
        margin: EdgeInsets.symmetric(horizontal: 4),
        decoration: widget.opportunityFilterModel.isSelected
            ? selectedBoxDecoration
            : unSelectedBoxDecoration,
        padding: EdgeInsets.symmetric(
          vertical: 2,
          horizontal: widget.opportunityFilterModel.isSelected ? 8 : 2,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              widget.opportunityFilterModel.icon,
              color: widget.opportunityFilterModel.isSelected
                  ? white
                  : defaultDark,
              height: 24,
              width: 24,
            ),
            if (widget.opportunityFilterModel.isSelected) SizedBox(width: 5),
            if (widget.opportunityFilterModel.isSelected)
              Text(
                widget.opportunityFilterModel.title,
                style: montserratSemiBoldTextStyle.copyWith(
                  fontSize: 14,
                  color: widget.opportunityFilterModel.isSelected
                      ? white
                      : defaultDark,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
