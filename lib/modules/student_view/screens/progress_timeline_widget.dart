import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';
import 'package:timelines/timelines.dart';

class ProcessTimelinePage extends StatefulWidget {
  final List<String?> stepsList;
  final Color inProgressColor;
  final Color completedColor;
  ProcessTimelinePage(
      {required this.stepsList,
      required this.inProgressColor,
      required this.completedColor});

  @override
  _ProcessTimelinePageState createState() => _ProcessTimelinePageState();
}

class _ProcessTimelinePageState extends State<ProcessTimelinePage> {
  int _processIndex = 0;

  Color getColor(int index) {
    // _processIndex = 3;
    if (index == _processIndex) {
      return inProgressColorForTimeLineWidget;
    } else if (index < _processIndex) {
      return Color(0xFF0092AA).withOpacity(0.52);
    } else {
      return Color(0xFF0092AA).withOpacity(0.52);
    }
  }

  @override
  void initState() {
    if (mounted == true) {
      if (widget.stepsList.length == 1) {
        widget.stepsList.add('');
        widget.stepsList.add('');
        _processIndex = 1;
      } else if (widget.stepsList.length == 2) {
        widget.stepsList.add('');
        _processIndex = 2;
      } else if (widget.stepsList.length == 0) {
        widget.stepsList.add('');
        widget.stepsList.add('');
        widget.stepsList.add('');
        _processIndex = 0;
      } else {
        _processIndex = 3;
      }

      setState(() {});
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.white,
      // appBar: TitleAppBar('Process Timeline'),
      body: Container(
        child: Timeline.tileBuilder(
          theme: TimelineThemeData(
            direction: Axis.horizontal,
            connectorTheme: ConnectorThemeData(
              space: 30.0,
              thickness: 5.0,
            ),
          ),
          builder: TimelineTileBuilder.connected(
            connectionDirection: ConnectionDirection.before,
            itemExtentBuilder: (_, __) =>
                MediaQuery.of(context).size.width / widget.stepsList.length,
            oppositeContentsBuilder: (context, index) {
              return Container();
            },
            contentsBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Text(
                  widget.stepsList[index]!,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: getColor(index),
                  ),
                  maxLines: 2,
                ),
              );
            },
            indicatorBuilder: (_, index) {
              var color;
              var child;
              if (index == _processIndex) {
                color = Color(0xFF0092AA).withOpacity(0.52);
                child = Padding(
                  padding: const EdgeInsets.all(0.0),
                  child: Container(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        border: Border.all(
                          color: Color(0xFF0092AA).withOpacity(0.52),
                          width: 4,
                        )),
                  ),
                );
              } else if (index < _processIndex) {
                color = Color(0xFF0092AA);
                child = Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 20.0,
                );
              } else {
                color = Color(0xFF0092AA).withOpacity(0.52);
              }
//0092AA
              if (index <= _processIndex) {
                return Stack(
                  children: [
                    DotIndicator(
                      size: 30.0,
                      color: color,
                      child: child,
                    ),
                  ],
                );
              } else {
                return Stack(
                  children: [
                    OutlinedDotIndicator(
                      size: 30,
                      borderWidth: 4.0,
                      color: Color(0xFF0092AA).withOpacity(0.52),
                    ),
                  ],
                );
              }
            },
            connectorBuilder: (_, index, type) {
              //                  gradientColors = [Color.lerp(color = Color(0xFF0092AA);, color, 0.5)!, color];
              if (index > 0) {
                if (index == _processIndex) {
                  List<Color> gradientColors;
                  if (type == ConnectorType.start) {
                    gradientColors = [
                      widget.inProgressColor,
                      widget.inProgressColor
                    ];
                  } else {
                    gradientColors = [
                      widget.inProgressColor,
                      widget.inProgressColor
                    ];
                  }
                  return DecoratedLineConnector(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: gradientColors,
                      ),
                    ),
                  );
                } else {
                  return SolidLineConnector(
                    color: getColor(index),
                  );
                }
              } else {
                return null;
              }
            },
            itemCount: 3,
          ),
        ),
      ),
    );
  }
}
