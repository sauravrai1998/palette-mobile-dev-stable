import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';

class CommonTextArea extends StatelessWidget {
  final String hintText;
  final TextEditingController controller;
  final Function? onTextChanged;
  final  String? initialText;
  final bool errorFlag;

  const CommonTextArea({
    Key? key,
    required this.hintText,
    required this.controller,
    this.onTextChanged,
    this.initialText,
    this.errorFlag = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
                        color: errorFlag
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
          ]),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: TextFormField(
          autofocus: false,
          style: montserratNormal.copyWith(
            color: Colors.grey,
            fontSize: 14
          ),
          keyboardType: TextInputType.multiline,
          textInputAction: TextInputAction.newline,
          minLines: 1,
          maxLines: 6,
          decoration: authInputFieldDecoration.copyWith(
            hintStyle: montserratSemiBoldTextStyle.copyWith(
              color: errorFlag? todoListActiveTab : defaultDark.withOpacity(0.6),
            ),
            hintText: hintText,
            helperStyle: montserratSemiBoldTextStyle.copyWith()
          ),
          controller: controller,
          onChanged: (change) {
            if (onTextChanged != null) {
            onTextChanged!(change);
            }
          },
        ),
      ),
    );
  }
}
