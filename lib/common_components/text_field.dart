import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class CommonTextField extends StatefulWidget {
  final TextEditingController? inputController;
  final FocusNode? inputFocus;
  final String? hintText;
  final bool fieldEnabled;
  final String? initialValue;
  final TextInputType? inputType;
  final double height;
  final bool password;
  final bool isCreateForm;
  final bool isForLink;

  CommonTextField({
    this.inputController,
    this.inputFocus,
    this.hintText,
    this.fieldEnabled = true,
    this.initialValue = '',
    this.inputType,
    this.height = 50,
    this.isCreateForm = false,
    this.password = false,
    this.isForLink = false,
  });

  @override
  _CommonTextFieldState createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Please enter the ${widget.hintText}',
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          //   width: double.infinity,
          height: widget.height,
          decoration: widget.fieldEnabled
              ? widget.isForLink
                  ? BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.08),
                            blurRadius: 5,
                            offset: Offset(0, 2),
                            spreadRadius: 0,
                          ),
                        ])
                  : BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
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
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextFormField(
                enabled: widget.fieldEnabled,
                controller: widget.inputController,
                autofocus: false,
                obscuringCharacter: '*',
                obscureText: widget.password,
                style: widget.isCreateForm || widget.isForLink
                    ? montserratSemiBoldTextStyle.copyWith(color: defaultDark)
                    : robotoTextStyle.copyWith(
                        fontWeight: FontWeight.bold,
                        color: defaultDark.withOpacity(0.6),
                      ),
                maxLines: 1,
                minLines: 1,
                keyboardType: widget.inputType ?? TextInputType.text,
                textInputAction: TextInputAction.done,
                focusNode: widget.inputFocus,
                decoration: authInputFieldDecoration.copyWith(
                  hintStyle: montserratSemiBoldTextStyle.copyWith(
                    color: widget.isCreateForm || widget.isForLink
                        ? defaultDark
                        : defaultDark.withOpacity(0.6),
                  ),
                  hintText: widget.hintText,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
