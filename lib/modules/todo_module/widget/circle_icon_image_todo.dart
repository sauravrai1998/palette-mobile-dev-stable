import 'package:flutter/material.dart';

class CircleIcon extends StatelessWidget {
  Widget child;
  CircleIcon({
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        height: 28,
        width: 28,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50),
        ),
        child: child);
  }
}
