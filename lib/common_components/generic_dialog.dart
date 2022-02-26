import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/main.dart';

import 'package:palette/utils/konstants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class GenericDialog extends StatelessWidget {
  final String? title;
  final String body;
  final Function() okAction;

  GenericDialog({
    required this.title,
    required this.body,
    required this.okAction,
  });

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;

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
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                  if (title != null)
                                    BlockSemantics(
                                      child: Text(
                                        title!,
                                        style: robotoTextStyle.copyWith(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 18),
                                      ),
                                    ),
                                  if (title != null)
                                    SizedBox(
                                      height: devHeight * 0.03,
                                    ),
                                  Text(
                                    body,
                                    style: robotoTextStyle.copyWith(
                                        fontWeight: FontWeight.w700,
                                        fontSize: 16,
                                        color: defaultDark.withOpacity(0.5)),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: <Widget>[
                              Padding(
                                padding:
                                    const EdgeInsets.only(right: 16, top: 8),
                                child: NextButton(
                                  clickFunction: () {
                                    okAction();
                                  },
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
