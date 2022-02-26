import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/utils/konstants.dart';

class EventVenueTextBox extends StatelessWidget {
  const EventVenueTextBox({
    required this.controller,
    this.errorFlag = false,
    this.initialValue = '',
    this.onChanged,
    required this.isCreateForm,
  });
  final Function(String)? onChanged;
  final String initialValue;
  final TextEditingController controller;
  final bool errorFlag;
  final bool isCreateForm;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.fromLTRB(8, 0, 8, 0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: errorFlag ? todoListActiveTab : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ]),
      child: Row(
        children: [
          Icon(
            errorFlag ? Icons.location_on_outlined : Icons.location_pin,
            color: errorFlag ? todoListActiveTab : defaultDark,
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            width: MediaQuery.of(context).size.width * 0.6,
            child: TextFormField(
              enabled: true,
              autofocus: false,
              obscuringCharacter: '*',
              initialValue: initialValue,
              style: montserratNormal.copyWith(fontSize: 14),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.done,
              decoration: errorFlag
                  ? authInputFieldDecoration.copyWith(
                      hintStyle: montserratNormal.copyWith(
                          fontSize: 14, color: todoListActiveTab),
                      hintText: "Please enter Venue",
                    )
                  : authInputFieldDecoration.copyWith(
                      hintStyle: montserratNormal.copyWith(fontSize: 14),
                      hintText: "Enter Venue",
                    ),
              onChanged: onChanged,
              onTap: () {
                if (isCreateForm) {
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
        ],
      ),
    );
  }
}
