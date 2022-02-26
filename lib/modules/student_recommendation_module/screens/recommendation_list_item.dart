import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';

class RecommendListItemWidget extends StatefulWidget {
  @override
  _RecommendListItemWidget createState() => _RecommendListItemWidget();
}

class _RecommendListItemWidget extends State<RecommendListItemWidget> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ,
        //   ),
        // );
      },
      child: Container(
        height: 10,
        color: Colors.blue,
        child: Row(
          children: [],
        ),
      ),
    );
  }
}
