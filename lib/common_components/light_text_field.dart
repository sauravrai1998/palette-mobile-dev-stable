import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';

class LightTextField extends StatefulWidget {
  final TextEditingController? inputController;
  final FocusNode? inputFocus;
  final String? hintText;
  final bool fieldEnabled;
  final String? initialValue;
  final bool? hasPadding;
  final TextInputType? inputType;
  final int maxLines;
  LightTextField({
    this.inputController,
    this.inputFocus,
    this.hintText,
    this.fieldEnabled = true,
    this.initialValue = '',
    this.inputType,
    this.hasPadding,
    this.maxLines = 1,
  });

  @override
  _LightTextFieldState createState() => _LightTextFieldState();
}

class _LightTextFieldState extends State<LightTextField> {
  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          color: lightFieldBGColor,
          borderRadius: new BorderRadius.all(new Radius.circular(20.0)),
        ),
        child: Center(
          child: Padding(
            padding: widget.hasPadding ?? false
                ? const EdgeInsets.fromLTRB(10, 3, 10, 3)
                : const EdgeInsets.fromLTRB(0, 0, 0, 0),
            child: Column(
              children: [
                TextFormField(
                    initialValue: widget.initialValue,
                    enabled: widget.fieldEnabled,
                    onChanged: (String account) {
                      widget.inputController?.text = account;
                    },
                    onFieldSubmitted: (done) {
                      widget.inputController?.text = done;
                      widget.inputFocus?.unfocus();
                    },
                    autofocus: false,
                    style: lightTextFieldStyle,
                    maxLines: widget.maxLines,
                    minLines: 1,
                    keyboardType: widget.inputType ?? TextInputType.text,
                    textInputAction: TextInputAction.done,
                    focusNode: widget.inputFocus,
                    decoration: authInputFieldDecoration.copyWith(
                      isDense: true,
                      contentPadding: EdgeInsets.only(
                        left: 10,
                        top: widget.hasPadding ?? false ? 15 : 0,
                        bottom: widget.hasPadding ?? false ? 15 : 0,
                      ),
                      hintText: "${widget.hintText}",
                      hintStyle: TextStyle(color: defaultDark),
                      border: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          const Radius.circular(10.0),
                        ),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
