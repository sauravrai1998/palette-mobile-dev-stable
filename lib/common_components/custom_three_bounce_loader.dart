import 'package:flutter/material.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/utils/konstants.dart';

class CustomThreeBounceLoader extends StatelessWidget {
  final Color color;
  CustomThreeBounceLoader({this.color = defaultDark});
  @override
  Widget build(BuildContext context) {
    return CustomPaletteLoader();
  }
}
