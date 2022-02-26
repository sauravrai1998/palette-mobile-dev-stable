import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/text_field.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/todo_module/bloc/todo_ad_bloc/todo_ad_bloc.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/event_venue_box_container.dart';
import 'package:palette/modules/todo_module/widget/file_resource_card_button.dart';
import 'package:palette/modules/todo_module/widget/textFormfieldForTodo.dart';
import 'package:palette/modules/todo_module/widget/todo_type_dropdown.dart';
import 'package:palette/modules/todo_module/widget/upload_resources_area.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:palette/utils/validation_regex.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminEditTodoForm extends StatefulWidget {
  final Todo todoItem;
  final List<Resources> fileRes;
  final List<Resources> linkRes;
  final String status;

  AdminEditTodoForm({
    required this.todoItem,
    required this.fileRes,
    required this.linkRes,
    required this.status,
  });

  @override
  _AdminEditTodoFormState createState() => _AdminEditTodoFormState();
}

class _AdminEditTodoFormState extends State<AdminEditTodoForm> {
  bool updateState = false;

  bool errorAction = false;
  bool errorDescription = false;
  bool errorVenue = false;
  bool errorDue = false;
  bool errorEvent = false;
  bool errorDropdown = false;

  String filterDropDownValue = "to-do type";
  List<Resources> fileResources = [];
  List<Resources> linkResources = [];
  List<String> deletedResources = [];
  List<Resources> addedResources = [];
  List<Resources> addedFileResources = [];
  List<File> addedFiles = [];
  List<String> filter = [
    'to-do type',
    'Job Application',
    'Employment',
    'Education',
    'College Application',
    "Event - Arts",
    "Event - Social",
    "Event - Volunteer",
    "Event - Sports",
    "Other"
  ];
  bool isEnable = false;
  bool _isAttachmentUploading = false;
  bool dueDateIsNotEmpty = false;
  bool dueDateEventIsNotEmpty = false;
  DateTime? _dateTimeStart;
  DateTime _showDate = DateTime.now();
  DateTime? _dateTimeStartEve;
  DateTime _showDateEve = DateTime.now();
  TextEditingController actionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FocusNode? actionFocus;
  late String _time, _timeEve;
  TextEditingController _timeController = TextEditingController();
  TimeOfDay showselectedTime = TimeOfDay.now();
  TimeOfDay? selectedTime;
  TimeOfDay? selectedEveTime;
  TimeOfDay showSelectedEveTime = TimeOfDay.now();

  TextEditingController fileTitleController = TextEditingController();
  TextEditingController fileurlController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();

  String? sfid;
  String? sfuuid;
  String? role;

  Future<Null> _selectTime(
    BuildContext context,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: showselectedTime,
    );
    if (picked != null)
      setState(() {
        selectedTime = picked;
        showselectedTime = picked;
        _time =
            "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, showselectedTime.hour, showselectedTime.minute))}";
        _timeController.text = _time;
        _timeController.text = showselectedTime.toString();
      });
  }

  Future<Null> _selectTimeEvent(
    BuildContext context,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: showselectedTime,
    );
    if (picked != null)
      setState(() {
        selectedEveTime = picked;
        showSelectedEveTime = picked;
        _timeEve =
            "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, showSelectedEveTime.hour, showSelectedEveTime.minute))}";
        _timeController.text = _timeEve;
        _timeController.text = showSelectedEveTime.toString();
      });
  }

  @override
  void initState() {
    // fileResources = widget.fileRes;
    // linkResources = widget.linkRes;
    widget.linkRes.forEach((element) {
      if (!linkResources.contains(element)) {
        linkResources.addAll(widget.linkRes);
      }
    });

    widget.fileRes.forEach((element) {
      if (!fileResources.contains(element)) {
        fileResources.addAll(widget.fileRes);
      }
    });
    actionController.text = widget.todoItem.task.name!;
    descriptionController.text = widget.todoItem.task.description ?? '';
    // fileTitleController.text = widget.linkRes[0].name;
    filterDropDownValue = widget.todoItem.task.type ?? 'Other';
    if (widget.todoItem.task.eventAt != null) {
      _dateTimeStartEve =
          DateTime.parse(widget.todoItem.task.eventAt!).toLocal();
      if (widget.todoItem.task.venue != null) {
        eventVenueController.text = widget.todoItem.task.venue!;
      }
      _showDateEve = DateTime.parse(widget.todoItem.task.eventAt!).toLocal();
      selectedEveTime = TimeOfDay(
          hour: DateTime.parse(widget.todoItem.task.eventAt!).toLocal().hour,
          minute:
              DateTime.parse(widget.todoItem.task.eventAt!).toLocal().minute);
      showSelectedEveTime = TimeOfDay(
          hour: DateTime.parse(widget.todoItem.task.eventAt!).toLocal().hour,
          minute:
              DateTime.parse(widget.todoItem.task.eventAt!).toLocal().minute);
      _timeEve =
          "${DateFormat.jm().format(DateTime.parse(widget.todoItem.task.eventAt!).toLocal())}";
    } else {
      eventVenueController.clear();
      _dateTimeStartEve = null;
      selectedTime = null;
      _timeEve = "Event Time";
    }
    _dateTimeStart = widget.todoItem.task.completeBy.toLocal();
    selectedTime = widget.todoItem.task.completeBy.year == 9998
        ? null
        : TimeOfDay(
            hour: widget.todoItem.task.completeBy.toLocal().hour,
            minute: widget.todoItem.task.completeBy.toLocal().minute);
    showselectedTime = widget.todoItem.task.completeBy.year == 9998
        ? TimeOfDay.now()
        : TimeOfDay(
            hour: widget.todoItem.task.completeBy.toLocal().hour,
            minute: widget.todoItem.task.completeBy.toLocal().minute);
    _time =
        "${DateFormat.jm().format(widget.todoItem.task.completeBy.toLocal())}";
    _getSfidAndRole();
    super.initState();
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
    sfuuid = prefs.getString(saleforceUUIDConstant);
    role = prefs.getString('role').toString();
  }

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;

    return BlocListener(
      bloc: context.read<TodoAdminBloc>(),
      listener: (context, state) {
        if (updateState && state is FetchTodoAdminSuccessState) {
          Navigator.pop(context);
          Navigator.pop(context);
          context.read<TodoAdminBloc>().add(FetchTodosAdminEvent());
        } else if (state is UpdateTodoAdminErrorState) {
          Navigator.pop(context);
          Navigator.pop(context);
          final bloc = context.read<TodoAdminBloc>();
          bloc.add(
            FetchTodosAdminEvent(),
          );
          //
        }
      },
      child: BlocBuilder(builder: (context, state) {
        if (state is UpdateTodoAdminLoadingState) updateState = true;
        if (state is UpdateTodoAdminLoadingState ||
            state is FetchTodoAdminLoadingState)
          return Center(
            child: CircularProgressIndicator(),
          );
        else
          return ListView(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(40, 30, 40, 10),
                child: Column(
                  children: [
                    TodoTypeDropDownMenu(
                      errorDropdown: errorDropdown,
                      onChanged: (newValue) {
                        setState(() {
                          filterDropDownValue =
                              newValue != null ? newValue : 'to-do type';
                          if (!filterDropDownValue.startsWith('Event')) {
                            errorEvent = false;
                            errorVenue = false;
                          }
                        });
                      },
                      selectedValue: filterDropDownValue,
                      items: filter,
                      enabled: false,
                    ),
                    const SizedBox(height: 20),
                    CommonTextFieldTodo(
                      height: 50,
                      hintText: 'Enter Action Text',
                      inputController: actionController,
                      isForAction: true,
                      isCreateForm: false,
                      errorFlag: errorAction,
                      initialValue: actionController.text,
                      onChanged: (value) {
                        setState(() {
                          actionController.text = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildDatePicker(context, false),
                        dueDateIsNotEmpty == false && _time == '' ||
                                widget.todoItem.task.completeBy.year == 9998 &&
                                    _dateTimeStart!.year == 9998
                            ? Container()
                            : buildTimePicker(context, false),
                      ],
                    ),
                    if (filterDropDownValue.startsWith('Event'))
                      const SizedBox(
                        height: 20,
                      ),
                    if (filterDropDownValue.startsWith('Event'))
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          buildDatePicker(context, true),
                          dueDateEventIsNotEmpty == false && _timeEve == ''
                              ? Container()
                              : buildTimePicker(context, true),
                        ],
                      ),
                    const SizedBox(
                      height: 20,
                    ),
                    CommonTextFieldTodo(
                      height: 150,
                      hintText: 'Enter Description',
                      inputController: descriptionController,
                      isCreateForm: false,
                      errorFlag: errorDescription,
                      initialValue: widget.todoItem.task.description,
                      onChanged: (value) {
                        setState(() {
                          descriptionController.text = value;
                        });
                      },
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    if (filterDropDownValue.startsWith('Event'))
                      EventVenueTextBox(
                          controller: eventVenueController,
                          errorFlag: errorVenue,
                          initialValue: widget.todoItem.task.venue ?? '',
                          isCreateForm: false,
                          onChanged: (value) {
                            setState(() {
                              eventVenueController.text = value;
                            });
                          }),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                  builder: (context, pendoState) {
                return UploadResourcesArea(
                    onUploadTap: () {
                      _showBottomSheetForUpload();
                      TodoPendoRepo.trackTapOnUploadResourcesEvent(
                          pendoState: pendoState);
                    },
                    isAttachmentUploading: _isAttachmentUploading);
              }),
              SizedBox(height: 20),
              if (fileResources.isNotEmpty && fileResources.length > 0)
                Container(
                  padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
                  width: device.width * 0.8,
                  height: 150,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: fileResources.length,
                      itemBuilder: (ctx, ind) {
                        return Container(
                          margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                          child: Stack(children: [
                            FileResourceCardButton(
                              gid: widget.todoItem.task.gid,
                              file: fileResources[ind],
                              isForm: true,
                              isForUpdate: false,
                              sfid: sfid,
                              role: role,
                              sfuuid: sfuuid,
                              todotitle: widget.todoItem.task.name ?? '',
                            ),
                            BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                                builder: (context, pendoState) {
                              return Positioned(
                                right: 0,
                                top: 0,
                                child: InkWell(
                                  onTap: () {
                                    print(
                                        'fileResources: ${fileResources[ind].id}');
                                    setState(() {
                                      if (fileResources[ind].id != null) {
                                        deletedResources
                                            .add(fileResources[ind].id!);
                                      } else {
                                        addedResources
                                            .remove(fileResources[ind]);
                                      }
                                      TodoPendoRepo
                                          .trackTapOnDeleteResourceEvent(
                                              pendoState: pendoState,
                                              link: fileResources[ind].url);
                                      addedFileResources
                                          .remove(fileResources[ind]);
                                      fileResources.removeAt(ind);
                                    });
                                    print(
                                        'deletedResources: $deletedResources');
                                  },
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(8),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withOpacity(0.15),
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
                              );
                            }),
                          ]),
                        );
                      }),
                ),
              SizedBox(height: 20),
              linkResources.isNotEmpty && linkResources.length > 0
                  ? Center(
                      child: Container(
                        height: 100,
                        width: device.width * 0.8,
                        child: ListView.builder(
                            itemCount: linkResources.length,
                            itemBuilder: (ctx, ind) {
                              return buildLinkViewer(device, ind, context);
                            }),
                      ),
                    )
                  : SizedBox(
                      height: 20,
                    ),
              const SizedBox(
                height: 10,
              ),
              Padding(
                padding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                child: Center(
                  child: Container(
                    height: 40,
                    width: 200,
                    child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                        builder: (context, pendoState) {
                      return MaterialButton(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10),
                          ),
                        ),
                        color: pinkRed,
                        onPressed: _isAttachmentUploading
                            ? () {}
                            : () async {
                                if (filterDropDownValue == 'to-do type') {
                                  setState(() {
                                    errorDropdown = true;
                                  });
                                  return;
                                } else {
                                  setState(() {
                                    errorDropdown = false;
                                  });
                                }
                                if (actionController.text.trim().isEmpty ||
                                    actionController.text.length >= 81) {
                                  setState(() {
                                    errorAction = true;
                                  });
                                  return;
                                } else {
                                  setState(() {
                                    errorAction = false;
                                  });
                                }
                                if (filterDropDownValue.startsWith("Event") &&
                                    (eventVenueController.text
                                        .trim()
                                        .isEmpty)) {
                                  setState(() {
                                    errorVenue = true;
                                  });
                                  return;
                                } else {
                                  setState(() {
                                    errorVenue = false;
                                  });
                                }
                                if (filterDropDownValue.startsWith("Event") &&
                                    (_dateTimeStartEve == null ||
                                        selectedEveTime == null)) {
                                  setState(() {
                                    errorEvent = true;
                                  });
                                  return;
                                } else {
                                  setState(() {
                                    errorEvent = false;
                                  });
                                }
                                if (addedFileResources.isNotEmpty) {
                                  _setAttachmentUploading(true);
                                  for (var i = 0;
                                      i < addedFileResources.length;
                                      i++) {
                                    var newFileRes = addedFileResources[i];
                                    try {
                                      final reference = FirebaseStorage.instance
                                          .ref(
                                              'Resources/${widget.todoItem.task.gid}/${newFileRes.name}');
                                      await reference.putFile(addedFiles[i]);
                                      final uri =
                                          await reference.getDownloadURL();
                                      newFileRes.url = uri;
                                      addedResources.add(newFileRes);
                                    } on FirebaseException catch (e) {
                                      print(e);
                                    }
                                  }
                                }

                                /// Pendo log for edit event
                                TodoPendoRepo.trackEditTodoEvent(
                                    type: filterDropDownValue,
                                    title: actionController.text,
                                    pendoState: pendoState);

                                if (filterDropDownValue.startsWith("Event") &&
                                    (_dateTimeStartEve != null &&
                                        // selectedEveTime != null &&
                                        eventVenueController.text
                                            .trim()
                                            .isNotEmpty) &&
                                    (
                                        // selectedTime != null &&
                                        // descriptionController.text.isEmpty ||
                                        filterDropDownValue != 'to-do type' &&
                                            actionController.text
                                                .trim()
                                                .isNotEmpty &&
                                            actionController.text.length <
                                                81)) {
                                  List<String> ids = [];
                                  widget.todoItem.task.asignee
                                      .forEach((element) {
                                    ids.add(element.todoId);
                                  });
                                  BlocProvider.of<TodoAdminBloc>(context).add(
                                    UpdateTodoAdminEvent(
                                      todoModel: TodoModel(
                                        name: actionController.text,
                                        description:
                                            descriptionController.text.isEmpty
                                                ? ' '
                                                : descriptionController.text,
                                        eventAt: DateTime(
                                                _showDateEve.year,
                                                _showDateEve.month,
                                                _showDateEve.day,
                                                showSelectedEveTime.hour,
                                                showSelectedEveTime.minute)
                                            .toUtc()
                                            .toIso8601String(),
                                        status: widget.todoItem.task.taskStatus,
                                        completedBy: _dateTimeStart == null ||
                                                _dateTimeStart!.year == 9998
                                            ? ''
                                            : DateTime(
                                                    _dateTimeStart!.year,
                                                    _dateTimeStart!.month,
                                                    _dateTimeStart!.day,
                                                    showselectedTime.hour,
                                                    showselectedTime.minute)
                                                .toUtc()
                                                .toIso8601String(),
                                        type: filterDropDownValue,
                                        venue: eventVenueController.text,
                                      ),
                                      taskId: ids,
                                      newResources: addedResources,
                                      deletedResources: deletedResources,
                                    ),
                                  );
                                  widget.todoItem.task.name =
                                      actionController.text;
                                  widget.todoItem.task.completeBy = DateTime(
                                      _showDate.year,
                                      _showDate.month,
                                      _showDate.day,
                                      showselectedTime.hour,
                                      showselectedTime.minute);
                                  widget.todoItem.task.description =
                                      descriptionController.text;
                                  widget.todoItem.task.type =
                                      filterDropDownValue;
                                  widget.todoItem.task.eventAt = DateTime(
                                          _showDateEve.year,
                                          _showDateEve.month,
                                          _showDateEve.day,
                                          showSelectedEveTime.hour,
                                          showSelectedEveTime.minute)
                                      .toIso8601String();
                                  widget.todoItem.task.venue =
                                      eventVenueController.text;
                                  widget.todoItem.todoResources =
                                      linkResources + fileResources;
                                } else if (errorEvent == false &&
                                    errorVenue == false &&
                                    (
                                        // _dateTimeStart != null &&
                                        // selectedTime != null &&
                                        filterDropDownValue != 'to-do type' &&
                                            !filterDropDownValue
                                                .startsWith("Event") &&
                                            actionController.text
                                                .trim()
                                                .isNotEmpty &&
                                            actionController.text.length <
                                                81)) {
                                  List<String> ids = [];
                                  widget.todoItem.task.asignee
                                      .forEach((element) {
                                    ids.add(element.todoId);
                                  });
                                  BlocProvider.of<TodoAdminBloc>(context).add(
                                    UpdateTodoAdminEvent(
                                      todoModel: TodoModel(
                                        name: actionController.text,
                                        description:
                                            descriptionController.text.isEmpty
                                                ? ' '
                                                : descriptionController.text,
                                        status: widget.todoItem.task.taskStatus,
                                        completedBy: _dateTimeStart == null ||
                                                _dateTimeStart!.year == 9998
                                            ? ''
                                            : DateTime(
                                                    _dateTimeStart!.year,
                                                    _dateTimeStart!.month,
                                                    _dateTimeStart!.day,
                                                    showselectedTime.hour,
                                                    showselectedTime.minute)
                                                .toUtc()
                                                .toIso8601String(),
                                        type: filterDropDownValue,
                                      ),
                                      taskId: ids,
                                      newResources: addedResources,
                                      deletedResources: deletedResources,
                                    ),
                                  );
                                  widget.todoItem.task.name =
                                      actionController.text;
                                  widget.todoItem.task.completeBy = DateTime(
                                      _showDate.year,
                                      _showDate.month,
                                      _showDate.day,
                                      showselectedTime.hour,
                                      showselectedTime.minute);
                                  widget.todoItem.task.description =
                                      descriptionController.text;
                                  widget.todoItem.task.type =
                                      filterDropDownValue;
                                  widget.todoItem.todoResources =
                                      linkResources + fileResources;
                                  widget.todoItem.task.eventAt = null;
                                  widget.todoItem.task.venue = null;
                                }
                              },
                        child: Text(
                          _isAttachmentUploading ? 'Uploading' : "Update",
                          style: roboto700.copyWith(
                              fontSize: 17, color: Colors.white),
                        ),
                      );
                    }),
                  ),
                ),
              ),
              const SizedBox(height: 40),
            ],
          );
      }),
    );
  }

  Center buildLinkViewer(Size device, int ind, BuildContext context) {
    return Center(
        child: Container(
      width: device.width * 0.78,
      height: 40,
      padding: EdgeInsets.fromLTRB(15, 4, 15, 4),
      margin: EdgeInsets.only(top: 3, bottom: 6),
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
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
            builder: (context, pendoState) {
          return GestureDetector(
            onTap: () {
              TodoPendoRepo.trackTapOnUpdateLinkEvent(
                  pendoState: pendoState, link: linkResources[ind].url);
              showLinkUpdateSheet(context, ind: ind);
            },
            child: Container(
              width: device.width * 0.65,
              child: Text(
                "   ${linkResources[ind].name}",
                overflow: TextOverflow.ellipsis,
                style: roboto700.copyWith(fontSize: 16),
              ),
            ),
          );
        }),
      ]),
    ));
  }

  buildTimePicker(
    BuildContext context,
    bool isEvent,
  ) {
    return InkWell(
      onTap: () {
        isEvent ? _selectTimeEvent(context) : _selectTime(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (selectedTime == null && errorDue) ||
                      (selectedEveTime == null && errorEvent && isEvent)
                  ? todoListActiveTab
                  : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ]),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              spacing: 8,
              children: [
                SvgPicture.asset(
                  'images/clock.svg',
                  color: (selectedTime == null && errorDue) ||
                          (selectedEveTime == null && errorEvent && isEvent)
                      ? todoListActiveTab
                      : defaultDark,
                  height: 19,
                  width: 19,
                ),
                if (isEvent)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      selectedEveTime == null
                          ? 'Event Time'
                          : _timeEve == ''
                              ? 'Event Time'
                              : '$_timeEve',
                      style: montserratNormal.copyWith(
                        fontSize: 12,
                        color: errorEvent && selectedEveTime == null
                            ? todoListActiveTab
                            : defaultDark,
                      ),
                    ),
                  ),
                if (!isEvent)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      selectedTime == null ? 'Due Time' : '$_time',
                      style: montserratNormal.copyWith(
                        fontSize: 12,
                        color:
                            // errorDue && selectedTime == null
                            //     ? todoListActiveTab
                            //     :
                            defaultDark,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _setAttachmentUploading(bool uploading) {
    _isAttachmentUploading = uploading;
  }

  void _showFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      // _setAttachmentUploading(true);
      final fileName = result.files.single.name;
      final filePath = result.files.single.path;
      var fileType = fileName.split('.').last;
      final file = File(filePath ?? '');
      addedFiles.add(file);
      if (fileType == 'jpg' ||
          fileType == 'jpeg' ||
          fileType == 'gif' ||
          fileType == 'bmp' ||
          fileType == 'svg' ||
          fileType == 'webp' ||
          fileType == 'tiff' ||
          fileType == 'tif') {
        fileType = 'JPG';
      }
      final res =
          Resources(name: fileName, url: filePath ?? '', type: fileType);
      addedFileResources.add(res);
      fileResources.add(res);
      setState(() {});
      // }
    } else {
      // User canceled the picker
    }
  }

  buildDatePicker(BuildContext context, bool isEve) {
    return InkWell(
      onTap: () {
        isEve
            ? showDatePicker(
                    context: context,
                    initialDate: _dateTimeStartEve == null
                        ? DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        : _showDateEve,
                    firstDate: DateTime(2021),
                    lastDate: DateTime(DateTime.now().year + 2),
                    cancelText: 'CLEAR')
                .then((date) {
                setState(() {
                  if (date != null) {
                    dueDateEventIsNotEmpty = true;
                    _timeEve = widget.todoItem.task.eventAt != null
                        ? "${DateFormat.jm().format(DateTime.parse(widget.todoItem.task.eventAt!).toLocal())}"
                        : '';
                  } else {
                    dueDateEventIsNotEmpty = false;
                    _timeEve = '';
                  }
                  _dateTimeStartEve = date;
                  _showDateEve = date != null ? date : _showDate;
                });
              })
            : showDatePicker(
                    context: context,
                    initialDate: _dateTimeStart == null
                        ? DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        : _showDate,
                    firstDate: DateTime(2021),
                    lastDate: DateTime(DateTime.now().year + 2),
                    cancelText: 'CLEAR')
                .then((date) {
                setState(() {
                  if (date != null) {
                    dueDateIsNotEmpty = true;
                    _time =
                        "${DateFormat.jm().format(widget.todoItem.task.completeBy.toLocal())}";
                  } else {
                    dueDateIsNotEmpty = false;
                    _time = '';
                  }
                  _dateTimeStart = date;
                  _showDate = date != null ? date : _showDate;
                });
              });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (_dateTimeStart == null && errorDue) ||
                      (_dateTimeStartEve == null && errorEvent && isEve)
                  ? todoListActiveTab
                  : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ]),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Wrap(
              spacing: 8,
              children: [
                Icon(
                  Icons.calendar_today,
                  color: (_dateTimeStart == null && errorDue) ||
                          (_dateTimeStartEve == null && errorEvent && isEve)
                      ? todoListActiveTab
                      : defaultDark,
                  size: 19,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: isEve
                      ? Text(
                          _dateTimeStartEve == null
                              ? 'Event Date'
                              : '${(_dateTimeStartEve?.month)}-${_dateTimeStartEve?.day}-${_dateTimeStartEve?.year}',
                          style: montserratNormal.copyWith(
                            fontSize: 12,
                            color: errorEvent && _dateTimeStartEve == null
                                ? todoListActiveTab
                                : defaultDark,
                          ),
                        )
                      : Text(
                          _dateTimeStart == null
                              ? 'Due Date'
                              : _dateTimeStart!.year == 9998 &&
                                      widget.todoItem.task.completeBy.year ==
                                          9998
                                  ? 'Due Date'
                                  : '${(_dateTimeStart?.month)}-${_dateTimeStart?.day}-${_dateTimeStart?.year}',
                          style: montserratNormal.copyWith(
                              fontSize: 12,
                              color: errorDue && _dateTimeStart == null
                                  ? todoListActiveTab
                                  : defaultDark),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
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
            child: Container(
              height: 250,
              child: SingleChildScrollView(
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
                    Column(
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
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.08),
                                blurRadius: 5,
                                offset: Offset(0, 2),
                                spreadRadius: 0,
                              ),
                            ]),
                            child: Container(
                              padding: EdgeInsets.fromLTRB(20, 0, 20, 0),
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
                                    Navigator.pop(context);
                                    _showFilePicker();
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 9,
                        ),
                        Semantics(
                          label: "Upload link resource",
                          child: Container(
                            decoration:
                                BoxDecoration(color: Colors.white, boxShadow: [
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
                                child: BlocBuilder<PendoMetaDataBloc,
                                        PendoMetaDataState>(
                                    builder: (context, pendoState) {
                                  return ListTile(
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
                                      fileTitleController.clear();
                                      fileurlController.clear();
                                      TodoPendoRepo.trackTapOnAddResourcesEvent(
                                          pendoState: pendoState,
                                          isLink: true,
                                          isEdit: true);
                                      showLinkSheet(context);
                                    },
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }

  Future<dynamic> showLinkUpdateSheet(BuildContext context,
      {bool update = false, ind}) {
    fileTitleController.text = widget.linkRes[ind].name;
    fileurlController.text = widget.linkRes[ind].url;

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
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(children: [
              BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                  builder: (context, pendoState) {
                return Container(
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
                  child: Stack(
                    children: [
                      Column(mainAxisSize: MainAxisSize.min, children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
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
                            inputController: fileTitleController,
                            fieldEnabled: false),
                        SizedBox(
                          height: 20,
                        ),
                        CommonTextField(
                            height: 50,
                            isForLink: true,
                            hintText: 'Enter or paste URL',
                            inputController: fileurlController,
                            fieldEnabled: false),
                        SizedBox(
                          height: 50,
                        ),
                        Container(
                          width: MediaQuery.of(context).size.width * 0.88,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Material(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    side: BorderSide(color: pinkRed)),
                                child: InkWell(
                                  onTap: () {
                                    TodoPendoRepo.trackTapOnEditLinkEvent(
                                        pendoState: pendoState,
                                        link: widget.linkRes[ind].url);
                                    Navigator.pop(context);
                                    showLinkUpdateEnableSheet(context,
                                        ind: ind, update: true);
                                  },
                                  child: Container(
                                    width: 120,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "EDIT",
                                        style: montserratBoldTextStyle.copyWith(
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
                                    Navigator.pop(context);
                                    TodoPendoRepo.trackTapOnDoneLinkEvent(
                                        pendoState: pendoState,
                                        link: linkResources[ind].url);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.all(8),
                                    width: 120,
                                    decoration: BoxDecoration(
                                      color: Colors.transparent,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "DONE",
                                        style: montserratBoldTextStyle.copyWith(
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
                      ]),
                      Positioned(
                          top: 12,
                          right: 10,
                          child: InkWell(
                            onTap: () {
                              setState(() {
                                if (linkResources[ind].id != null)
                                  deletedResources.add(linkResources[ind].id!);
                                else
                                  addedResources.remove(linkResources[ind]);

                                TodoPendoRepo.trackTapOnDeleteLinkEvent(
                                    pendoState: pendoState,
                                    link: linkResources[ind].url);
                                linkResources.removeAt(ind);
                              });

                              Navigator.pop(context);
                            },
                            child: Semantics(
                              label: "Tap to delete link",
                              child: SvgPicture.asset(
                                'images/trash-2.svg',
                                height: 20,
                                width: 20,
                              ),
                            ),
                          ))
                    ],
                  ),
                );
              }),
            ]),
          );
        });
  }

  Future<dynamic> showLinkUpdateEnableSheet(BuildContext context,
      {bool update = false, ind}) {
    fileTitleController.text = widget.linkRes[ind].name;
    fileurlController.text = widget.linkRes[ind].url;

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
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: Wrap(children: [
              Container(
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
                child: Column(mainAxisSize: MainAxisSize.min, children: [
                  SizedBox(
                    height: 10,
                  ),
                  Container(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
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
                    inputController: fileTitleController,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  CommonTextField(
                    height: 50,
                    isForLink: true,
                    hintText: 'Enter or paste URL',
                    inputController: fileurlController,
                  ),
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.88,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Material(
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10.0),
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
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "CANCEL",
                                  style: montserratBoldTextStyle.copyWith(
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
                              fileurlController.text =
                                  fileurlController.text.trim();
                              fileTitleController.text =
                                  fileTitleController.text.trim();
                              var link = fileurlController.text;
                              if (link.contains(checkHttp) ||
                                  link.contains(checkHttps))
                                link = link;
                              else
                                link = "https://${fileurlController.text}";

                              var reg = RegExp(
                                  r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$");
                              final match = reg.hasMatch(link);
                              if (fileurlController.text.isEmpty &&
                                  fileTitleController.text.isEmpty) {
                                Helper.showGenericDialog(
                                    body:
                                        'Please enter the details before clicking Done',
                                    context: context,
                                    okAction: () {
                                      Navigator.pop(context);
                                    });
                              } else if (fileurlController.text.isEmpty) {
                                Helper.showGenericDialog(
                                    body: 'Please Enter all fields correctly',
                                    context: context,
                                    okAction: () {
                                      Navigator.pop(context);
                                    });
                              } else if (fileTitleController.text.isEmpty) {
                                Helper.showGenericDialog(
                                    body: 'Please enter a title for your link',
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
                                setState(() {
                                  if (update) {
                                    linkResources[ind].name =
                                        fileTitleController.text;
                                    linkResources[ind].url =
                                        fileurlController.text;
                                    deletedResources
                                        .add(linkResources[ind].id!);
                                    // addedResources.add(linkResources[ind]);
                                  } else {
                                    final res = Resources(
                                        name: fileTitleController.text,
                                        url: link,
                                        type: 'Link');
                                    linkResources.removeAt(ind);
                                    linkResources.add(res);
                                    addedResources.add(res);
                                  }
                                  fileTitleController.clear();
                                  fileurlController.clear();
                                  Navigator.pop(context);
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              width: 120,
                              decoration: BoxDecoration(
                                color: Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Center(
                                child: Text(
                                  "DONE",
                                  style: montserratBoldTextStyle.copyWith(
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
                ]),
              ),
            ]),
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
              child: Wrap(children: [
                Container(
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
                    child: Column(mainAxisSize: MainAxisSize.min, children: [
                      SizedBox(
                        height: 10,
                      ),
                      Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SvgPicture.asset(
                              'images/link.svg',
                              color: defaultDark,
                              height: 20,
                              width: 20,
                            ),
                            Text(
                              "   Upload Link",
                              textAlign: TextAlign.left,
                              style: montserratNormal.copyWith(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
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
                          inputController: fileTitleController),
                      SizedBox(
                        height: 20,
                      ),
                      CommonTextField(
                          height: 50,
                          isForLink: true,
                          hintText: 'Enter or paste URL',
                          inputController: fileurlController),
                      SizedBox(
                        height: 50,
                      ),
                      Container(
                        width: MediaQuery.of(context).size.width * 0.88,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Material(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                  side: BorderSide(color: pinkRed)),
                              child: BlocBuilder<PendoMetaDataBloc,
                                      PendoMetaDataState>(
                                  builder: (context, pendoState) {
                                return InkWell(
                                  onTap: () {
                                    TodoPendoRepo.trackTapOnCancelLinkEvent(
                                        pendoState: pendoState);
                                    Navigator.pop(context);
                                  },
                                  child: Container(
                                    width: 120,
                                    padding: EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        "CANCEL",
                                        style: montserratBoldTextStyle.copyWith(
                                          color: pinkRed,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            Material(
                              color: pinkRed,
                              elevation: 0,
                              borderRadius: BorderRadius.circular(10),
                              child: InkWell(
                                onTap: () {
                                  fileurlController.text =
                                      fileurlController.text.trim();
                                  fileTitleController.text =
                                      fileTitleController.text.trim();
                                  var link = fileurlController.text;
                                  if (link.contains(checkHttp) ||
                                      link.contains(checkHttps))
                                    link = link;
                                  else
                                    link = "https://${fileurlController.text}";

                                  var reg = RegExp(
                                      r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$");
                                  final match = reg.hasMatch(link);

                                  if (fileurlController.text.isEmpty &&
                                      fileTitleController.text.isEmpty) {
                                    Helper.showGenericDialog(
                                        body:
                                            'Please enter the details before clicking Done',
                                        context: context,
                                        okAction: () {
                                          Navigator.pop(context);
                                        });
                                  } else if (fileurlController.text.isEmpty) {
                                    Helper.showGenericDialog(
                                        body:
                                            'Please Enter all fields correctly',
                                        context: context,
                                        okAction: () {
                                          Navigator.pop(context);
                                        });
                                  } else if (fileTitleController.text.isEmpty) {
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
                                    setState(() {
                                      if (update) {
                                        linkResources[ind].name =
                                            fileTitleController.text;
                                        linkResources[ind].url =
                                            fileurlController.text;
                                      } else {
                                        final res = Resources(
                                            name: fileTitleController.text,
                                            url: link,
                                            type: 'Link');
                                        linkResources.add(res);
                                        addedResources.add(res);
                                      }
                                      fileTitleController.clear();
                                      fileurlController.clear();
                                      Navigator.pop(context);
                                    });
                                  }
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  width: 120,
                                  decoration: BoxDecoration(
                                    color: Colors.transparent,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      "DONE",
                                      style: montserratBoldTextStyle.copyWith(
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
                    ]),
                  ),
                ),
              ]),
            ),
          );
        });
  }
}
