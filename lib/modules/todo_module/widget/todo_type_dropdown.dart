import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class TodoTypeDropDownMenu extends StatelessWidget {
  final Function(String?) onChanged;
  final bool errorDropdown;
  final String selectedValue;
  final List<String> items;
  final bool enabled;
  const TodoTypeDropDownMenu({required this.errorDropdown,required this.onChanged,required this.selectedValue,required this.items, required this.enabled});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      width: MediaQuery.of(context).size.width * .4,
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: errorDropdown ? todoListActiveTab : Colors.transparent,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ]),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(10, 0, 0, 2),
          child: DropdownButtonFormField<String>(
            value: selectedValue,
            dropdownColor: Colors.white,
            decoration: InputDecoration.collapsed(hintText: ''),
            onChanged: enabled?(String? newValue) {
              onChanged(newValue);
              // setState(() {
              //   filterDropDownValue =
              //       newValue != null ? newValue : 'to-do type';
              //   if (!filterDropDownValue.startsWith('Event')) {
              //     errorEvent = false;
              //     errorVenue = false;
              //   }
              // });
            }: null,
            icon: Icon(
              Icons.arrow_drop_down,
              color: errorDropdown ? todoListActiveTab : defaultDark,
              size: 5,
            ),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  value,
                  style: montserratNormal.copyWith(
                    fontSize: 12,
                    color: errorDropdown ? todoListActiveTab : defaultDark,
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
