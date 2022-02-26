import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_components/text_area.dart';
import 'package:palette/modules/app_info/bloc/report_bug_bloc.dart';
import 'package:palette/modules/app_info/models/app_info_model.dart';
import 'package:palette/modules/todo_module/widget/textFormfieldForAppInfo.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/validation_regex.dart';
import 'package:shared_preferences/shared_preferences.dart';

class BugReportPage extends StatefulWidget {
  final String name;
  BugReportPage({Key? key, required this.name}) : super(key: key);

  @override
  _BugReportPageState createState() => _BugReportPageState();
}

class _BugReportPageState extends State<BugReportPage> {
  TextEditingController textAreaController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  String emailText = "";
  String messageText = "";
  List<String> fileURIs = [];
  List<String> filepaths = [];
  List<String> fileNames = [];
  List<String> fileTypes = [];
  List<File> files = [];
  String? sfid;
  bool isUploading = false;
  bool errorEmail = false;
  bool errorMessage = false;

  @override
  void initState() {
    super.initState();
    getSfid();
  }

  getSfid() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReportBugBloc, ReportBugState>(
      listener: (context, state) {
        if (state is ReportBugSuccess) {
          Helper.showSuccessSnackBar(
            'Your Bug Report was delivered successfully',
            context,
          );
          setState(() {
            fileNames = [];
            filepaths = [];
            fileURIs = [];
            fileTypes = [];
            files = [];
            isUploading = false;
            emailController.clear();
            textAreaController.clear();
            emailText = "";
            messageText = "";
          });
        }
        if (state is ReportBugFailed) {
          Navigator.pop(context);
          Helper.showCustomSnackBar(
                'We could not send your message at this time. Please try again later',
                context);
        }
      },
      bloc: context.read<ReportBugBloc>(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: LayoutBuilder(builder: (context, constraints) {
            return SingleChildScrollView(
                child: Container(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: IconButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: RotatedBox(
                                quarterTurns: 1,
                                child: SvgPicture.asset(
                                  'images/dropdown.svg',
                                  color: defaultDark,
                                )),
                          ),
                        ),
                        Center(
                            child: Image.asset('images/palettelogonobg.png',
                                width: 200)),
                        SizedBox(height: 20),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 25),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Report a Bug',
                                  style: TextStyle(
                                      fontSize: 24,
                                      fontWeight: FontWeight.w700)),
                              SizedBox(height: 20),
                              CommonTextFieldAppInfo(
                                hintText: 'Your email...',
                                initialValue: emailText,
                                inputController: emailController,
                                errorFlag: errorEmail,
                                onChanged: (value) {
                                  setState(() {
                                    emailText = value;
                                    errorEmail = false;
                                  });
                                },
                              ),
                              SizedBox(height: 20),
                              CommonTextArea(
                                hintText: 'Your message...',
                                controller: textAreaController,
                                errorFlag: errorMessage,
                                onTextChanged: (value) {
                                  setState(() {
                                    messageText = value;
                                    errorMessage = false;
                                  });
                                },
                                initialText: messageText,
                              ),
                              SizedBox(height: 20),
                              Text(
                                  'Add Screenshots/Screen Recordings (optional)',
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w500)),
                              SizedBox(height: 20),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  filepaths.isNotEmpty
                                      ? filePreview(filepaths[0], 0)
                                      : addFileCard(0),
                                  filepaths.length >= 2
                                      ? filePreview(filepaths[1], 1)
                                      : addFileCard(1),
                                  filepaths.length == 3
                                      ? filePreview(filepaths[2], 2)
                                      : addFileCard(2),
                                ],
                              ),
                              SizedBox(height: 20),
                            ],
                          ),
                        ),
                      ],
                    ),
                    sendReportButton(context),
                    SizedBox(height: 10),
                  ]),
            ));
          }),
        ),
      ),
    );
  }

  Widget sendReportButton(BuildContext context) {
    return BlocBuilder<ReportBugBloc, ReportBugState>(
        builder: (context, state) {
      return Center(
          child: Container(
        height: 50,
        width: MediaQuery.of(context).size.width * 0.76,
        child: isUploading
            ? CustomPaletteLoader()
            : state is ReportBugLoading
                ? CustomPaletteLoader()
                : ElevatedButton.icon(
                    onPressed: () async {
                      if (emailText.isEmpty) {
                        setState(() {
                          errorEmail = true;
                        });
                        return;
                      } else if (messageText.isEmpty || messageText.trim().isEmpty) {
                        setState(() {
                          errorMessage = true;
                        });
                        return;
                      } else if (emailText.contains(Validator.emailValid) ==
                          false) {
                            setState(() {
                              errorEmail = true;
                            });
                        Helper.showCustomSnackBar(
                            'Please enter a valid email', context);
                        return;
                      }
                      _setUploading(true);
                      for (var i = 0; i < files.length; i++) {
                        try {
                          final reference = FirebaseStorage.instance.ref(
                              'bug-report/$sfid${widget.name}/${fileNames[i]}');
                          await reference.putFile(files[i]);
                          final uri = await reference.getDownloadURL();
                          setState(() {
                            fileURIs.add(uri.toString());
                          });
                        } on FirebaseException catch (e) {
                          print(e.message);
                        }
                      }
                      var model = ReportBugModel(
                          name: widget.name,
                          email: emailController.text,
                          message: textAreaController.text,
                          screenshots: fileURIs);
                      BlocProvider.of<ReportBugBloc>(context)
                          .add(ReportBugClicked(model));
                      _setUploading(false);
                    },
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.white),
                        elevation: MaterialStateProperty.all(0.5)),
                    icon: SvgPicture.asset('images/bug.svg'),
                    label: Text(
                      'SEND REPORT',
                      style: TextStyle(color: purpleBlue),
                    ),
                  ),
      ));
    });
  }

  _setUploading(bool _isUploading) {
    setState(() {
      isUploading = _isUploading;
    });
  }

  _showFilePicker() async {
    // final bloc = context.read<CreateTodoLocalSaveBloc>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.media,
    );

    if (result != null) {
      final pfile = result.files.first;
      final fileName = pfile.name;
      final filePath = pfile.path;
      final fileType = pfile.extension;
      final file = File(filePath ?? '');
      setState(() {
        filepaths.add(filePath ?? '');
        fileNames.add(fileName);
        fileTypes.add(fileType ?? '');
        files.add(file);
      });
      print(filepaths.length);
    } else {}
  }

  Widget addFileCard(int index) {
    return Container(
        height: 110,
        width: 100,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 3,
                offset: Offset(0, 1),
              ),
            ]),
        child: InkWell(
          onTap: () {
            _showFilePicker();
          },
          child: Center(
            child: Icon(
              Icons.add,
              color: pureblack.withOpacity(0.6),
              size: 40,
            ),
          ),
        ));
  }

  Widget filePreview(String filePath, int index) {
    return Container(
      height: 110,
      width: 100,
      child: Stack(
        children: [
          Container(
            height: 110,
            width: 100,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 3,
                    offset: Offset(0, 1),
                  ),
                ]),
            child: Center(
                child: fileTypes[index] == 'jpg' ||
                        fileTypes[index] == 'png' ||
                        fileTypes[index] == 'jpeg' ||
                        fileTypes[index] == 'gif'
                    ? Image.file(
                        File(filePath),
                        fit: BoxFit.cover,
                        height: double.infinity,
                        width: double.infinity,
                      )
                    : SvgPicture.asset('images/movie_black.svg')),
          ),
          Align(
            alignment: Alignment.topRight,
            child: isUploading
                ? Container()
                : GestureDetector(
                    onTap: () {
                      setState(() {
                        filepaths.remove(filePath);
                        files.removeAt(index);
                        fileNames.removeAt(index);
                        fileTypes.removeAt(index);
                      });
                    },
                    child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.2),
                                blurRadius: 4,
                                offset: Offset(0, 4),
                              ),
                            ]),
                        child: Icon(Icons.close, color: Colors.red[900])),
                  ),
          ),
        ],
      ),
    );
  }
}
