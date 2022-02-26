import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/konstants.dart';

class CommonTextFieldOpportunity extends StatefulWidget {
  final TextEditingController inputController;
  final FocusNode? inputFocus;
  final String? hintText;
  final bool fieldEnabled;
  final TextInputType? inputType;
  final double height;
  final bool password;
  final bool isCreateForm;
  final bool errorFlag;
  final bool? validFlag;
  final String imagePath;
  final Function(String newValue)? onChanged;

  CommonTextFieldOpportunity({
    required this.inputController,
    this.inputFocus,
    this.hintText,
    this.fieldEnabled = true,
    this.inputType,
    this.onChanged,
    this.height = 41,
    this.isCreateForm = false,
    this.password = false,
    this.errorFlag = false,
    this.validFlag = false,
    required this.imagePath,
  });

  @override
  _CommonTextFieldOpportunityState createState() =>
      _CommonTextFieldOpportunityState();
}

class _CommonTextFieldOpportunityState
    extends State<CommonTextFieldOpportunity> {
  String enteredText = '';
  @override
  Widget build(BuildContext context) {
    bool isVaildFlag = widget.validFlag ?? false;
    String? _hintText = isVaildFlag ? '${widget.hintText} *' : widget.hintText;
    return Semantics(
      label: 'Please enter the ${widget.hintText}',
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
              decoration: widget.fieldEnabled
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(
                        color: widget.errorFlag
                            ? todoListActiveTab
                            : Colors.transparent,
                        width: 2.0,
                      ),
                      boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 5,
                            offset: Offset(0, 1),
                          ),
                        ])
                  : BoxDecoration(
                      color: offWhite,
                      borderRadius: BorderRadius.circular(10),
                    ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    SvgPicture.asset(
                      'images/${widget.imagePath}.svg',
                      height: 15,
                      width: 15,
                      color: enteredText.isNotEmpty || widget.errorFlag
                          ? widget.errorFlag
                              ? todoListActiveTab
                              : defaultDark
                          : defaultDark.withOpacity(0.5),
                    ),
                    SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        enteredText.isNotEmpty
                            ? Text('$_hintText',
                                style: roboto700.copyWith(
                                  fontSize: 10,
                                  color: widget.errorFlag
                                      ? todoListActiveTab
                                      : defaultDark.withOpacity(0.5),
                                ))
                            : Container(height: 10),
                        Container(
                          width: 260,
                          height: widget.height - 15,
                          margin: EdgeInsets.only(bottom: 2, top: 2),
                          child: Scrollbar(
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: ConstrainedBox(
                                constraints: BoxConstraints.expand(width: 850),
                                child: TextField(
                                    enabled: widget.fieldEnabled,
                                    autofocus: false,
                                    //uncomment this to enable limit of 100 characters
                                   // inputFormatters: [LengthLimitingTextInputFormatter(100)],
                                    style: montserratSemiBoldTextStyle.copyWith(
                                        fontSize: 14,
                                        color: widget.errorFlag
                                            ? todoListActiveTab
                                            : defaultDark),
                                    maxLines: 1,
                                    minLines: 1,
                                    keyboardType:
                                        widget.inputType ?? TextInputType.text,
                                    textInputAction: TextInputAction.done,
                                    focusNode: widget.inputFocus,
                                    onChanged: (value) {
                                      setState(() {
                                        enteredText = value;
                                      });
                                      if (widget.onChanged == null) return;
                                      widget.onChanged!(value);
                                    },
                                    controller: widget.inputController,
                                    decoration: widget.errorFlag
                                        ? authInputFieldDecoration.copyWith(
                                            hintStyle: montserratNormal.copyWith(
                                                fontSize: 14,
                                                color: todoListActiveTab),
                                            hintText: widget.hintText,
                                          )
                                        : authInputFieldDecoration.copyWith(
                                            hintStyle:
                                                montserratSemiBoldTextStyle.copyWith(
                                                    fontSize: 14,
                                                    color:
                                                        defaultDark.withOpacity(0.6)),
                                            hintText: widget.hintText,
                                          )),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
