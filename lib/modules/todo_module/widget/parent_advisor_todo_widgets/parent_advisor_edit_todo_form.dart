import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/searchbar_recipients.dart';
import 'package:palette/common_components/text_field.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_bloc.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_event.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_state.dart';
import 'package:palette/modules/todo_module/models/asignee.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';
import 'package:palette/modules/todo_module/models/ward.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/add_resource_button.dart';
import 'package:palette/modules/todo_module/widget/event_venue_box_container.dart';
import 'package:palette/modules/todo_module/widget/file_resource_card_button.dart';
import 'package:palette/modules/todo_module/widget/textFormfieldForTodo.dart';
import 'package:palette/modules/todo_module/widget/upload_resources_area.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:palette/utils/validation_regex.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../create_new_form.dart';
import '../multiSelectListItem.dart';
import '../self_assign_todo_button.dart';
import '../suggest_program_todo_button.dart';

class ParentAdvisorEditTodoForm extends StatefulWidget {
  final Todo todoItem;
  final String selfSfid;
  final List<Resources> fileRes;
  final List<Resources> linkRes;
  final String status;

  ParentAdvisorEditTodoForm({
    required this.todoItem,
    required this.selfSfid,
    required this.fileRes,
    required this.linkRes,
    required this.status,
  });

  @override
  _ParentAdvisorEditTodoFormState createState() =>
      _ParentAdvisorEditTodoFormState();
}

class _ParentAdvisorEditTodoFormState extends State<ParentAdvisorEditTodoForm> {
  bool updateState = false;

  bool errorAction = false;
  bool errorDescription = false;
  bool errorVenue = false;
  bool errorDue = false;
  bool errorEvent = false;
  bool errorAsignee = false;
  bool errorDropdown = false;

  String filterDropDownValue = "to-do type";
  List<Resources> fileResources = [];
  List<Resources> linkResources = [];
  List<String> deletedResources = [];
  List<Resources> addedResources = [];
  List<Resources> addedFileResources = [];
  List<File> addedFiles = [];
  List<String> selectedAsignee = [];
  List<Asignee> selectedAsigneeCircularList = [];
  List<Asignee> filterAsigneeDropDown = [];
  List<Asignee> copyAssigneeList = [];
  List<String> filter = [
    'to-do type',
    'Job Application',
    'Education',
    'Employment',
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
  bool reminderDateIsNotEmpty = false;
  DateTime? _dateTimeStart;
  DateTime _showDate = DateTime.now();
  DateTime? _dateTimeStartEve;
  DateTime _showDateEve = DateTime.now();
  DateTime? _dateTimeStartRem;
  DateTime _showDateRem = DateTime.now();
  TextEditingController actionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FocusNode? actionFocus;
  late String _time, _timeEve, _timeRem;
  TextEditingController _timeController = TextEditingController();
  TimeOfDay showselectedTime = TimeOfDay(hour: 23, minute: 59);
  TimeOfDay? selectedTime;
  TimeOfDay? selectedEveTime;
  TimeOfDay showSelectedEveTime = TimeOfDay.now();
  TimeOfDay showselectedRemTime = TimeOfDay.now();
  TimeOfDay? selectedRemTime;

  TextEditingController fileTitleController = TextEditingController();
  TextEditingController fileurlController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();
  ScrollController scrollController = ScrollController();

  var name;
  var profilePicture;
  bool isSelfSelectedFlag = false;
  bool isSendToProgramSelectedFlag = false;
  String? sfuuid;
  String? role;
  bool createdForSelf = false;

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

  Future<Null> _selectTimeRem(
    BuildContext context,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: showselectedRemTime,
    );
    if (picked != null)
      setState(() {
        selectedRemTime = picked;
        showselectedRemTime = picked;
        _timeRem =
            "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, showselectedRemTime.hour, showselectedRemTime.minute))}";
        _timeController.text = _timeRem;
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
    _getContacts();

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

    name = context.read<PendoMetaDataBloc>().state.name;
    widget.todoItem.task.asignee.forEach((todoItemAsignee) {
      selectedAsignee.add(todoItemAsignee.id);

      filterAsigneeDropDown.forEach((element) {
        if (element.ward.id == todoItemAsignee.id) {
          element.isSelected = true;
        }
      });

      selectedAsigneeCircularList.add(
        Asignee(
          ward: Ward(
            id: todoItemAsignee.id,
            name: todoItemAsignee.asigneeName,
            profilePicture: todoItemAsignee.profilePicture,
          ),
        ),
      );
    });

    final ids =
        widget.todoItem.task.asignee.map((asignee) => asignee.id).toList();
    isSelfSelectedFlag = ids.contains(widget.selfSfid);

    _getSfidAndRole();
    _setValues();
    super.initState();
    copyAssigneeList = filterAsigneeDropDown;
  }

  _getContacts() async {
    final state = context.read<GetContactsBloc>().state;

    if (state is GetContactsSuccessState) {
      contacts = state.contactsResponse.contacts
          .where((element) => element.canCreateTodo)
          .toList();
    }
    contacts.forEach((element) {
      filterAsigneeDropDown.add(Asignee(
          ward: Ward(
              id: element.sfid,
              name: element.name,
              profilePicture: element.profilePicture)));
    });
  copyAssigneeList = filterAsigneeDropDown;
    ///
  }

  _setValues() {
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
        ? TimeOfDay(hour: 23, minute: 59)
        : TimeOfDay(
            hour: widget.todoItem.task.completeBy.toLocal().hour,
            minute: widget.todoItem.task.completeBy.toLocal().minute);
    _time =
        "${DateFormat.jm().format(widget.todoItem.task.completeBy.toLocal())}";
    // Set reminderAt
    _dateTimeStartRem = widget.todoItem.task.reminderAt.toLocal();
    selectedRemTime = widget.todoItem.task.reminderAt.year == 9998
        ? null
        : TimeOfDay(
            hour: widget.todoItem.task.reminderAt.toLocal().hour,
            minute: widget.todoItem.task.reminderAt.toLocal().minute);
    showselectedRemTime = widget.todoItem.task.reminderAt.year == 9998
        ? TimeOfDay.now()
        : TimeOfDay(
            hour: widget.todoItem.task.reminderAt.toLocal().hour,
            minute: widget.todoItem.task.reminderAt.toLocal().minute);
    _timeRem =
        "${DateFormat.jm().format(widget.todoItem.task.reminderAt.toLocal())}";
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfuuid = prefs.getString(saleforceUUIDConstant);
    role = prefs.getString('role').toString();
    name = prefs.getString(fullNameConstant);
    print(name);
    profilePicture = prefs.getString(profilePictureConstant);
  }

  TextEditingController searchController = TextEditingController();
  List<ContactsData> contacts = [];

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;

    return BlocBuilder<GetContactsBloc, GetContactsState>(
        builder: (context, state) {
      return BlocListener<TodoParentAdvisorBloc, TodoParentState>(
        bloc: context.read<TodoParentAdvisorBloc>(),
        listener: (context, state) {
          if (updateState && state is FetchTodoParentSuccessState) {
            Navigator.pop(context);
            Navigator.pop(context);
            context.read<TodoParentAdvisorBloc>().add(FetchTodosParentEvent());
          } else if (state is UpdateTodoParentErrorState) {
            Navigator.pop(context);
            Navigator.pop(context);
            final bloc = context.read<TodoParentAdvisorBloc>();
            bloc.add(
              FetchTodosParentEvent(),
            );
            //
          }
        },
        child: BlocBuilder<TodoParentAdvisorBloc, TodoParentState>(
            builder: (context, state) {
          if (state is UpdateTodoParentLoadingState) updateState = true;
          if (state is UpdateTodoParentLoadingState ||
              state is FetchTodoParentLoadingState)
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          _assigneeButton(),
                          Container(
                            height: 50,
                            width: MediaQuery.of(context).size.width * .4,
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: errorDropdown
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
                                child: Text(
                              filterDropDownValue,
                              style: montserratNormal.copyWith(
                                fontSize: 12,
                                color: errorDropdown
                                    ? todoListActiveTab
                                    : defaultDark,
                              ),
                            )),
                          ),
                          // Builder(builder: (context) {
                          //   print('filter: $filter');
                          //   return TodoTypeDropDownMenu(
                          //     errorDropdown: errorDropdown,
                          //     onChanged: (newValue) {
                          //       setState(() {
                          //         filterDropDownValue = newValue != null
                          //             ? newValue
                          //             : 'to-do type';
                          //         if (!filterDropDownValue
                          //             .startsWith('Event')) {
                          //           errorEvent = false;
                          //           errorVenue = false;
                          //         }
                          //       });
                          //     },
                          //     selectedValue: 'to-do type',
                          //     items: filter,
                          //     enabled: false,
                          //   );
                          // }),
                        ],
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
                      Column(
                        children: [
                          DateTimeHeading(
                            title: 'Set due date',
                            icon: 'images/date_picker.svg',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildDatePicker(context, false),
                              dueDateIsNotEmpty == false && _time == '' ||
                                      widget.todoItem.task.completeBy.year ==
                                              9998 &&
                                          _dateTimeStart!.year == 9998
                                  ? Container()
                                  : buildTimePicker(context, false),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          DateTimeHeading(
                            title: 'Set reminder',
                            icon: 'images/notification_bell_icon.svg',
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              buildRemDatePicker(context),
                              _dateTimeStartRem == null ||
                                      widget.todoItem.task.reminderAt.year ==
                                              9998 &&
                                          _dateTimeStartRem!.year == 9998
                                  ? Container()
                                  : buildRemTimePicker(context),
                            ],
                          ),
                        ],
                      ),
                      if (filterDropDownValue.startsWith('Event'))
                        const SizedBox(
                          height: 20,
                        ),
                      if (filterDropDownValue.startsWith('Event'))
                        Column(
                          children: [
                            DateTimeHeading(
                              title: 'Set event date',
                              icon: 'images/date_picker.svg',
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                buildDatePicker(context, true),
                                dueDateEventIsNotEmpty == false &&
                                        _timeEve == ''
                                    ? Container()
                                    : buildTimePicker(context, true),
                              ],
                            ),
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
                  if (fileResources.isEmpty)
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: UploadResourcesArea(
                          onUploadTap: () {
                            _showBottomSheetForUpload();
                            TodoPendoRepo.trackTapOnUploadResourcesEvent(
                                pendoState: pendoState);
                          },
                          isAttachmentUploading: _isAttachmentUploading),
                    );
                  else {
                    return Container(height: 0, width: 0);
                  }
                }),
                SizedBox(height: 10),
                if (fileResources.isNotEmpty && fileResources.length > 0)
                  Container(
                    padding: const EdgeInsets.fromLTRB(40, 10, 0, 10),
                    width: device.width * 0.8,
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
                            scrollDirection: Axis.horizontal,
                            itemCount: fileResources.length,
                            shrinkWrap: true,
                            itemBuilder: (ctx, ind) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: Stack(children: [
                                  FileResourceCardButton(
                                    gid: widget.todoItem.task.gid,
                                    file: fileResources[ind],
                                    isForm: true,
                                    isForUpdate: false,
                                    sfid: widget.selfSfid,
                                    role: role,
                                    sfuuid: sfuuid,
                                    todotitle: widget.todoItem.task.name ?? '',
                                  ),
                                  BlocBuilder<PendoMetaDataBloc,
                                          PendoMetaDataState>(
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
                                                    link:
                                                        fileResources[ind].url);
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
                                    );
                                  }),
                                ]),
                              );
                            }),
                      ],
                    ),
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
                                        final reference =
                                            FirebaseStorage.instance.ref(
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

                                    BlocProvider.of<TodoParentAdvisorBloc>(
                                            context)
                                        .add(
                                      UpdateTodoParentEvent(
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
                                          status:
                                              widget.todoItem.task.taskStatus,
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
                                          reminderAt: _dateTimeStartRem ==
                                                      null ||
                                                  _dateTimeStartRem!.year ==
                                                      9998
                                              ? ''
                                              : DateTime(
                                                      _dateTimeStartRem!.year,
                                                      _dateTimeStartRem!.month,
                                                      _dateTimeStartRem!.day,
                                                      showselectedRemTime.hour,
                                                      showselectedRemTime
                                                          .minute)
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
                                    widget.todoItem.task.reminderAt = DateTime(
                                        _dateTimeStartRem?.year ??
                                            _showDateRem.year,
                                        _dateTimeStartRem?.month ??
                                            _showDateRem.month,
                                        _dateTimeStartRem?.day ??
                                            _showDateRem.day,
                                        showselectedRemTime.hour,
                                        showselectedRemTime.minute);
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
                                    BlocProvider.of<TodoParentAdvisorBloc>(
                                            context)
                                        .add(
                                      UpdateTodoParentEvent(
                                        todoModel: TodoModel(
                                          name: actionController.text,
                                          description:
                                              descriptionController.text.isEmpty
                                                  ? ' '
                                                  : descriptionController.text,
                                          status:
                                              widget.todoItem.task.taskStatus,
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
                                          reminderAt: _dateTimeStartRem ==
                                                      null ||
                                                  _dateTimeStartRem!.year ==
                                                      9998
                                              ? ''
                                              : DateTime(
                                                      _dateTimeStartRem!.year,
                                                      _dateTimeStartRem!.month,
                                                      _dateTimeStartRem!.day,
                                                      showselectedRemTime.hour,
                                                      showselectedRemTime
                                                          .minute)
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
                                    widget.todoItem.task.reminderAt = DateTime(
                                        _dateTimeStartRem?.year ??
                                            _showDateRem.year,
                                        _dateTimeStartRem?.month ??
                                            _showDateRem.month,
                                        _dateTimeStartRem?.day ??
                                            _showDateRem.day,
                                        showselectedRemTime.hour,
                                        showselectedRemTime.minute);
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
                const SizedBox(
                  height: 40,
                ),
              ],
            );
        }),
      );
    });
  }

  Widget _assigneeButton() {
    return InkWell(
      onTap: () {
        _showAssigneeBottomSheet(context);
      },
      child: Container(
        color: Colors.transparent,
        width: MediaQuery.of(context).size.width * .35,
        child: Stack(children: [
          if (selectedAsigneeCircularList.isEmpty)
            Container(
              height: 50,
              padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color:
                        errorAsignee ? todoListActiveTab : Colors.transparent,
                    width: 2.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 5,
                      offset: Offset(0, 1),
                    ),
                  ]),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      width: 30,
                    ),
                    Text(
                      "Assignees",
                      overflow: TextOverflow.ellipsis,
                      style: montserratNormal.copyWith(
                        fontSize: 12,
                        color: errorAsignee ? todoListActiveTab : defaultDark,
                      ),
                    ),
                    // Icon(
                    //   Icons.arrow_drop_down,
                    //   color:
                    //       errorAsignee ? todoListActiveTab : defaultDark,
                    // ),
                  ],
                ),
              ),
            ),
          if (selectedAsigneeCircularList.length >= 3)
            Positioned(
                top: 5,
                left: 70,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ]),
                  child: CachedNetworkImage(
                    imageUrl:
                        selectedAsigneeCircularList[2].ward.profilePicture ??
                            '',
                    imageBuilder: (context, imageProvider) => Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircleAvatar(
                        radius:
                            // widget.screenHeight <= 736 ? 35 :
                            29,
                        backgroundColor: Colors.white,
                        child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                            Helper.getInitials(
                                selectedAsigneeCircularList[2].ward.name),
                            style: darkTextFieldStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: aquaBlue)),
                      ),
                    ),
                  ),
                )),
          if (selectedAsigneeCircularList.length > 3)
            Positioned(
                bottom: 5,
                left: 95,
                child: Container(
                    height: 15,
                    width: 15,
                    decoration: BoxDecoration(
                        color: pureblack,
                        borderRadius: BorderRadius.circular(50),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 5,
                            offset: Offset(0, 1),
                          ),
                        ]),
                    child: Center(
                        child: Text(
                      (selectedAsigneeCircularList.length - 3).toString(),
                      style: TextStyle(color: white, fontSize: 10),
                    )))),
          if (selectedAsigneeCircularList.length >= 2)
            Positioned(
                top: 5,
                left: 55,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ]),
                  child: CachedNetworkImage(
                    imageUrl:
                        selectedAsigneeCircularList[1].ward.profilePicture ??
                            '',
                    imageBuilder: (context, imageProvider) => Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircleAvatar(
                        radius:
                            // widget.screenHeight <= 736 ? 35 :
                            29,
                        backgroundColor: Colors.white,
                        child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                            Helper.getInitials(
                                selectedAsigneeCircularList[1].ward.name),
                            style: darkTextFieldStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: aquaBlue)),
                      ),
                    ),
                  ),
                )),
          if (selectedAsigneeCircularList.length >= 1)
            Positioned(
                top: 5,
                left: 30,
                child: Container(
                  height: 40,
                  width: 40,
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.15),
                          blurRadius: 5,
                          offset: Offset(0, 1),
                        ),
                      ]),
                  child: CachedNetworkImage(
                    imageUrl:
                        selectedAsigneeCircularList[0].ward.profilePicture ??
                            '',
                    imageBuilder: (context, imageProvider) => Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircleAvatar(
                        radius:
                            // widget.screenHeight <= 736 ? 35 :
                            29,
                        backgroundColor: Colors.white,
                        child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) => Container(
                      height: 40,
                      width: 40,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                            Helper.getInitials(
                                selectedAsigneeCircularList[0].ward.name),
                            style: darkTextFieldStyle.copyWith(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: aquaBlue)),
                      ),
                    ),
                  ),
                )),
          Positioned(
              // top: 5,
              child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                  color: errorAsignee ? todoListActiveTab : Colors.transparent,
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
              child: SvgPicture.asset(
                "images/todo_add_assignee.svg",
                height: 16,
                width: 16,
              ),
            ),
          )),
        ]),
      ),
    );
  }

  void _showAssigneeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          filterAsigneeDropDown = copyAssigneeList;
          return StatefulBuilder(builder: (context, mysetState) {
            return DraggableScrollableSheet(
                initialChildSize: 0.8,
                maxChildSize: 0.95, // full screen on scroll
                minChildSize: 0.5,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Stack(children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          SizedBox(
                            height: 5,
                            width: 50,
                            child: Container(
                              padding: EdgeInsets.only(
                                  left: 150, right: 150, top: 5),
                              color: defaultDark,
                              height: 5,
                              width: 50,
                            ),
                          ),
                          SizedBox(height: 15),
                          SelfAssignButton(
                              name: name,
                              profilePicture: profilePicture,
                              isSelected: isSelfSelectedFlag,
                              onTap: () {
                                isSelfSelectedFlag = !isSelfSelectedFlag;
                                if (isSelfSelectedFlag) {
                                  selectedAsignee.add(widget.selfSfid);
                                  selectedAsigneeCircularList.add(Asignee(
                                      ward: Ward(
                                          id: widget.selfSfid,
                                          name: name,
                                          profilePicture: profilePicture)));
                                } else {
                                  selectedAsignee.remove(widget.selfSfid);
                                  selectedAsigneeCircularList.removeWhere(
                                      (element) =>
                                          element.ward.id == widget.selfSfid);
                                }
                                isSendToProgramSelectedFlag = false;
                                mysetState(() {});
                              }),
                          SizedBox(height: 15),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: SearchBarForRecipients(
                                  searchController: searchController,
                                  onChanged: (String text) {
                                    if (text.trim().isNotEmpty) {
                                      filterAsigneeDropDown = copyAssigneeList
                                          .where((element) => element.ward.name
                                              .toLowerCase()
                                              .contains(text.toLowerCase()))
                                          .toList();
                                    }
                                    if (text.trim().isEmpty) {
                                      filterAsigneeDropDown = copyAssigneeList;
                                    }
                                    mysetState(() {});
                                  })),

                          // Row(
                          //   children: [
                          //     InstituteItemButton(isSelected: false),
                          //     InstituteItemButton(isSelected: false),
                          //   ],
                          // ),

                          SizedBox(height: 15),
                          SuggestEntireProgramButton(
                              isSelected: isSendToProgramSelectedFlag,
                              onTap: () {
                                isSendToProgramSelectedFlag =
                                    !isSendToProgramSelectedFlag;
                                selectedAsignee = [];
                                selectedAsigneeCircularList = [];
                                filterAsigneeDropDown.forEach((element) {
                                  element.isSelected = false;
                                });
                                isSelfSelectedFlag = false;
                                mysetState(() {});
                              }),
                          SizedBox(
                            height: 30,
                          ),
                          TextScaleFactorClamper(
                            child: Expanded(
                              child: ListView.builder(
                                controller: scrollController,
                                itemCount: filterAsigneeDropDown.length,
                                itemBuilder: (ctx, ind) {
                                  return MultiSelectItem(
                                    image: filterAsigneeDropDown[ind]
                                        .ward
                                        .profilePicture,
                                    name: filterAsigneeDropDown[ind].ward.name,
                                    select:
                                        filterAsigneeDropDown[ind].isSelected,
                                    isSelected: (bool value) {
                                      if (isSendToProgramSelectedFlag) {
                                        isSendToProgramSelectedFlag = false;
                                      }
                                      filterAsigneeDropDown[ind].isSelected =
                                          value;
                                      if (value) {
                                        int i = selectedAsignee.indexWhere(
                                            (element) =>
                                                element ==
                                                filterAsigneeDropDown[ind]
                                                    .ward
                                                    .id);
                                        filterAsigneeDropDown[ind].isSelected =
                                            true;
                                        if (i < 0) {
                                          selectedAsignee.add(
                                            filterAsigneeDropDown[ind].ward.id,
                                          );
                                          selectedAsigneeCircularList
                                              .add(filterAsigneeDropDown[ind]);
                                        }
                                      } else {
                                        selectedAsignee.remove(
                                          filterAsigneeDropDown[ind].ward.id,
                                        );
                                        filterAsigneeDropDown[ind].isSelected =
                                            false;
                                        selectedAsigneeCircularList
                                            .remove(filterAsigneeDropDown[ind]);
                                      }
                                      mysetState(() {});
                                    },
                                  );
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        bottom: 20,
                        right: 20,
                        child: Container(
                          color: Colors.transparent,
                          padding: const EdgeInsets.only(
                              bottom: 20, left: 15, right: 30),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // TextButton(
                              //   onPressed: () {
                              //     if (!isSelectAll) {
                              //       isSelectAll = true;
                              //       selectedAsignee = [];
                              //       filterAsigneeDropDown
                              //           .forEach((element) {
                              //         element.isSelected = true;
                              //         selectedAsignee.add(element.ward.id);
                              //       });
                              //     } else {
                              //       isSelectAll = false;
                              //       selectedAsignee = [];
                              //       filterAsigneeDropDown
                              //           .forEach((element) {
                              //         element.isSelected = false;
                              //       });
                              //     }
                              //     final bloc = BlocProvider.of<
                              //         CreateTodoLocalSaveBloc>(context);
                              //     bloc.add(AssigneeDropDownChanged(
                              //         assigneeDropDown:
                              //         filterAsigneeDropDown));
                              //     bloc.add(SelectedAssigneesChanged(
                              //         selectedAssignees: selectedAsignee));
                              //     mysetState(() {});
                              //   },
                              //   child: Text(
                              //     !isSelectAll
                              //         ? "Select all"
                              //         : selectedAsignee.length == 0
                              //         ? "Select all"
                              //         : "Unselect all",
                              //     style: roboto700.copyWith(
                              //         fontSize: 17, color: aquaBlue),
                              //   ),
                              // ),
                              InkWell(
                                onTap: () {
                                  Navigator.pop(context);
                                },
                                child: Container(
                                  height: 38,
                                  width: 38,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: pinkRed,
                                  ),
                                  child: SvgPicture.asset(
                                    "images/sendIcon.svg",
                                    height: 14,
                                    width: 14,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ]),
                  );
                });
          });
        }).whenComplete(() {
      
      searchController.text = '';
      print(selectedAsignee);
      setState(() {});
    });
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

  buildRemTimePicker(BuildContext context) {
    return InkWell(
      onTap: () {
        _selectTimeRem(context);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        //height: 50,
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Colors.transparent,
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
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    selectedRemTime == null ? 'Time' : '$_timeRem',
                    style: montserratNormal.copyWith(
                      fontSize: 12,
                      color: defaultDark,
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
                if (isEvent)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      selectedEveTime == null
                          ? 'Time'
                          : _timeEve == ''
                              ? 'Time'
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
                      selectedTime == null ? 'Time' : '$_time',
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

  buildRemDatePicker(BuildContext context) {
    return InkWell(
      onTap: () {
        showDatePicker(
                context: context,
                initialDate: widget.todoItem.task.reminderAt.year == 9998
                    ? _showDateRem
                    : _dateTimeStartRem ?? _showDateRem,
                firstDate: DateTime(2021),
                lastDate: DateTime(DateTime.now().year + 2),
                cancelText: 'CLEAR')
            .then((date) {
          setState(() {
            if (date != null) {
              reminderDateIsNotEmpty = true;
            } else
              reminderDateIsNotEmpty = false;
            _dateTimeStartRem = date;
            _showDateRem = date != null ? date : _showDateRem;
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
              color: Colors.transparent,
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
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    _dateTimeStartRem == null
                        ? 'Date'
                        : _dateTimeStartRem!.year == 9998 &&
                                widget.todoItem.task.reminderAt.year == 9998
                            ? 'Date'
                            : '${(_dateTimeStartRem?.month)}-${_dateTimeStartRem?.day}-${_dateTimeStartRem?.year}',
                    style: montserratNormal.copyWith(
                        fontSize: 12, color: defaultDark),
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
    fileTitleController.text = linkResources[ind].name;
    fileurlController.text = linkResources[ind].url;

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
                              if (linkResources[ind].id != null) {
                                deletedResources.add(linkResources[ind].id!);
                              } else {
                                addedResources.remove(linkResources[ind]);
                              }

                              final id = linkResources[ind].id;
                              print(id);

                              if (linkResources != [] &&
                                  linkResources.length > ind) {
                                TodoPendoRepo.trackTapOnDeleteLinkEvent(
                                    pendoState: pendoState,
                                    link: linkResources[ind].url);

                                linkResources.removeAt(ind);
                              }

                              setState(() {});

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
    fileTitleController.text = linkResources[ind].name;
    fileurlController.text = linkResources[ind].url;

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
                                        .add(linkResources[ind].id ?? '');
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
