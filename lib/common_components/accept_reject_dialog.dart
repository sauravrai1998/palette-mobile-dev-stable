import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/main.dart';

import 'package:flutter_svg/flutter_svg.dart';

class RejectAcceptDialog extends StatefulWidget {
  final String? title;
  final String body;
  final Function() okAction;
  final Function() cancel;

  RejectAcceptDialog({
    required this.title,
    required this.body,
    required this.okAction,
    required this.cancel,
  });

  @override
  _RejectAcceptDialogState createState() => _RejectAcceptDialogState();
}

class _RejectAcceptDialogState extends State<RejectAcceptDialog> {
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    Widget _getLoadingIndicator() {
      return Center(
        child: Container(
            height: 20,
            width: 30,
            child: CustomChasingDotsLoader(
              color: Colors.white,
            )),
      );
    }

    return TextScaleFactorClamper(
      child: MergeSemantics(
        child: Semantics(
          child: Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0)),
            backgroundColor: white,
            child: IntrinsicHeight(
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(30.0)),
                ),
                child: Stack(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        SvgPicture.asset(
                          'images/dialog_image.svg',
                          fit: BoxFit.contain,
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: <Widget>[
                          Container(
                            child: Padding(
                              padding: EdgeInsets.only(
                                top: devHeight * 0.01,
                                left: devWidth * 0.06,
                                right: devWidth * 0.25,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  if (widget.title != null)
                                    BlockSemantics(
                                      child: Text(
                                        widget.title!,
                                        style: robotoTextStyle.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                    ),
                                  if (widget.title != null)
                                    SizedBox(
                                      height: devHeight * 0.03,
                                    ),
                                  Text(
                                    widget.body,
                                    style: robotoTextStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: acceptText),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 25, left: 25),
                                child: GestureDetector(
                                  onTap: () {
                                    widget.cancel();
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 30,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8)),
                                        border: Border.all(
                                            color: defaultDark, width: 2)),
                                    child: Center(
                                      child: Text(
                                        "CANCEL",
                                        style: robotoTextStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: defaultDark),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                  right: 16,
                                ),
                                child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      loading = true;
                                    });
                                    widget.okAction();
                                  },
                                  child: Container(
                                    width: 70,
                                    height: 30,
                                    decoration: BoxDecoration(
                                      color: defaultDark,
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(8)),
                                    ),
                                    child: Center(
                                      child: loading
                                          ? _getLoadingIndicator()
                                          : Text(
                                              "YES",
                                              style: robotoTextStyle.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Colors.white),
                                            ),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
