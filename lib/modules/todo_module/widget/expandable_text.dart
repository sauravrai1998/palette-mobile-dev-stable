import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/todo_module/models/todo_status.dart';

class ExpandableText extends StatefulWidget {
  ExpandableText(this.text, this.status);

  final String text;
  final String status;
  bool isExpanded = false;

  @override
  _ExpandableTextState createState() => _ExpandableTextState();
}

class _ExpandableTextState extends State<ExpandableText>
    with TickerProviderStateMixin<ExpandableText> {
  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return Stack(
      children: [
        Card(
          elevation: 4,
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "DESCRIPTION",
                    style: roboto700.copyWith(fontSize: 12, color: defaultDark),
                    textAlign: TextAlign.left,
                  ),
                ),
                AnimatedSize(
                  vsync: this,
                  duration: const Duration(milliseconds: 250),
                  child: SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: widget.isExpanded
                          ? BoxConstraints(
                              maxHeight: device.height,
                              minWidth: device.width * 0.9)
                          : BoxConstraints(
                              maxHeight: device.height / 4,
                              minWidth: device.width * 0.9),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(8.0, 8.0, 8.0, 30.0),
                        child: Text(
                          !widget.isExpanded && widget.text.length > 80
                              ? widget.text.substring(0, 80) + "..."
                              : widget.text,
                          style: roboto700.copyWith(
                              fontSize: 14, color: defaultDark),
                          softWrap: true,
                          // overflow: TextOverflow.fade,
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
        ),
        widget.text.length > 80
            ? Positioned(
                bottom: 0,
                right: 0.0,
                left: 0.0,
                child: Semantics(
                  label: !widget.isExpanded?"View more":"View less",
                  button: true,
                  child: GestureDetector(
                      onTap: () =>
                          setState(() => widget.isExpanded = !widget.isExpanded),
                      child: !widget.isExpanded
                          ? SvgPicture.asset("images/details.svg",
                              width: 20,
                              height: 20,
                              color: _getStatusButtonColor(widget.status))
                          : SvgPicture.asset("images/detailsUP.svg",
                              width: 20,
                              height: 20,
                              color: _getStatusButtonColor(widget.status))),
                ),
              )
            : Container(),
      ],
    );
  }
}

Color? _getStatusButtonColor(String status) {
  if (status == TodoStatus.Open.name) return openButtonColor;
  if (status == TodoStatus.Completed.name) return completedButtonColor;
  if (status == TodoStatus.Closed.name) return closedButtonColor;
}
