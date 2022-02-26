import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class InstituteItemButton extends StatelessWidget {
  final bool isSelected;
  // final Function onTap;
  const InstituteItemButton({
    required this.isSelected,
// required this.onTap
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // return onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 10),
        height: 118,
        width: 116,
        decoration: BoxDecoration(
          color: isSelected ? defaultDark : Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              height: 60,
              width: 60,
              child: Image.asset('images/south_cf.png'),
            ),
            SizedBox(height: 5),
            Text(
              'University of Southern California',
              style: roboto700.copyWith(
                color: Colors.black,
                fontSize: 10,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}