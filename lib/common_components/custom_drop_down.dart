import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/konstants.dart';

class CustomDropDown extends StatefulWidget {
  final String title;
  final List<String> options;
  final Function(String) optionSelected;
  final TextStyle? optionStyle;

  CustomDropDown({
    Key? key,
    required this.title,
    required this.options,
    required this.optionSelected,
    this.optionStyle,
  }) : super(key: key);

  @override
  _CustomDropDownState createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  var expanded = false;
  String? title;
  var optionSelectedAtLeastOnce = false;
  Key? key;
  final radius = Radius.circular(12);

  @override
  void initState() {
    super.initState();
    title = widget.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: expanded
            ? BorderRadius.only(
                topLeft: radius,
                topRight: radius,
              )
            : BorderRadius.all(radius),
        color: offWhite,
      ),
      child: ListTileTheme(
        dense: true,
        child: ExpansionTile(
          onExpansionChanged: (isExpanded) {
            setState(() {
              expanded = isExpanded;
            });
          },
          trailing: expanded
              ? SvgPicture.asset(
                  'images/dropdown_inverted.svg',
                  height: 14,
                  width: 16,
                  semanticsLabel: "dropdown",
                )
              : SvgPicture.asset(
                  'images/dropdown.svg',
                  height: 14,
                  width: 16,
                  semanticsLabel: "dropdown",
                ),
          key: key,
          title: Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              title ?? widget.title,
              style: optionSelectedAtLeastOnce
                  ? widget.optionStyle ??
                      robotoTextStyle.copyWith(fontWeight: FontWeight.bold)
                  : robotoTextStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: unselectedColor.withOpacity(0.6),
                    ),
            ),
          ),
          children: widget.options.map((String option) {
            return Padding(
              padding: const EdgeInsets.only(left: 8.0),
              child: ListTile(
                onTap: () {
                  widget.optionSelected(option);
                  setState(() {
                    title = option;
                    optionSelectedAtLeastOnce = true;
                    expanded = false;
                  });
                  key = GlobalKey();
                },
                title: Text(
                  option,
                  style: widget.optionStyle ??
                      robotoTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
