import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';

class DarkTextFieldForLinks extends StatefulWidget {
  final TextEditingController? inputController;
  final FocusNode? inputFocus;
  final String? hintText;
  final bool fieldEnabled;
  final String? initialValue;
  final bool? hasPadding;
  final TextInputType? inputType;
  bool? isTitle = false;
  Function? onFieldSubmitted;
  Function? customOnChanged;

  DarkTextFieldForLinks(
      {this.inputController,
      this.inputFocus,
      this.hintText,
      this.fieldEnabled = true,
      this.initialValue = '',
      this.inputType,
      this.hasPadding,
      this.onFieldSubmitted,
      this.isTitle,
      this.customOnChanged});

  @override
  _DarkTextFieldForLinksState createState() => _DarkTextFieldForLinksState();
}

class _DarkTextFieldForLinksState extends State<DarkTextFieldForLinks> {
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
                  inputFormatters: widget.isTitle!
                      ? null
                      : [FilteringTextInputFormatter.deny(RegExp(r'[ ]'))],
                  initialValue: widget.initialValue,
                  enabled: widget.fieldEnabled,
                  onChanged: (String account) {
                    // if (widget.customOnChanged != null) {
                    //   widget.customOnChanged!();
                    // }
                    widget.inputController?.text = account;
                  },
                  onFieldSubmitted: (done) {
                    if (widget.onFieldSubmitted != null)
                      widget.onFieldSubmitted!();
                    widget.inputController?.text = done;
                    SystemChannels.textInput.invokeMethod('TextInput.hide');
                  },
                  autofocus: false,
                  style: darkTextFieldStyle.copyWith(
                      fontWeight: FontWeight.w700, color: defaultLight),
                  maxLines: 1,
                  minLines: 1,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  textInputAction: TextInputAction.done,
                  focusNode: widget.inputFocus,
                  enableInteractiveSelection: true,
                  decoration: authInputFieldDecoration.copyWith(
                    isDense: true,
                    contentPadding: EdgeInsets.only(
                      left: 18,
                      top: widget.hasPadding ?? false ? 15 : 0,
                      bottom: widget.hasPadding ?? false ? 15 : 0,
                    ),
                    hintText: "${widget.hintText}",
                    hintStyle: darkTextFieldStyle.copyWith(
                        fontWeight: FontWeight.w700, color: defaultLight),
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
