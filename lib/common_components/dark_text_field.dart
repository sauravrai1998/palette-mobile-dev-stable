import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';

class DarkTextField extends StatefulWidget {
  final TextEditingController? inputController;
  final FocusNode? inputFocus;
  final String? hintText;
  final bool fieldEnabled;
  final String? initialValue;
  final bool? hasPadding;
  final TextInputType? inputType;
  final EdgeInsetsGeometry? contentPadding;
  final bool skillinterest;
  bool? isTitle = false;

  DarkTextField({
    this.inputController,
    this.inputFocus,
    this.hintText,
    this.fieldEnabled = true,
    this.initialValue = '',
    this.inputType,
    this.hasPadding,
    this.contentPadding,
    required this.skillinterest,
    this.isTitle,
  });

  @override
  _DarkTextFieldState createState() => _DarkTextFieldState();
}

class _DarkTextFieldState extends State<DarkTextField> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      label: 'Please enter the ${widget.hintText}',
      child: Material(
        borderRadius: BorderRadius.circular(10),
        child: Container(
          decoration: BoxDecoration(
            color: darkBackgroundColor,
            borderRadius: new BorderRadius.all(new Radius.circular(6.0)),
          ),
          child: Center(
            child: Padding(
              padding: widget.hasPadding ?? false
                  ? const EdgeInsets.fromLTRB(10, 0, 10, 0)
                  : const EdgeInsets.fromLTRB(0, 0, 0, 0),
              child: TextFormField(
                  inputFormatters: widget.skillinterest == false?widget.isTitle== true?null:[FilteringTextInputFormatter.deny(RegExp(r'[ ]'))]:null,
                  enabled: widget.fieldEnabled,
                  controller: widget.inputController,
                  autofocus: false,
                  style: darkTextFieldStyle,
                  maxLines: 1,
                  minLines: 1,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  textInputAction: TextInputAction.done,
                  focusNode: widget.inputFocus,
                  decoration: authInputFieldDecoration.copyWith(
                    isDense: true,
                    contentPadding: widget.contentPadding ??
                        EdgeInsets.only(
                          left: 18,
                          top: widget.hasPadding ?? false ? 15 : 0,
                          bottom: widget.hasPadding ?? false ? 15 : 0,
                        ),
                    hintText: "${widget.hintText}",
                    hintStyle: TextStyle(color: Colors.white),
                    border: OutlineInputBorder(
                      borderRadius: const BorderRadius.all(
                        const Radius.circular(10.0),
                      ),
                    ),
                  )),
            ),
          ),
        ),
      ),
    );
  }
}
