import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class ClassesCard extends StatefulWidget {
  final String subject;
  final String id;
  final String faculty;
  final double progress;

  ClassesCard(
      {required this.subject,
      required this.id,
      required this.faculty,
      required this.progress});

  @override
  _ClassesCardState createState() => _ClassesCardState();
}

class _ClassesCardState extends State<ClassesCard> {
  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;

    return Semantics(
      child: Material(
        elevation: 0,
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
        color: Colors.transparent,
        child: Container(
          height: devHeight * 0.1,
          width: devWidth * 0.4,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            gradient: LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                stops: [widget.progress, 1.0],
                colors: [defaultDark, defaultDark.withOpacity(0.5)]),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: devWidth * 0.02, vertical: devWidth * 0.02),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(widget.subject,
                    style: kalam700.copyWith(
                      color: defaultLight,
                      fontSize: 20,
                    )),
                SizedBox(height: devWidth * 0.02),
                Padding(
                  padding: EdgeInsets.only(left: devWidth * 0.03),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text('${widget.id}',
                          style: kalam700.copyWith(
                            color: defaultLight,
                            fontSize: 16,
                          )),
                      Icon(Icons.circle,
                          size: 8, color: defaultLight.withOpacity(0.7)),
                      Text('${widget.faculty}',
                          style: kalam700.copyWith(
                            color: defaultLight,
                            fontSize: 16,
                          )),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomRight,
                  child: ImageIcon(
                      AssetImage('images/next_arrow_consult_page.png'),
                      color: white,
                      size: 16),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
