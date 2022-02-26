import 'dart:math';

import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class CustomPaletteLoader extends StatefulWidget {
  const CustomPaletteLoader({Key? key}) : super(key: key);

  @override
  _CustomPaletteLoaderState createState() => _CustomPaletteLoaderState();
}

class _CustomPaletteLoaderState extends State<CustomPaletteLoader>
    with SingleTickerProviderStateMixin {
  bool _loadingInProgress = false;

  Animation<double>? _angleAnimation;
  AnimationController? _controller;

  @override
  void initState() {
    super.initState();
    _loadingInProgress = true;
    _controller = AnimationController(
        duration: const Duration(milliseconds: 1800), vsync: this);
    _angleAnimation = Tween(begin: 0.0, end: 360.0).animate(_controller!)
      ..addListener(() {
        setState(() {
          // the state that has changed here is the animation object’s value
        });
      });

    _angleAnimation!.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        if (_loadingInProgress) {
          _controller!.repeat();
        }
      } else if (status == AnimationStatus.dismissed) {
        if (_loadingInProgress) {
          _controller!.repeat();
        }
      }
    });

    _controller!.forward();
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: _buildBody(),
    );
  }

  Widget _buildBody() {
    return new Center(child: _buildAnimation());
  }

  Widget _buildAnimation() {
    double circleWidth = 8;
    Widget circles = new Container(
      width: circleWidth * 2.5,
      height: circleWidth * 2.5,
      child: new Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              _buildCircle(circleWidth, Color(0xFF6C67F2)),
              SizedBox(height: 4, width: 4),
              _buildCircle(circleWidth, Color(0xFF44A13B)),
            ],
          ),
          SizedBox(height: 4, width: 4),
          Row(
            children: <Widget>[
              _buildCircle(circleWidth, Color(0xFFFBAE45)),
              SizedBox(height: 4, width: 4),
              _buildCircle(circleWidth, red),
            ],
          ),
        ],
      ),
    );

    double angleInDegrees = _angleAnimation!.value;
    return new Transform.rotate(
      angle: angleInDegrees / 360 * 2 * pi,
      child: new Container(
        child: circles,
      ),
    );
  }

  Widget _buildCircle(double circleWidth, Color color) {
    return new Container(
      width: circleWidth,
      height: circleWidth,
      decoration: new BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}
