import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

// ignore: must_be_immutable
class GetDropDropMenu extends StatefulWidget {
  List<String>? data;
  Function? onPressed;
  GetDropDropMenu({this.data, this.onPressed});

  @override
  _GetDropDropMenuState createState() => _GetDropDropMenuState();
}

class _GetDropDropMenuState extends State<GetDropDropMenu> {
  String? valueSelected;

  @override
  Widget build(BuildContext context) {
    return DropdownButton<String>(
      underline: Container(),
      dropdownColor: defaultLight,
      elevation: 0,
      hint: Semantics(
        child: Text(
          "Select link type",
          style: robotoTextStyle.copyWith(color: defaultLight, fontSize: 14),
        ),
      ),
      items: widget.data!.map((String value) {
        return DropdownMenuItem<String>(
            value: value,
            child: Semantics(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    value,
                    style: robotoTextStyle.copyWith(color: Colors.white),
                  ),
                ],
              ),
            ));
      }).toList(),
      onChanged: (newVal) async {
        widget.onPressed!(newVal);
        valueSelected = newVal;
        print(valueSelected);
        this.setState(() {});
      },
      value: valueSelected == null ? null : valueSelected.toString(),
    );
  }
}
