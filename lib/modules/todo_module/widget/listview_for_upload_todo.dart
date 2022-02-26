import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/text_field.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/todo_module/bloc/create_todo_local_save_bloc/create_todo_local_save_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/add_resource_button.dart';
import 'package:palette/modules/todo_module/widget/file_resource_card_button.dart';
import 'package:palette/modules/todo_module/widget/upload_resources_area.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:palette/utils/validation_regex.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ListViewUpload extends StatefulWidget {
  const ListViewUpload({
    Key? key,
    required this.actionController,
    required this.device,
    required this.fileResources,
    required this.linkResources,
    required this.fileTitleController,
    required this.fileurlController,
    required this.todolocalSaveState,
    required this.onTapDoneButton,
    required this.filesLoaderForBloc,
  }) : super(key: key);
  final TextEditingController actionController;
  final TextEditingController fileTitleController;
  final TextEditingController fileurlController;
  final Size device;
  final List<Resources> fileResources;
  final List<Resources> linkResources;
  final List<FileLoaderForBloc> filesLoaderForBloc;
  final CreateTodoLocalSaveState todolocalSaveState;
  final Function onTapDoneButton;

  @override
  _ListViewUploadState createState() => _ListViewUploadState();
}

class _ListViewUploadState extends State<ListViewUpload> {
  String? sfid;
  String? sfuuid;
  String? role;
  bool _isAttachmentUploading = false;

  @override
  void initState() {
    super.initState();
    _getSfidAndRole();
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
    sfuuid = prefs.getString(sfidConstant);
    role = prefs.getString('role').toString();
  }

  ScrollController scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return BlocListener(
      listener: (context, state) {},
      bloc: context.read<TodoCrudBloc>(),
      child: TextScaleFactorClamper(
        child: Semantics(
          label:
              "This is the page to attach resources to todo tap on upload resources to upload and than tap done",
          child: Column(
            children: [
              if (widget.fileResources.isEmpty)
                UploadResourcesArea(
                  onUploadTap: () {
                    _showBottomSheetForUpload();
                  },
                  isAttachmentUploading: _isAttachmentUploading,
                ),
              if (widget.fileResources.isNotEmpty)
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
                  width: widget.device.width * 0.8,
                  height: 122,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    controller: scrollController,
                    children: [
                      GestureDetector(
                        onTap: () {
                          ///ADD RESROUCE BUTTON TAP
                          _showBottomSheetForUpload();
                        },
                        child: Container(
                          width: 80,
                          height: 10,
                          child: AddResourceButton(),
                        ),
                      ),
                      SizedBox(width: 10),
                      ListView.builder(
                          controller: scrollController,
                          shrinkWrap: true,
                          scrollDirection: Axis.horizontal,
                          itemCount: widget.fileResources.length,
                          itemBuilder: (ctx, ind) {
                            return Container(
                              margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                              child: Stack(
                                children: [
                                  Container(
                                    height: 100,
                                    width: 80,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.circular(10),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            blurRadius: 5,
                                            offset: Offset(0, 1),
                                          ),
                                        ]),
                                    child: FileResourceCardButton(
                                      file: widget.fileResources[ind],
                                      gid: null,
                                      isForm: true,
                                      sfid: sfid,
                                      sfuuid: sfuuid,
                                      role: role,
                                      todotitle: widget.actionController.text,
                                    ),
                                  ),
                                  Positioned(
                                    right: 0,
                                    top: 0,
                                    child: InkWell(
                                      onTap: () {
                                        setState(() {
                                          widget.fileResources.removeAt(ind);
                                          widget.filesLoaderForBloc
                                              .removeAt(ind);
                                        });
                                        final bloc = context
                                            .read<CreateTodoLocalSaveBloc>();
                                        bloc.add(FilesLoaderForBlocChanged(
                                            filesLoaderForBloc:
                                                widget.filesLoaderForBloc));
                                        bloc.add(FileResourcesChanged(
                                            fileresources:
                                                widget.fileResources));
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(8),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black
                                                  .withOpacity(0.15),
                                              blurRadius: 4,
                                              offset: Offset(0, 4),
                                            ),
                                          ],
                                        ),
                                        child: Icon(
                                          Icons.close,
                                          size: 20,
                                          color: Colors.red[900],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ],
                  ),
                ),
              widget.todolocalSaveState.linkResources != null &&
                      widget.todolocalSaveState.linkResources?.length != 0
                  ? Center(
                      child: Container(
                        margin: const EdgeInsets.only(top: 20, bottom: 20),
                        height: 100,
                        width: widget.device.width * 0.8,
                        child: ListView.builder(
                            itemCount: widget
                                    .todolocalSaveState.linkResources?.length ??
                                0,
                            itemBuilder: (ctx, ind) {
                              return buildLinkViewer(
                                  widget.device, ind, context);
                            }),
                      ),
                    )
                  : SizedBox(
                      height: 20,
                    ),
              //
            ],
          ),
        ),
      ),
    );
  }

  Center buildLinkViewer(Size device, int ind, BuildContext context) {
    return Center(
      child: Container(
        width: device.width * 0.78,
        height: 40,
        padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
        margin: EdgeInsets.only(top: 2, bottom: 4),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ]),
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: device.width * 0.6,
                    child: Text(
                      "   ${widget.todolocalSaveState.linkResources![ind].name}",
                      overflow: TextOverflow.ellipsis,
                      style: roboto700.copyWith(fontSize: 16),
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.arrow_forward_ios,
                color: defaultDark,
                size: 12,
              ),
            ],
          ),
          onTap: () {
            widget.fileTitleController.text =
                widget.todolocalSaveState.linkResources![ind].name;
            widget.fileurlController.text =
                widget.todolocalSaveState.linkResources![ind].url;
            showLinkSheet(context, update: true, ind: ind);
            setState(() {});
          },
        ),
      ),
    );
  }

  void _showFilePicker() async {
    final bloc = context.read<CreateTodoLocalSaveBloc>();
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      final fileName = result.files.single.name;
      final filePath = result.files.single.path;
      final fileType = fileName != null ? fileName.split('.').last : " ";
      final file = File(filePath ?? '');
      final fileloader = FileLoaderForBloc(
          fileName: fileName,
          filePath: filePath ?? '',
          fileType: fileType,
          file: file);
      widget.fileResources
          .add(Resources(name: fileName, url: filePath ?? '', type: fileType));
      widget.filesLoaderForBloc.add(fileloader);
      bloc.add(FilesLoaderForBlocChanged(
          filesLoaderForBloc: widget.filesLoaderForBloc));
      bloc.add(FileResourcesChanged(fileresources: widget.fileResources));

      // try {
      //   final reference = FirebaseStorage.instance
      //       .ref('Resources/${response!.gId}/$fileName');
      //   await reference.putFile(file);
      //   final uri = await reference.getDownloadURL();
      //   widget.fileResources
      //       .add(Resources(name: fileName, url: uri, type: fileType));
      //   _setAttachmentUploading(false);
      // } on FirebaseException catch (e) {
      //   //
      //   _setAttachmentUploading(false);
      // }
    } else {
      // User canceled the picker
    }
  }

  _showBottomSheetForUpload() {
    return showModalBottomSheet(
        backgroundColor: Colors.white,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        builder: (context) {
          return TextScaleFactorClamper(
            child: Semantics(
              child: Container(
                height: 300,
                child: Column(
                  children: [
                    SizedBox(
                      height: 2,
                    ),
                    Center(
                        child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                          Radius.circular(10),
                        ),
                        color: aquaBlue,
                      ),
                      height: 4,
                      width: 42,
                    )),
                    SizedBox(
                      height: 20,
                    ),
                    BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                        builder: (context, pendoState) {
                      return Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Text(
                              "Select resource type",
                              textAlign: TextAlign.left,
                              style: montserratNormal.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                          ),
                          Semantics(
                            label: "Upload file resource",
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                      spreadRadius: 0,
                                    ),
                                  ]),
                              child: Container(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 10),
                                child: ExcludeSemantics(
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    leading: SvgPicture.asset(
                                      'images/file.svg',
                                      color: defaultDark,
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: Text(
                                      'File',
                                      style: darkTextFieldStyle.copyWith(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w700,
                                          color: defaultDark),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: defaultDark,
                                      size: 18,
                                    ),
                                    onTap: () {
                                      TodoPendoRepo.trackTapOnAddResourcesEvent(
                                          pendoState: pendoState,
                                          isLink: false,
                                          isEdit: false);
                                      Navigator.pop(context);
                                      _showFilePicker();
                                      setState(() {});
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Semantics(
                            label: "Upload link resource",
                            child: Container(
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.08),
                                      blurRadius: 5,
                                      offset: Offset(0, 2),
                                      spreadRadius: 0,
                                    ),
                                  ]),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
                                child: ExcludeSemantics(
                                  child: ListTile(
                                    tileColor: Colors.white,
                                    leading: SvgPicture.asset(
                                      'images/link.svg',
                                      color: defaultDark,
                                      height: 20,
                                      width: 20,
                                    ),
                                    title: Text(
                                      'Link',
                                      style: darkTextFieldStyle.copyWith(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700,
                                        color: defaultDark,
                                      ),
                                    ),
                                    trailing: Icon(
                                      Icons.arrow_forward_ios,
                                      color: defaultDark,
                                      size: 18,
                                    ),
                                    onTap: () {
                                      Navigator.pop(context);
                                      widget.fileTitleController.clear();
                                      widget.fileurlController.clear();
                                      TodoPendoRepo.trackTapOnAddResourcesEvent(
                                          pendoState: pendoState,
                                          isLink: true,
                                          isEdit: false);
                                      showLinkSheet(context);
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    }),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> showLinkSheet(BuildContext context,
      {bool update = false, int ind = -1}) {
    return showModalBottomSheet(
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return TextScaleFactorClamper(
            child: Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: Wrap(
                children: [
                  Semantics(
                    child: Container(
                      constraints: BoxConstraints(
                        maxHeight: 350,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      padding: EdgeInsets.all(20),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              child: Row(
                                children: [
                                  ExcludeSemantics(
                                    child: SvgPicture.asset(
                                      'images/link.svg',
                                      color: defaultDark,
                                      height: 20,
                                      width: 20,
                                    ),
                                  ),
                                  Text(
                                    "   Upload Link",
                                    textAlign: TextAlign.left,
                                    style: montserratNormal.copyWith(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  // SizedBox(
                                  //   width: MediaQuery.of(context).size.width * 0.35,
                                  // ),
                                  // InkWell(
                                  //   onTap: (){
                                  //     Navigator.pop(context);
                                  //     setState(() {
                                  //       setState(() {
                                  //         widget.linkResources.removeAt(ind);
                                  //       });
                                  //     });
                                  //
                                  //
                                  //   },
                                  //   child: SvgPicture.asset(
                                  //     'images/trash-2.svg',
                                  //     height: 20,
                                  //     width: 20,
                                  //     semanticsLabel: "delete link button",
                                  //   ),
                                  // )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 20,
                            ),
                            CommonTextField(
                                height: 50,
                                hintText: 'Enter Title',
                                isForLink: true,
                                inputController: widget.fileTitleController),
                            SizedBox(
                              height: 20,
                            ),
                            CommonTextField(
                                height: 50,
                                hintText: 'Enter or paste URL',
                                isForLink: true,
                                inputController: widget.fileurlController),
                            SizedBox(
                              height: 50,
                            ),
                            Container(
                              width: MediaQuery.of(context).size.width * 0.88,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Material(
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        side: BorderSide(color: pinkRed)),
                                    child: InkWell(
                                      onTap: () {
                                        Navigator.pop(context);
                                      },
                                      child: Container(
                                        width: 120,
                                        padding: EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "CANCEL",
                                            style: montserratBoldTextStyle
                                                .copyWith(
                                              color: pinkRed,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Material(
                                    color: pinkRed,
                                    elevation: 0,
                                    borderRadius: BorderRadius.circular(10),
                                    child: InkWell(
                                      onTap: () {
                                        widget.fileurlController.text = widget
                                            .fileurlController.text
                                            .trim();
                                        widget.fileTitleController.text = widget
                                            .fileTitleController.text
                                            .trim();
                                        var link =
                                            widget.fileurlController.text;
                                        if (link.contains(checkHttp) ||
                                            link.contains(checkHttps))
                                          link = link;
                                        else
                                          link =
                                              "https://${widget.fileurlController.text}";

                                        var reg = RegExp(
                                            r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$");
                                        final match = reg.hasMatch(link);

                                        if (widget.fileurlController.text
                                                .isEmpty &&
                                            widget.fileTitleController.text
                                                .isEmpty) {
                                          Helper.showGenericDialog(
                                              body:
                                                  'Please enter the details before clicking Done',
                                              context: context,
                                              okAction: () {
                                                Navigator.pop(context);
                                              });
                                        } else if (widget
                                            .fileurlController.text.isEmpty) {
                                          Helper.showGenericDialog(
                                              body:
                                                  'Please Enter all fields correctly',
                                              context: context,
                                              okAction: () {
                                                Navigator.pop(context);
                                              });
                                        } else if (widget
                                            .fileTitleController.text.isEmpty) {
                                          Helper.showGenericDialog(
                                              body:
                                                  'Please enter a title for your link',
                                              context: context,
                                              okAction: () {
                                                Navigator.pop(context);
                                              });
                                        } else if (match == false) {
                                          Helper.showGenericDialog(
                                              body: 'Please enter a valid url',
                                              context: context,
                                              okAction: () {
                                                Navigator.pop(context);
                                              });
                                        } else {
                                          final bloc = BlocProvider.of<
                                              CreateTodoLocalSaveBloc>(context);
                                          if (update) {
                                            widget.todolocalSaveState
                                                    .linkResources![ind].name =
                                                widget.fileTitleController.text;
                                            widget.todolocalSaveState
                                                    .linkResources![ind].url =
                                                widget.fileurlController.text;
                                            bloc.add(LinkResourcesChanged(
                                                linkresources: widget
                                                    .todolocalSaveState
                                                    .linkResources!));
                                          } else {
                                            widget.linkResources.add(Resources(
                                                name: widget
                                                    .fileTitleController.text,
                                                url: link,
                                                type: 'Link'));
                                            bloc.add(LinkResourcesChanged(
                                                linkresources:
                                                    widget.linkResources));
                                          }
                                          widget.fileTitleController.clear();
                                          widget.fileurlController.clear();
                                          Navigator.pop(context);
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.all(8),
                                        width: 120,
                                        decoration: BoxDecoration(
                                          color: Colors.transparent,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        child: Center(
                                          child: Text(
                                            "DONE",
                                            style: montserratBoldTextStyle
                                                .copyWith(
                                              color: white,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }
}
