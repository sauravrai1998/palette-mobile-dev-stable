import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/konstants.dart';

class CommonTextAreaOpportunity extends StatefulWidget {
  final String hintText;
  final TextEditingController controller;
  final Function? onChanged;
  final bool errorFlag;

  const CommonTextAreaOpportunity({
    Key? key,
    required this.hintText,
    required this.controller,
    this.onChanged,
    this.errorFlag = false,
  }) : super(key: key);

  @override
  _CommonTextAreaOpportunityState createState() =>
      _CommonTextAreaOpportunityState();
}

class _CommonTextAreaOpportunityState extends State<CommonTextAreaOpportunity> {
  String _enterText = '';
  @override
  Widget build(BuildContext context) {
    _enterText = widget.controller.text;
    return Container(
      height: 156,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: widget.errorFlag ? todoListActiveTab : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 13.5),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10,top: 15),
              child: SvgPicture.asset(
                'images/test_description.svg',
                width: 24,
                height: 24,
                color: _enterText.isNotEmpty || widget.errorFlag
                    ? widget.errorFlag
                        ? todoListActiveTab
                        : defaultDark
                    : defaultDark.withOpacity(0.5),
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _enterText.isNotEmpty
                    ? Text(widget.hintText,
                        style: roboto700.copyWith(
                            color: defaultDark.withOpacity(0.5),
                            fontSize: 10))
                    : Container(),
                Container(
                  width: 260,
                  child: TextField(
                    autofocus: false,
                    style: roboto700.copyWith(color: defaultDark, fontSize: 14),
                    keyboardType: TextInputType.multiline,
                    textInputAction: TextInputAction.newline,
                    minLines: 1,
                    maxLines: 7,
                    decoration: authInputFieldDecoration.copyWith(
                        hintStyle: roboto700.copyWith(
                          fontSize: 14,
                          color: widget.errorFlag
                              ? todoListActiveTab
                              : defaultDark.withOpacity(0.6),
                        ),
                        hintText: widget.hintText,
                        helperStyle: roboto700.copyWith()),
                    controller: widget.controller,
                    onChanged: (change) {
                      setState(() {
                        _enterText = change;
                      });
                      if (widget.onChanged != null) {
                        widget.onChanged!(change);
                      }
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
