import 'package:flutter/material.dart';

class SharingContentModel {
  final String title;
  final String description;
  final String leadingSvg;
  final Color trailingIconColor;
  final void Function() onTap;

  SharingContentModel(
      {required this.title,
      required this.description,
      required this.onTap,
      required this.leadingSvg,
      required this.trailingIconColor});
}
