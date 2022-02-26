import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CustomChasingDotsLoader extends StatelessWidget {
  final Color? color;
  final double size;
  CustomChasingDotsLoader({this.color, this.size = 20});
  @override
  Widget build(BuildContext context) {
    return Center(
      child: SpinKitChasingDots(
        color: color,
        size: size,
      ),
    );
  }
}
