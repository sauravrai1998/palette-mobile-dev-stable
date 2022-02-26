import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/light_text_field.dart';

class UploadFile extends StatefulWidget {
  @override
  _UploadFileState createState() => _UploadFileState();
}

class _UploadFileState extends State<UploadFile> {
  bool expandOptions = false;

  TextEditingController titleController = new TextEditingController();
  FocusNode nodeForTitle = FocusNode();

  TextEditingController desController = new TextEditingController();
  FocusNode nodeForDes = FocusNode();

  TextEditingController linkController = new TextEditingController();
  FocusNode nodeForLink = FocusNode();

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, setState) {
      var effectiveHeight = MediaQuery.of(context).size.height * 0.69;
      return SafeArea(
        child: Container(
          height: effectiveHeight.toDouble(),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20)),
              color: Colors.white),
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.only(top: 10, left: 30, right: 30),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: LightTextField(
                        hasPadding: true,
                        inputController: titleController,
                        inputFocus: nodeForTitle,
                        hintText: "Enter project title",
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: Container(
                        height: 150,
                        child: LightTextField(
                          hasPadding: true,
                          inputController: titleController,
                          inputFocus: nodeForTitle,
                          hintText: "Enter project description",
                          maxLines: 5,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 13),
                      child: LightTextField(
                        hasPadding: true,
                        inputController: titleController,
                        inputFocus: nodeForTitle,
                        hintText: "Add link to the project",
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 23),
                        child: Row(
                          children: [
                            Icon(
                              Icons.attach_file,
                              color: defaultDark,
                              size: 26,
                            ),
                            SizedBox(
                              width: 9,
                            ),
                            Text(
                              "Upload image or video file",
                              style: lightTextFieldStyle,
                            )
                          ],
                        )),
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.only(top: 13),
                  child: Row(
                    children: [
                      Expanded(
                          child: Center(
                        child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 9),
                              child: Text(
                                'CANCEL',
                                style: lightTextFieldStyle,
                              ),
                            )),
                      )),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                  color: defaultDark,
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20))),
                              child: Center(
                                  child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 9),
                                child: Text(
                                  'SUBMIT',
                                  style: lightTextFieldStyle.copyWith(
                                      color: Colors.white),
                                ),
                              ))))
                    ],
                  )),
            ],
          ),
        ),
      );
    });
  }
}
