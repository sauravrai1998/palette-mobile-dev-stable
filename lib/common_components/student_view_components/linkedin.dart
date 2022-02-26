import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/utils/konstants.dart';

class LinkedIN extends StatefulWidget {
  final String link;
  LinkedIN({required this.link});
  @override
  _LinkedINState createState() => _LinkedINState();
}

class _LinkedINState extends State<LinkedIN>
    with SingleTickerProviderStateMixin {
  var showOptions = false;

  linkedInHead({width}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Icon(Icons.home, color: defaultDark),
          SizedBox(
            width: 10,
          ),
          Text(
            "LinedIn",
            style: roboto700.copyWith(color: defaultDark, fontSize: 14),
            textAlign: TextAlign.center,
          ),
          SizedBox(
            width: 0.5 * width / 7,
          )
        ],
      ),
    );
  }

  linkedInUrl({width, height}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "LinkedIn",
            style: roboto700.copyWith(color: defaultDark, fontSize: 10),
            textAlign: TextAlign.center,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: FittedBox(
              child: Text(
                widget.link,
                style: roboto700.copyWith(
                    fontWeight: FontWeight.w500,
                    color: defaultDark.withOpacity(0.6),
                    fontSize: 14),
                maxLines: 2,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var _width = MediaQuery.of(context).size.width;

    return Container(
      width: _width / 7,
      child: PopupMenuButton(
        shape: bottomRightCurvedShape,
        color: defaultLight,
        offset: Offset(-200, 0),
        icon: Icon(
          Icons.camera_alt_outlined,
          color: defaultLight,
        ),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: StatefulBuilder(
              builder: (context, setState) {
                return Container(
                  width: 4 * _width / 7,
                  height: 80,
                  child: Row(
                    children: [
                      Container(
                        width: 3.7 * _width / 7,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            linkedInHead(width: _width),
                            linkedInUrl(width: _width, height: _height)
                          ],
                        ),
                      ),
                      Container(
                        width: 0.3 * _width / 7,
                        child: showOptions
                            ? Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          print('called');
                                          showOptions = !showOptions;
                                          print(showOptions);
                                        });
                                      },
                                      child: Icon(
                                        Icons.keyboard_arrow_up,
                                        size: 20,
                                        color: defaultDark,
                                      )),
                                  SizedBox(
                                    height: 8,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      //    StudentBloc(studentRepo: StudentRepository.instance)..add(SendLinkDataEvent(value: "", title: "LinkedIn"));
                                    },
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: defaultDark,
                                            borderRadius:
                                                BorderRadius.circular(500)),
                                        child: Padding(
                                          padding: const EdgeInsets.all(2.0),
                                          child: Center(
                                              child: Icon(
                                            Icons.delete,
                                            size: 13,
                                            color: defaultLight,
                                          )),
                                        )),
                                  ),
                                  // SizedBox(height: 8,),
                                  // Container(decoration: BoxDecoration(
                                  //     color: defaultDark,
                                  //     borderRadius: BorderRadius.circular(500)
                                  // ),child: Padding(
                                  //   padding: const EdgeInsets.all(2.0),
                                  //   child: Icon(Icons.double_arrow,size: 13,color: defaultLight,),
                                  // ))
                                ],
                              )
                            : Container(
                                alignment: Alignment.topCenter,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                        onTap: () {
                                          setState(() {
                                            print('called');
                                            showOptions = !showOptions;
                                            print(showOptions);
                                          });
                                        },
                                        child: Icon(
                                          Icons.keyboard_arrow_down,
                                          size: 20,
                                          color: defaultDark,
                                        )),
                                    SizedBox(
                                      height: 40,
                                    )
                                  ],
                                ),
                              ),
                      )
                    ],
                  ),
                );
              },
            ),
            value: 0,
          ),
        ],
      ),
    );
  }
}
