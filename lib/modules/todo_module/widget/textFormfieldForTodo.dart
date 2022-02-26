import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/utils/konstants.dart';

class CommonTextFieldTodo extends StatefulWidget {
  final TextEditingController? inputController;
  final FocusNode? inputFocus;
  final String? hintText;
  final bool fieldEnabled;
  final String? initialValue;
  final TextInputType? inputType;
  final double height;
  final bool password;
  final bool isCreateForm;
  final bool errorFlag;
  final bool isForAction;
  final Function(String newValue)? onChanged;

  CommonTextFieldTodo({
    this.inputController,
    this.inputFocus,
    this.hintText,
    this.fieldEnabled = true,
    this.initialValue = '',
    this.inputType,
    this.onChanged,
    this.height = 50,
    this.isCreateForm = false,
    this.password = false,
    this.errorFlag = false,
    this.isForAction = false,
  });

  @override
  _CommonTextFieldTodoState createState() => _CommonTextFieldTodoState();
}

class _CommonTextFieldTodoState extends State<CommonTextFieldTodo> {
  @override
  Widget build(BuildContext context) {
    String _enteredText = widget.initialValue ?? '';
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
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextFormField(
                  enabled: widget.fieldEnabled,
                  autofocus: false,
                  obscuringCharacter: '*',
                  obscureText: widget.password,
                  style: montserratNormal.copyWith(fontSize: 12),
                  maxLines: widget.isForAction ? 1 : 8,
                  minLines: 1,
                  keyboardType: widget.inputType ?? TextInputType.text,
                  textInputAction: TextInputAction.done,
                  focusNode: widget.inputFocus,
                  onChanged: (value) {
                    setState(() {
                      _enteredText = value;
                    });
                    if (widget.onChanged == null) return;
                    widget.onChanged!(value);
                  },
                  initialValue: widget.initialValue ?? '',
                  decoration: widget.errorFlag
                      ? authInputFieldDecoration.copyWith(
                          hintStyle: montserratNormal.copyWith(
                              fontSize: 12, color: todoListActiveTab),
                          hintText: widget.hintText,
                        )
                      : authInputFieldDecoration.copyWith(
                          hintStyle: montserratNormal.copyWith(fontSize: 12),
                          hintText: widget.hintText,
                          // counterText: widget.isForAction?_enteredText.length <= 50?'${_enteredText.length.toString()} / 250':'':'',
                        ),
                  onTap: () {
                    if (widget.isCreateForm) {
                      BlocProvider.of<HideNavbarBloc>(context)
                          .add(HideBottomNavbarEvent());
                    }
                  },
                  onFieldSubmitted: (value) {
                    // BlocProvider.of<HideNavbarBloc>(context)
                    //     .add(ShowBottomNavbarEvent());
                  },
                ),
              ),
            ),
            widget.isForAction
                ? Container(
                    child: _enteredText.length <= 80
                        ? Text(
                            '${_enteredText.length.toString()} / 80',
                            style: montserratNormal.copyWith(),
                          )
                        : Text(
                            '${_enteredText.length.toString()} / 80',
                            style: montserratNormal.copyWith(color: Colors.red),
                          ))
                : Container()
          ],
        ),
      ),
    );
  }
}
