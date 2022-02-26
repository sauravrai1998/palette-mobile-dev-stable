import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/utils/konstants.dart';

class AddressWidget extends StatelessWidget {
  final String address;

  AddressWidget({required this.address});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'images/home.svg',
            height: 20,
            width: 20,
            color: defaultLight,
          ),
          SizedBox(width: 8),
          Text(
            address,
            style: kalamTextStyleSmall.copyWith(
              fontSize: 18,
              color: defaultLight,
            ),
          ),
        ],
      ),
    );
  }
}
