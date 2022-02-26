import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/upload_file.dart';

class ProjectModalSheet extends StatefulWidget {
  @override
  _ProjectModalSheetState createState() => _ProjectModalSheetState();
}

class _ProjectModalSheetState extends State<ProjectModalSheet> {
  bool expandOptions = false;

  uploadFileButton() {
    return Positioned(
        bottom: 15,
        right: 0,
        child: GestureDetector(
          onTap: () {
            showModalBottomSheet(
              context: context,
              isScrollControlled: true,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    topRight: Radius.circular(20)),
              ),
              isDismissible: true,
              builder: (BuildContext bc) {
                return UploadFile();
              },
            );
          },
          child: Container(
            height: 30,
            width: 30,
            decoration: BoxDecoration(
                color: defaultDark, borderRadius: BorderRadius.circular(500)),
            child: Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ));
  }

  expandedOptions() {
    return Positioned(
      right: 0,
      top: 25,
      child: Container(
        height: 200,
        width: 45,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  spreadRadius: 1,
                  offset: Offset(0, 4),
                  color: Colors.black.withOpacity(0.25))
            ]),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  expandOptions = !expandOptions;
                  print(expandOptions);
                });
              },
              child: Icon(
                Icons.keyboard_arrow_up,
                color: defaultDark,
                size: 30,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.share,
                color: defaultDark,
                size: 20,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.edit,
                color: defaultDark,
                size: 20,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.delete,
                color: defaultDark,
                size: 20,
              ),
            ),
            GestureDetector(
              onTap: () {},
              child: Icon(
                Icons.person,
                color: defaultDark,
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      var effectiveHeight = 380;
      return SafeArea(
        child: Container(
          height: effectiveHeight.toDouble(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white),
          child: Padding(
            padding: EdgeInsets.only(top: 10, left: 30, right: 30),
            child: Stack(
              children: [
                ListView(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 145),
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(500),
                          color: defaultDark,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Project Title",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.black),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 10, vertical: 8),
                      child: Column(
                        children: [
                          Text(
                            "lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque facilisis elit venenatis facilisis efficitur. Donec fermentum velit ac ultricies maximus. Aliquam luctus ultricies tellus, vel facilisis nisi convallis eget.",
                            style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.black),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Container(
                              height: 160,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 140, vertical: 5),
                            child: Container(
                              height: 4,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(500),
                                color: greyBorder,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                expandOptions
                    ? expandedOptions()
                    : Positioned(
                        right: 10,
                        top: 25,
                        child: GestureDetector(
                            onTap: () {
                              print(expandOptions);
                              expandOptions = true;
                              setState(() {});
                            },
                            child: Icon(
                              Icons.keyboard_arrow_down,
                              color: defaultDark,
                              size: 30,
                            )),
                      ),
                uploadFileButton()
              ],
            ),
          ),
        ),
      );
    });
  }
}
