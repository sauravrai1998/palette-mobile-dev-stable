import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/utils/konstants.dart';

class EventTypeDropDownMenu extends StatelessWidget {
  final Function(String?) onChanged;
  final bool errorDropdown;
  final String selectedValue;
  final List<String> items;
  const EventTypeDropDownMenu(
      {required this.errorDropdown,
      required this.onChanged,
      required this.selectedValue,
      required this.items});

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    bool isSelected = selectedValue == 'Event Type' ? true : false;
    return Container(
      height: 50,
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
          padding: EdgeInsets.symmetric(horizontal: deviceSize.width * 0.035),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SvgPicture.asset(
                'images/event_type.svg',
                color: errorDropdown ? todoListActiveTab : defaultDark,
                height: 20,
              ),
              SizedBox(width: 10),
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Visibility(
                    visible: !isSelected,
                    child: Text(
                      'Event Type',
                      style: roboto700.copyWith(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Container(
                    width: deviceSize.width * 0.7,
                    alignment: Alignment.topCenter,
                    child: DropdownButtonFormField<String>(
                      value: selectedValue,
                      dropdownColor: Colors.white,
                      decoration: InputDecoration.collapsed(hintText: ''),
                      onChanged: (String? newValue) {
                        onChanged(newValue);
                      },
                      icon: SvgPicture.asset(
                        'images/arrow_down.svg',height: 8,width: 8,
                        color: Colors.grey,
                      ),
                      items: items.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(
                            value,
                            style: roboto700.copyWith(
                              fontSize: 14,
                              color: errorDropdown ? todoListActiveTab : defaultDark,
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
