import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';

class ComponentsDummy extends StatefulWidget {
  @override
  _ComponentsDummyState createState() => _ComponentsDummyState();
}

class _ComponentsDummyState extends State<ComponentsDummy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Components test'),
      ),
      body: Container(
        child: Text(''),
      ),
    );
  }
}
