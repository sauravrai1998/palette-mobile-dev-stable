import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class SkillInterestChip extends StatelessWidget {
  final String? point;
  final Color? color;
  SkillInterestChip({this.point, this.color = profileCardBackgroundColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(right: 25, bottom: 13),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: color,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Text(
            "$point",
            style: kalamLight,
          ),
        ),
      ),
    );
  }
}
