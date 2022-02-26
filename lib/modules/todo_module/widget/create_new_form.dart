import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/institute_logo.dart';
import 'package:palette/common_components/searchbar_recipients.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/todo_module/bloc/create_todo_local_save_bloc/create_todo_local_save_bloc.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_event.dart';
import 'package:palette/modules/todo_module/bloc/todo_state.dart';
import 'package:palette/modules/todo_module/models/asignee.dart';
import 'package:palette/modules/todo_module/models/createtodo_response_model.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';
import 'package:palette/modules/todo_module/models/ward.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/common_todo_popup.dart';
import 'package:palette/modules/todo_module/widget/event_venue_box_container.dart';
import 'package:palette/modules/todo_module/widget/listview_for_upload_todo.dart';
import 'package:palette/modules/todo_module/widget/self_assign_todo_button.dart';
import 'package:palette/modules/todo_module/widget/suggest_program_todo_button.dart';
import 'package:palette/modules/todo_module/widget/textFormfieldForTodo.dart';
import 'package:palette/modules/todo_module/widget/todo_type_dropdown.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import 'multiSelectListItem.dart';

class CreateNewTodoForm extends StatefulWidget {
  final TabController controller;
  final String studentId;
  CreateNewTodoForm(
      {Key? key, required this.studentId, required this.controller})
      : super(key: key);

  @override
  _CreateNewTodoFormState createState() => _CreateNewTodoFormState();
}

ResponseDataAfterCreateTodo? response;

class _CreateNewTodoFormState extends State<CreateNewTodoForm> {
  String filterDropDownValue = 'to-do type';
  List<Resources> fileResources = [];
  List<Resources> linkResources = [];
  List<FileLoaderForBloc> filesLoaderForBloc = [];
  bool updateState = false;
  bool hasCreatedTodo = false;
  bool errorAction = false;
  bool errorDescription = false;
  bool errorVenue = false;
  bool errorDue = false;
  bool errorEvent = false;
  bool errorDropdown = false;
  bool eventTimeIsNotEmpty = false;
  bool errorAsignee = false;
  bool dueDateIsNotEmpty = false;
  bool reminderDateIsNotEmpty = false;
  bool dueDateEventIsNotEmpty = false;
  String actionTxt = "";
  String descriptionTxt = "";
  DateTime? _dateTimeStart;
  DateTime? _dateTimeStartEve;
  DateTime? _dateTimeStartRem;

  TextEditingController actionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FocusNode? actionFocus;
  TextEditingController _timeController = TextEditingController();

  TextEditingController fileTitleController = TextEditingController();
  TextEditingController fileurlController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();
  late String _time, _timeEve, _timeRem;

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

  String? sfid;
  String? sfuuid;
  String? role;

  bool isCreateTodoClicked = false;
  var keyboardVisibilityController = KeyboardVisibilityController();
  bool _isKeyboardVisible = false;
  TextEditingController searchController = TextEditingController();
  List<String> selectedAsignee = [];
  List<Asignee> filterAsigneeDropDownSelected = [];
  List<Asignee> assigneeContactList = [];
  bool isSelfSelectedFlag = false;
  bool isSendToProgramSelectedFlag = false;
  String filterasigneeValue = 'Assignee';

  var name;
  var profilePicture;
  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
    sfuuid = prefs.getString(saleforceUUIDConstant);
    role = prefs.getString('role').toString();
    name = prefs.getString(fullNameConstant);
    print(name);
    profilePicture = prefs.getString(profilePictureConstant);
  }

  @override
  void initState() {
    super.initState();
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('ketyert $visible');

      setState(() {
        _isKeyboardVisible = visible;
      });
    });
    _getSfidAndRole();
  }

  Future<Null> _selectTime(
      BuildContext context, CreateTodoLocalSaveState todoLocalSaveState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: todoLocalSaveState.dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        _time =
            "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, picked.hour, picked.minute))}";
        _timeController.text = _time;
        _timeController.text = picked.toString();
      });
      final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
      bloc.add(DueTimeChanged(dueTime: picked));
    }
  }

  Future<Null> _selectTimeRem(
      BuildContext context, CreateTodoLocalSaveState todoLocalSaveState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: todoLocalSaveState.remainderTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      print(picked);
      setState(() {
        _timeRem =
            "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, picked.hour, picked.minute))}";
        _timeController.text = _timeRem;
        _timeController.text = picked.toString();
      });
      final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
      bloc.add(RemainderTimeChanged(remainderTime: picked));
    }
  }

  Future<Null> _selectTimeEvent(
      BuildContext context, CreateTodoLocalSaveState todoLocalSaveState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: todoLocalSaveState.eventTime ??
          TimeOfDay.fromDateTime(DateTime.now()),
    );
    print(picked);
    if (picked != null) {
      setState(() {
        eventTimeIsNotEmpty = true;
        _timeEve = "${DateFormat.jm().format(DateTime(
          DateTime.now().year,
          DateTime.now().month,
          DateTime.now().day,
          picked.hour,
          picked.minute,
        ))}";
        _timeController.text = _timeEve;
        _timeController.text = picked.toString();
      });
      final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
      bloc.add(EventTimeChanged(eventTime: picked));
    }
    print(eventTimeIsNotEmpty);
  }

  List<ContactsData> contacts = [];

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return BlocBuilder<GetContactsBloc, GetContactsState>(
      builder: (context, state) {
        if (state is GetContactsSuccessState) {
          contacts = state.contactsResponse.contacts
              .where((element) => element.canCreateTodo)
              .toList();
          List<Asignee> tempContact = []..addAll(assigneeContactList);
          assigneeContactList = [];
          contacts.forEach((element) {
            assigneeContactList.add(Asignee(
                ward: Ward(
                    id: element.sfid,
                    name: element.name,
                    profilePicture: element.profilePicture)));
          });
          tempContact.forEach((tempElement) {
            int index = assigneeContactList.indexWhere(
                (element) => element.ward.id == tempElement.ward.id);
            if (index >= 0) {
              assigneeContactList[index].isSelected = tempElement.isSelected;
            }
          });
        }

        return BlocBuilder<CreateTodoLocalSaveBloc, CreateTodoLocalSaveState>(
            builder: (context, todoLocalSaveState) {
          _loadLocalState(todoLocalSaveState);
          return BlocListener<TodoCrudBloc, TodoCrudState>(
            listener: (context, state) {
              if (state is CreateTodoResourceSuccessState) {
                context
                    .read<TodoListBloc>()
                    .add(TodoListEvent(studentId: widget.studentId));
                widget.controller.animateTo((widget.controller.index + 2) % 3);
              } else if (state is SaveTodoResourceSuccessState) {
                context
                    .read<TodoListBloc>()
                    .add(TodoListEvent(studentId: widget.studentId));
                widget.controller.animateTo((widget.controller.index + 1) % 3);
              }
            },
            bloc: context.read<TodoCrudBloc>(),
            child: BlocBuilder<TodoCrudBloc, TodoCrudState>(
                builder: (context, state) {
              if (state is CreateTodoLoadingState) updateState = true;
              if (updateState && state is CreateTodoResourceSuccessState) {}
              return Semantics(
                label:
                    "Create todo form. please fill all mandatory information and tap on create button to create a new todo",
                child: GestureDetector(
                  onTap: () {
                    FocusScopeNode currentFocus = FocusScope.of(context);
                    BlocProvider.of<HideNavbarBloc>(context)
                        .add(ShowBottomNavbarEvent());
                    if (!currentFocus.hasPrimaryFocus) {
                      currentFocus.unfocus();
                    }
                  },
                  child: ListView(
                    children: [
                      Padding(
                        padding: EdgeInsets.fromLTRB(40, 30, 40, 10),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    _showAssigneeBottomSheet(context);
                                  },
                                  child: Container(
                                    color: Colors.transparent,
                                    width:
                                        MediaQuery.of(context).size.width * .35,
                                    child: Stack(children: [
                                      if (filterAsigneeDropDownSelected
                                              .isEmpty &&
                                          isSendToProgramSelectedFlag == false)
                                        Container(
                                          height: 50,
                                          padding: EdgeInsets.fromLTRB(
                                              20, 10, 10, 0),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(24),
                                              border: Border.all(
                                                color: errorAsignee
                                                    ? todoListActiveTab
                                                    : Colors.transparent,
                                                width: 2.0,
                                              ),
                                              boxShadow: [
                                                BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.15),
                                                  blurRadius: 5,
                                                  offset: Offset(0, 1),
                                                ),
                                              ]),
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 10),
                                            child: Row(
                                              children: [
                                                SizedBox(
                                                  width: 30,
                                                ),
                                                Text(
                                                  "Assignees",
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style:
                                                      montserratNormal.copyWith(
                                                    fontSize: 12,
                                                    color: errorAsignee
                                                        ? todoListActiveTab
                                                        : defaultDark,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      if (isSendToProgramSelectedFlag)
                                        Positioned(
                                            top: 5,
                                            left: 30,
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      blurRadius: 5,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ]),
                                              child: CachedNetworkImage(
                                                imageUrl: '',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                        radius: 29,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                      child: InstituteLogo(
                                                          radius: 30)),
                                                ),
                                              ),
                                            )),
                                      if (filterAsigneeDropDownSelected
                                              .length >=
                                          3)
                                        Positioned(
                                            top: 5,
                                            left: 70,
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      blurRadius: 5,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ]),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    filterAsigneeDropDownSelected[
                                                                2]
                                                            .ward
                                                            .profilePicture ??
                                                        '',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                        radius: 29,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        Helper.getInitials(
                                                            filterAsigneeDropDownSelected[
                                                                    2]
                                                                .ward
                                                                .name),
                                                        style: darkTextFieldStyle
                                                            .copyWith(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    aquaBlue)),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      if (filterAsigneeDropDownSelected.length >
                                          3)
                                        Positioned(
                                            bottom: 5,
                                            left: 95,
                                            child: Container(
                                                height: 15,
                                                width: 15,
                                                decoration: BoxDecoration(
                                                    color: pureblack,
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: Colors.black
                                                            .withOpacity(0.15),
                                                        blurRadius: 5,
                                                        offset: Offset(0, 1),
                                                      ),
                                                    ]),
                                                child: Center(
                                                    child: Text(
                                                  (filterAsigneeDropDownSelected
                                                              .length -
                                                          3)
                                                      .toString(),
                                                  style: TextStyle(
                                                      color: white,
                                                      fontSize: 10),
                                                )))),
                                      if (filterAsigneeDropDownSelected
                                              .length >=
                                          2)
                                        Positioned(
                                            top: 5,
                                            left: 55,
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      blurRadius: 5,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ]),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    filterAsigneeDropDownSelected[
                                                                1]
                                                            .ward
                                                            .profilePicture ??
                                                        '',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                        radius: 29,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        Helper.getInitials(
                                                            filterAsigneeDropDownSelected[
                                                                    1]
                                                                .ward
                                                                .name),
                                                        style: darkTextFieldStyle
                                                            .copyWith(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    aquaBlue)),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      if (filterAsigneeDropDownSelected
                                              .length >=
                                          1)
                                        Positioned(
                                            top: 5,
                                            left: 30,
                                            child: Container(
                                              height: 40,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  color: Colors.transparent,
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.black
                                                          .withOpacity(0.15),
                                                      blurRadius: 5,
                                                      offset: Offset(0, 1),
                                                    ),
                                                  ]),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    filterAsigneeDropDownSelected[
                                                                0]
                                                            .ward
                                                            .profilePicture ??
                                                        '',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.transparent,
                                                    shape: BoxShape.circle,
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    CircleAvatar(
                                                        radius: 29,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child:
                                                            CircularProgressIndicator()),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        Container(
                                                  height: 40,
                                                  width: 40,
                                                  decoration: BoxDecoration(
                                                    color: Colors.white,
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                        Helper.getInitials(
                                                            filterAsigneeDropDownSelected[
                                                                    0]
                                                                .ward
                                                                .name),
                                                        style: darkTextFieldStyle
                                                            .copyWith(
                                                                fontSize: 16,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w700,
                                                                color:
                                                                    aquaBlue)),
                                                  ),
                                                ),
                                              ),
                                            )),
                                      Positioned(
                                          child: Container(
                                        height: 50,
                                        width: 50,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                              color: errorAsignee
                                                  ? todoListActiveTab
                                                  : Colors.transparent,
                                              width: 2.0,
                                            ),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.15),
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
                                ),
                                TodoTypeDropDownMenu(
                                  errorDropdown: errorDropdown,
                                  onChanged: (String? newValue) {
                                    final bloc =
                                        context.read<CreateTodoLocalSaveBloc>();
                                    bloc.add(TodoTypeChanged(
                                        todoType: newValue != null
                                            ? newValue
                                            : 'to-do type'));
                                    setState(() {
                                      final filterDropDownValue =
                                          newValue != null
                                              ? newValue
                                              : 'to-do type';
                                      if (!filterDropDownValue
                                          .startsWith('Event')) {
                                        errorEvent = false;
                                        errorVenue = false;
                                      }
                                    });
                                  },
                                  selectedValue: todoLocalSaveState.todoType,
                                  items: filter,
                                  enabled: true,
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            CommonTextFieldTodo(
                              height: 50,
                              hintText: errorAction
                                  ? 'Please enter Action Text'
                                  : 'Enter Action Text',
                              inputController: actionController,
                              onChanged: (value) {
                                final bloc =
                                    context.read<CreateTodoLocalSaveBloc>();
                                bloc.add(ActionTextChanged(actionText: value));
                              },
                              isCreateForm: true,
                              errorFlag: errorAction,
                              isForAction: true,
                              initialValue: todoLocalSaveState.actionText,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (todoLocalSaveState.todoType.startsWith('Event'))
                              EventVenueTextBox(
                                  controller: eventVenueController,
                                  errorFlag: errorVenue,
                                  initialValue: todoLocalSaveState.venue ?? '',
                                  isCreateForm: true,
                                  onChanged: (value) {
                                    print('eventVenueController: $value');
                                    final bloc =
                                        context.read<CreateTodoLocalSaveBloc>();
                                    bloc.add(VenueChanged(venue: value));
                                  }),
                            if (todoLocalSaveState.todoType.startsWith('Event'))
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildDatePicker(
                                        context, false, todoLocalSaveState),
                                    !dueDateIsNotEmpty
                                        ? Container()
                                        : buildTimePicker(
                                            context, false, todoLocalSaveState),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Column(
                              children: [
                                DateTimeHeading(
                                  title: 'Set reminder',
                                  icon: 'images/notification_bell_icon.svg',
                                ),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    buildReminderDatePicker(
                                        context, todoLocalSaveState),
                                    !reminderDateIsNotEmpty
                                        ? Container()
                                        : buildReminderTimePicker(
                                            context, todoLocalSaveState),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            if (todoLocalSaveState.todoType.startsWith('Event'))
                              Column(
                                children: [
                                  DateTimeHeading(
                                    title: 'Set event date',
                                    icon: 'images/date_picker.svg',
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      buildDatePicker(
                                          context, true, todoLocalSaveState),
                                      !dueDateEventIsNotEmpty
                                          ? Container()
                                          : buildTimePicker(context, true,
                                              todoLocalSaveState),
                                    ],
                                  ),
                                ],
                              ),
                            if (todoLocalSaveState.todoType.startsWith('Event'))
                              const SizedBox(
                                height: 20,
                              ),
                            CommonTextFieldTodo(
                              height: 150,
                              hintText: errorDescription
                                  ? 'Please enter Description'
                                  : 'Enter Description',
                              inputController: descriptionController,
                              isCreateForm: true,
                              errorFlag: errorDescription,
                              onChanged: (value) {
                                final bloc =
                                    context.read<CreateTodoLocalSaveBloc>();
                                bloc.add(DescriptionTextChanged(
                                    descriptionText: value));
                              },
                              initialValue:
                                  todoLocalSaveState.descriptionText ?? '',
                            ),
                          ],
                        ),
                      ),
                      BlocListener(
                        bloc: BlocProvider.of<TodoCrudBloc>(context),
                        listener: (context, state) {
                          if (state is CreateTodoSuccessState) {
                            response = state.response;
                          } else if (state is SaveTodoSuccessState) {
                            response = state.response;
                          }
                        },
                        child:
                            BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                                builder: (context, pendoState) {
                          return Center(
                            child: BlocBuilder<TodoCrudBloc, TodoCrudState>(
                                builder: (context, state) {
                              return Column(
                                children: [
                                  Container(
                                    child: BlocListener(
                                        listener: (context, state) async {
                                          final bloc = context
                                              .read<CreateTodoLocalSaveBloc>();
                                          bloc.add(IsLoadingCreateTodo(
                                              isLoading: true));
                                          if (state is CreateTodoSuccessState ||
                                              state is SaveTodoSuccessState) {
                                            if (todoLocalSaveState
                                                        .fileResources !=
                                                    null &&
                                                fileResources.length > 0) {
                                              for (int i = 0;
                                                  i < fileResources.length;
                                                  i++) {
                                                var uploadfile =
                                                    filesLoaderForBloc[i];
                                                try {
                                                  final reference =
                                                      FirebaseStorage.instance.ref(
                                                          'Resources/${response!.gId}/${uploadfile.fileName}');
                                                  await reference
                                                      .putFile(uploadfile.file);
                                                  final uri = await reference
                                                      .getDownloadURL();
                                                  fileResources[i].url =
                                                      uri.toString();
                                                  bloc.add(FileResourcesChanged(
                                                      fileresources:
                                                          fileResources));
                                                } on FirebaseException catch (e) {
                                                  bloc.add(IsLoadingCreateTodo(
                                                      isLoading: false));
                                                  print("dd dd ${e.message}");
                                                }
                                              }
                                            }
                                            final List<Map> responseSend = [];
                                            List<Resources> resources = [];
                                            resources =
                                                linkResources + fileResources;
                                            resources.forEach((element) {
                                              responseSend
                                                  .add(element.toJson());
                                              TodoPendoRepo
                                                  .trackCreateTodoDoneEvent(
                                                      pendoState: pendoState,
                                                      todoIds: response!.ids);
                                            });

                                            TodoPendoRepo
                                                .trackTodoAddResourcesEvent(
                                                    resources: resources,
                                                    todoIds: response!.ids,
                                                    pendoState: pendoState);

                                            if (state
                                                is CreateTodoSuccessState) {
                                              BlocProvider.of<TodoCrudBloc>(
                                                      context)
                                                  .add(CreateTodoResourceEvent(
                                                      todoId: response!.ids,
                                                      resources: resources));
                                            } else if (state
                                                is SaveTodoSuccessState) {
                                              BlocProvider.of<TodoCrudBloc>(
                                                      context)
                                                  .add(SaveTodoResourceEvent(
                                                      todoId: response!.ids,
                                                      resources: resources));
                                            }

                                            bloc.add(IsLoadingCreateTodo(
                                                isLoading: false));
                                          } else if (state
                                                  is CreateTodoErrorState ||
                                              state is SaveTodoErrorState) {
                                            bloc.add(IsLoadingCreateTodo(
                                                isLoading: false));
                                          } else if (state
                                                  is CreateTodoResourceSuccessState ||
                                              state
                                                  is SaveTodoResourceSuccessState) {
                                            bloc.add(
                                                ClearCreateTodoLocalSaveEvent());
                                          }
                                        },
                                        bloc: context.read<TodoCrudBloc>(),
                                        child: Visibility(
                                          visible: true,
                                          child: ListViewUpload(
                                            actionController: actionController,
                                            device: device,
                                            fileResources: fileResources,
                                            linkResources: linkResources,
                                            fileTitleController:
                                                fileTitleController,
                                            fileurlController:
                                                fileurlController,
                                            todolocalSaveState:
                                                todoLocalSaveState,
                                            filesLoaderForBloc:
                                                filesLoaderForBloc,
                                            onTapDoneButton: state
                                                        is CreateTodoLoadingState ||
                                                    state
                                                        is CreateTodoResourcesLoadingState ||
                                                    state
                                                        is SaveTodoLoadingState ||
                                                    state
                                                        is SaveTodoResourcesLoadingState
                                                ? () {}
                                                : () async {
                                                    final bloc = context.read<
                                                        CreateTodoLocalSaveBloc>();
                                                    bloc.add(
                                                        IsLoadingCreateTodo(
                                                            isLoading: true));

                                                    await createButtonOnPressed(
                                                        todoLocalSaveState:
                                                            todoLocalSaveState,
                                                        isAddRescoucesClicked:
                                                            todoLocalSaveState
                                                                .isAddResoucesClicked,
                                                        state: state,
                                                        pendoState: pendoState);
                                                  },
                                          ),
                                        )),
                                  ),
                                  SizedBox(height: 20),
                                  BlocListener<TodoCrudBloc, TodoCrudState>(
                                    listener: (context, state) async {
                                      final bloc = context
                                          .read<CreateTodoLocalSaveBloc>();
                                      if (state is CreateTodoErrorState ||
                                          state is SaveTodoErrorState) {
                                        bloc.add(IsLoadingCreateTodo(
                                            isLoading: false));
                                      } else if (state
                                          is CreateTodoResourceSuccessState) {
                                        bloc.add(
                                            ClearCreateTodoLocalSaveEvent());
                                      }
                                    },
                                    bloc: context.read<TodoCrudBloc>(),
                                    child: _createButton(
                                        state: state,
                                        todoLocalSaveState: todoLocalSaveState),
                                  ),
                                ],
                              );
                            }),
                          );
                        }),
                      ),
                      const SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                ),
              );
            }),
          );
        });
      },
    );
  }

  List<String> selectedGuys = [];
  void _showAssigneeBottomSheet(BuildContext context) async {
    
    bool isBtnClicked = false;
    bool tempIsSelfAdded = isSelfSelectedFlag;
    bool tempIsSendToGroupSelected = isSendToProgramSelectedFlag;
    List<Asignee> copyAsigneeList = assigneeContactList;
    List<Asignee> tempfilterAsigneeDropDownSelected = <Asignee>[]
      ..addAll(filterAsigneeDropDownSelected);
    List<Asignee> tempAsigneeContact = []..addAll(assigneeContactList);
    List<String> tempSelectedAssigne = []..addAll(selectedAsignee);
    await showModalBottomSheet(
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
          return BlocBuilder<GetContactsBloc, GetContactsState>(
              builder: (context, getContactState) {
            if (getContactState is GetContactsLoadingState) {
              return Center(child: CustomPaletteLoader());
            }
            return StatefulBuilder(builder: (context, mysetState) {
              return DraggableScrollableSheet(
                  initialChildSize: 0.8,
                  maxChildSize: 0.95,
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
                            SizedBox(
                              height: 30,
                            ),
                            SelfAssignButton(
                                name: name,
                                profilePicture: profilePicture,
                                isSelected: isSelfSelectedFlag,
                                onTap: () {
                                  isSelfSelectedFlag = !isSelfSelectedFlag;
                                  if (isSelfSelectedFlag) {
                                    if (!selectedAsignee.contains(sfid)) {
                                      selectedAsignee.add(sfid!);
                                    }
                                    int index = filterAsigneeDropDownSelected
                                        .indexWhere((element) =>
                                            element.ward.id == sfid);
                                    if (index < 0) {
                                      filterAsigneeDropDownSelected.add(Asignee(
                                          ward: Ward(
                                              id: sfid!,
                                              name: name,
                                              profilePicture: profilePicture)));
                                    }
                                  } else {
                                    selectedAsignee.remove(sfid!);
                                    filterAsigneeDropDownSelected.removeWhere(
                                        (element) => element.ward.id == sfid);
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
                                        assigneeContactList = copyAsigneeList
                                            .where((element) => element
                                                .ward.name
                                                .toLowerCase()
                                                .contains(text.toLowerCase()))
                                            .toList();
                                      }
                                      if (text.trim().isEmpty) {
                                        assigneeContactList = copyAsigneeList;
                                      }
                                      mysetState(() {});
                                    })),
                            SizedBox(height: 15),
                           
                            SuggestEntireProgramButton(
                                isSelected: isSendToProgramSelectedFlag,
                                onTap: () {
                                  isSendToProgramSelectedFlag =
                                      !isSendToProgramSelectedFlag;
                                  selectedAsignee = [];
                                  filterAsigneeDropDownSelected = [];
                                  for (int i = 0;
                                      i < assigneeContactList.length;
                                      i++) {
                                    assigneeContactList[i] =
                                        assigneeContactList[i]
                                            .copyWith(isSelected: false);
                                  }

                                  isSelfSelectedFlag = false;
                                  mysetState(() {});
                                }),
                            SizedBox(height: 15),
                            TextScaleFactorClamper(
                              child: Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: assigneeContactList.length,
                                  itemBuilder: (ctx, ind) {
                                    return MultiSelectItem(
                                      image: assigneeContactList[ind]
                                          .ward
                                          .profilePicture,
                                      name: assigneeContactList[ind].ward.name,
                                      select:
                                          assigneeContactList[ind].isSelected,
                                      isSelected: (bool value) {
                                        int indexOfItem =
                                            assigneeContactList.indexWhere(
                                                (element) => (element.ward.id ==
                                                    assigneeContactList[ind]
                                                        .ward
                                                        .id));
                                        if (indexOfItem != -1) {
                                          assigneeContactList[indexOfItem] =
                                              assigneeContactList[indexOfItem]
                                                  .copyWith(isSelected: value);
                                        }
                                        if (isSendToProgramSelectedFlag) {
                                          isSendToProgramSelectedFlag = false;
                                          mysetState(() {});
                                        }
                                        int selectedAsigneeIndex =
                                            selectedAsignee.indexWhere(
                                                (element) =>
                                                    element ==
                                                    assigneeContactList[ind]
                                                        .ward
                                                        .id);
                                        int filterIndex =
                                            filterAsigneeDropDownSelected
                                                .indexWhere((element) =>
                                                    element.ward.id ==
                                                    assigneeContactList[ind]
                                                        .ward
                                                        .id);

                                        if (assigneeContactList[indexOfItem]
                                            .isSelected) {
                                          if (selectedAsigneeIndex < 0) {
                                            selectedAsignee.add(
                                                assigneeContactList[ind]
                                                    .ward
                                                    .id);
                                          }
                                          if (filterIndex < 0) {
                                            filterAsigneeDropDownSelected
                                                .add(assigneeContactList[ind]);
                                          }
                                        } else {
                                          selectedAsignee.remove(
                                              assigneeContactList[ind].ward.id);
                                          filterAsigneeDropDownSelected
                                              .removeAt(filterIndex);
                                        }

                                        print(
                                            'Updated thing is:${assigneeContactList[ind].isSelected}');
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
                                FloatingActionButton(
                                  backgroundColor: pinkRed,
                                  onPressed: () {
                                    isBtnClicked = true;

                                    final bloc = BlocProvider.of<
                                        CreateTodoLocalSaveBloc>(context);
                                    bloc.add(AssigneeChanged(
                                        assignee: filterDropDownValue));
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
          });
        }).whenComplete(() {
          searchController.text = '';
          setState(() { });
        });
    if (!isBtnClicked) {
      isSelfSelectedFlag = tempIsSelfAdded;
      isSendToProgramSelectedFlag = tempIsSendToGroupSelected;
      filterAsigneeDropDownSelected = []
        ..addAll(tempfilterAsigneeDropDownSelected);
      assigneeContactList = []..addAll(tempAsigneeContact);
      selectedAsignee = []..addAll(tempSelectedAssigne);
    }
  }

  void _loadLocalState(CreateTodoLocalSaveState todoLocalSaveState) {
    if (todoLocalSaveState.dueTime != null) {
      _time =
          "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, todoLocalSaveState.dueTime!.hour, todoLocalSaveState.dueTime!.minute))}";
    }
    if (todoLocalSaveState.remainderTime != null) {
      _timeRem =
          "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, todoLocalSaveState.remainderTime!.hour, todoLocalSaveState.remainderTime!.minute))}";
    }
    if (todoLocalSaveState.eventTime != null) {
      _timeEve =
          "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, todoLocalSaveState.eventTime!.hour, todoLocalSaveState.eventTime!.minute))}";
    }

    linkResources = todoLocalSaveState.linkResources ?? [];
    fileResources = todoLocalSaveState.fileResources ?? [];
    filesLoaderForBloc = todoLocalSaveState.filesLoaderForBloc ?? [];
  }

  Widget _addResourcesButton(CreateTodoLocalSaveState todoLocalSaveState) {
    return Container(
      height: 40,
      child: MaterialButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(
            Radius.circular(10),
          ),
        ),
        color: Colors.white,
        onPressed: () {
          _addResourcesOnPressed(todoLocalSaveState);
        },
        child: Text(
          "Add Resources",
          style: robotoTextStyle.copyWith(
              fontSize: 14, fontWeight: FontWeight.w500, color: pinkRed),
        ),
      ),
    );
  }

  Container _createButton(
      {required TodoCrudState state,
      required CreateTodoLocalSaveState todoLocalSaveState}) {
    return Container(
      height: 55,
      width: MediaQuery.of(context).size.width * 0.6,
      child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        return KeyboardDismissOnTap(
          child: IgnorePointer(
            ignoring: state is CreateTodoLoadingState ||
                state is CreateTodoResourcesLoadingState ||
                todoLocalSaveState.isLoading,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(26),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 0.5,
                    blurRadius: 4,
                    offset: Offset(-2, 6),
                  ),
                ],
              ),
              child: state is CreateTodoLoadingState ||
                      state is CreateTodoResourcesLoadingState ||
                      todoLocalSaveState.isLoading ||
                      state is CreateTodoLoadingState
                  ? Center(
                      child: SpinKitChasingDots(
                        color: neoGreen,
                        size: 20,
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(
                          onTap: state is CreateTodoLoadingState ||
                                  state is CreateTodoResourcesLoadingState ||
                                  todoLocalSaveState.isLoading
                              ? () {}
                              : () {
                                  print(
                                      'isSendToProgramSelectedFlag: $isSendToProgramSelectedFlag');

                                  if (validationError(todoLocalSaveState) ==
                                      true) return;
                                  if (isSendToProgramSelectedFlag) {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return TodoAlertPopup(
                                          type: TodoAlertsType.create,
                                          title: 'Global To-Do',
                                          body:
                                              'The program admin will receive an approval request for this to-do.\n\nAre you sure you want to submit?',
                                          cancelTap: () {
                                            Navigator.pop(context);
                                          },
                                          yesTap: () {
                                            Navigator.pop(context);
                                            createButtonOnPressed(
                                              todoLocalSaveState:
                                                  todoLocalSaveState,
                                              isAddRescoucesClicked:
                                                  todoLocalSaveState
                                                      .isAddResoucesClicked,
                                              state: state,
                                              pendoState: pendoState,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  } else {
                                    showDialog(
                                      context: context,
                                      barrierDismissible: false,
                                      builder: (BuildContext context) {
                                        return TodoAlertPopup(
                                          type: TodoAlertsType.create,
                                          title: 'Create To-Do',
                                          body:
                                              'Are you sure you want to create this To-Do?',
                                          cancelTap: () {
                                            Navigator.pop(context);
                                          },
                                          yesTap: () {
                                            Navigator.pop(context);
                                            createButtonOnPressed(
                                              todoLocalSaveState:
                                                  todoLocalSaveState,
                                              isAddRescoucesClicked:
                                                  todoLocalSaveState
                                                      .isAddResoucesClicked,
                                              state: state,
                                              pendoState: pendoState,
                                            );
                                          },
                                        );
                                      },
                                    );
                                  }
                                },
                          child:
                              // state is CreateTodoLoadingState ||
                              //         state is CreateTodoResourcesLoadingState ||
                              //         todoLocalSaveState.isLoading
                              //     ? Center(
                              //         child: SpinKitChasingDots(
                              //           color: neoGreen,
                              //           size: 20,
                              //         ),
                              //       )
                              //     :
                              Container(
                            height: 55,
                            padding: EdgeInsets.symmetric(horizontal: 4),
                            child: Row(
                              children: [
                                Text(
                                  "SUBMIT",
                                  style: robotoTextStyle.copyWith(
                                    fontSize: 14,
                                    fontWeight: FontWeight.bold,
                                    color: neoGreen,
                                  ),
                                ),
                                SizedBox(width: 5),
                                Icon(
                                  Icons.task_alt,
                                  color: neoGreen,
                                )
                              ],
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: state is CreateTodoLoadingState ||
                                  state is CreateTodoResourcesLoadingState ||
                                  todoLocalSaveState.isLoading ||
                                  state is SaveTodoLoadingState
                              ? () {}
                              : () {
                                  saveButtonOnPressed(
                                    todoLocalSaveState: todoLocalSaveState,
                                    isAddRescoucesClicked:
                                        todoLocalSaveState.isAddResoucesClicked,
                                    state: state,
                                    pendoState: pendoState,
                                  );
                                },
                          child: state is SaveTodoLoadingState ||
                                  state is CreateTodoResourcesLoadingState ||
                                  todoLocalSaveState.isLoading
                              ? Center(
                                  child: SpinKitChasingDots(
                                    color: neoGreen,
                                    size: 20,
                                  ),
                                )
                              : Container(
                                  height: 55,
                                  padding: EdgeInsets.symmetric(horizontal: 4),
                                  child: Row(
                                    children: [
                                      Text(
                                        'SAVE',
                                        style: robotoTextStyle.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                          color: greyishGrey,
                                        ),
                                      ),
                                      SizedBox(width: 5),
                                      Icon(
                                        Icons.bookmark_add_outlined,
                                        color: greyishGrey,
                                      )
                                    ],
                                  ),
                                ),
                        ),
                      ],
                    ),
            ),
          ),
        );
      }),
    );
  }

  bool validationError(CreateTodoLocalSaveState todoLocalSaveState) {
    var foundError = false;

    final _bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
    if (selectedAsignee.isEmpty && !isSendToProgramSelectedFlag) {
      setState(() {
        errorAsignee = true;
        foundError = true;
      });
    } else {
      setState(() {
        errorAsignee = false;
      });
    }

    log('Selected Assignees: $selectedAsignee');

    if (todoLocalSaveState.todoType == 'to-do type') {
      setState(() {
        errorDropdown = true;
        foundError = true;
        isCreateTodoClicked = false;
      });
      _bloc.add(IsLoadingCreateTodo(isLoading: false));
    } else {
      setState(() {
        errorDropdown = false;
      });
    }
    if (todoLocalSaveState.actionText.trim().isEmpty ||
        todoLocalSaveState.actionText.length >= 81) {
      _bloc.add(IsLoadingCreateTodo(isLoading: false));
      setState(() {
        errorAction = true;
        foundError = true;
        isCreateTodoClicked = false;
      });
    } else {
      setState(() {
        errorAction = false;
      });
    }
    if (todoLocalSaveState.todoType.startsWith("Event") &&
        (todoLocalSaveState.venue?.trim().isEmpty ?? true)) {
      _bloc.add(IsLoadingCreateTodo(isLoading: false));
      setState(() {
        errorVenue = true;
        foundError = true;
        isCreateTodoClicked = false;
      });
    } else {
      setState(() {
        errorVenue = false;
      });
    }
    if (todoLocalSaveState.todoType.startsWith("Event") &&
        (todoLocalSaveState.eventDate == null)) {
      _bloc.add(IsLoadingCreateTodo(isLoading: false));
      setState(() {
        errorEvent = true;
        foundError = true;
        isCreateTodoClicked = false;
      });
    } else {
      setState(() {
        errorEvent = false;
      });
    }

    return foundError;
  }

  bool saveValidationError(CreateTodoLocalSaveState todoLocalSaveState) {
    var foundError = false;

    final _bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);

    if (todoLocalSaveState.todoType == 'to-do type') {
      setState(() {
        errorDropdown = true;
        foundError = true;
        isCreateTodoClicked = false;
      });
      _bloc.add(IsLoadingCreateTodo(isLoading: false));
    } else {
      setState(() {
        errorDropdown = false;
      });
    }
    if (todoLocalSaveState.actionText.trim().isEmpty ||
        todoLocalSaveState.actionText.length >= 81) {
      _bloc.add(IsLoadingCreateTodo(isLoading: false));
      setState(() {
        errorAction = true;
        foundError = true;
        isCreateTodoClicked = false;
      });
    } else {
      setState(() {
        errorAction = false;
      });
    }

    return foundError;
  }

  createButtonOnPressed(
      {required CreateTodoLocalSaveState todoLocalSaveState,
      required bool isAddRescoucesClicked,
      required TodoCrudState state,
      required PendoMetaDataState pendoState}) async {
    BlocProvider.of<HideNavbarBloc>(context).add(ShowBottomNavbarEvent());

    validationError(todoLocalSaveState);

    /// Getting DueDate
    var dueDate = '';

    if (dueDateIsNotEmpty == false) {
      dueDate = '';
    } else {
      if (todoLocalSaveState.dueTime == null) {
        dueDate = DateTime(
          todoLocalSaveState.dueDate!.year,
          todoLocalSaveState.dueDate!.month,
          todoLocalSaveState.dueDate!.day,
          23,
          59,
        ).toUtc().toIso8601String();
      } else {
        dueDate = DateTime(
                todoLocalSaveState.dueDate!.year,
                todoLocalSaveState.dueDate!.month,
                todoLocalSaveState.dueDate!.day,
                todoLocalSaveState.dueTime!.hour,
                todoLocalSaveState.dueTime!.minute)
            .toUtc()
            .toIso8601String();
      }
    }

    if (todoLocalSaveState.todoType.startsWith("Event") &&
        (todoLocalSaveState.eventDate != null &&
            todoLocalSaveState.venue!.trim().isNotEmpty) &&
        (todoLocalSaveState.todoType != 'to-do type' &&
            todoLocalSaveState.actionText.trim().isNotEmpty &&
            todoLocalSaveState.actionText.length < 81)) {
      TodoPendoRepo.trackCreateTodoEvent(
        title: todoLocalSaveState.actionText,
        type: todoLocalSaveState.todoType,
        pendoState: pendoState,
        isSendToProgramSelectedFlag: isSendToProgramSelectedFlag,
        isForOthers: selectedAsignee.length > 1,
        isForSelf: isSelfSelectedFlag,
      );

      actionTxt = todoLocalSaveState.actionText;
      descriptionTxt = todoLocalSaveState.descriptionText ?? ' ';
      print('todoLocalSaveState.eventDate: ${todoLocalSaveState.eventDate}');
      BlocProvider.of<TodoCrudBloc>(context).add(
        CreateTodoEvent(
          context: context,
          selfSfId: pendoState.accountId,
          asigneeList: selectedAsignee,
          isSendToProgramSelectedFlag: isSendToProgramSelectedFlag,
          todoModel: TodoModel(
            name: todoLocalSaveState.actionText,
            description: todoLocalSaveState.descriptionText ?? " ",
            eventAt: todoLocalSaveState.eventDate == null
                ? ''
                : todoLocalSaveState.eventTime == null
                    ? DateTime(
                        todoLocalSaveState.eventDate!.year,
                        todoLocalSaveState.eventDate!.month,
                        todoLocalSaveState.eventDate!.day,
                      ).toUtc().toIso8601String()
                    : DateTime(
                        todoLocalSaveState.eventDate!.year,
                        todoLocalSaveState.eventDate!.month,
                        todoLocalSaveState.eventDate!.day,
                        todoLocalSaveState.eventTime!.hour,
                        todoLocalSaveState.eventTime!.minute,
                      ).toUtc().toIso8601String(),
            status: "Open",
            completedBy: dueDate,
            reminderAt: reminderDateIsNotEmpty == false
                ? ''
                : todoLocalSaveState.remainderTime == null
                    ? DateTime(
                            todoLocalSaveState.remainderDate!.year,
                            todoLocalSaveState.remainderDate!.month,
                            todoLocalSaveState.remainderDate!.day)
                        .toUtc()
                        .toIso8601String()
                    : DateTime(
                            todoLocalSaveState.remainderDate!.year,
                            todoLocalSaveState.remainderDate!.month,
                            todoLocalSaveState.remainderDate!.day,
                            todoLocalSaveState.remainderTime!.hour,
                            todoLocalSaveState.remainderTime!.minute)
                        .toUtc()
                        .toIso8601String(),
            type: todoLocalSaveState.todoType,
            venue: todoLocalSaveState.venue!,
          ),
        ),
      );
    } else if (errorEvent == false &&
        errorVenue == false &&
        (todoLocalSaveState.todoType != 'to-do type' &&
            todoLocalSaveState.actionText.trim().isNotEmpty &&
            todoLocalSaveState.actionText.length < 81)) {
      TodoPendoRepo.trackCreateTodoEvent(
        title: todoLocalSaveState.actionText,
        type: todoLocalSaveState.todoType,
        pendoState: pendoState,
        isSendToProgramSelectedFlag: isSendToProgramSelectedFlag,
        isForSelf: isSelfSelectedFlag,
        isForOthers: selectedAsignee.length > 1,
      );

      print(_dateTimeStart);
      actionTxt = todoLocalSaveState.actionText;
      descriptionTxt = todoLocalSaveState.descriptionText ?? '';
      BlocProvider.of<TodoCrudBloc>(context).add(
        CreateTodoEvent(
          context: context,
          selfSfId: pendoState.accountId,
          asigneeList: selectedAsignee,
          isSendToProgramSelectedFlag: isSendToProgramSelectedFlag,
          todoModel: TodoModel(
            name: todoLocalSaveState.actionText,
            description: todoLocalSaveState.descriptionText ?? " ",
            status: "Open",
            completedBy: dueDate,
            reminderAt: reminderDateIsNotEmpty == false
                ? ''
                : todoLocalSaveState.remainderTime == null
                    ? DateTime(
                            todoLocalSaveState.remainderDate!.year,
                            todoLocalSaveState.remainderDate!.month,
                            todoLocalSaveState.remainderDate!.day)
                        .toUtc()
                        .toIso8601String()
                    : DateTime(
                            todoLocalSaveState.remainderDate!.year,
                            todoLocalSaveState.remainderDate!.month,
                            todoLocalSaveState.remainderDate!.day,
                            todoLocalSaveState.remainderTime!.hour,
                            todoLocalSaveState.remainderTime!.minute)
                        .toUtc()
                        .toIso8601String(),
            type: todoLocalSaveState.todoType,
          ),
        ),
      );
    }
  }

  saveButtonOnPressed(
      {required CreateTodoLocalSaveState todoLocalSaveState,
      required bool isAddRescoucesClicked,
      required TodoCrudState state,
      required PendoMetaDataState pendoState}) async {
    BlocProvider.of<HideNavbarBloc>(context).add(ShowBottomNavbarEvent());

    saveValidationError(todoLocalSaveState);

    if ((todoLocalSaveState.todoType != 'to-do type' &&
        todoLocalSaveState.actionText.trim().isNotEmpty &&
        todoLocalSaveState.actionText.length < 81)) {
      // Pendo log
      TodoPendoRepo.trackSaveTodoEvent(
        title: todoLocalSaveState.actionText,
        type: todoLocalSaveState.todoType,
        pendoState: pendoState,
        isSendToProgramSelectedFlag: isSendToProgramSelectedFlag,
        isForOthers: selectedAsignee.length > 1,
        isForSelf: isSelfSelectedFlag,
      );

      ///
      actionTxt = todoLocalSaveState.actionText;
      descriptionTxt = todoLocalSaveState.descriptionText ?? ' ';
      print('todoLocalSaveState.eventDate: ${todoLocalSaveState.eventDate}');
      BlocProvider.of<TodoCrudBloc>(context).add(
        SaveTodoEvent(
          context: context,
          selfSfId: pendoState.accountId,
          asigneeList: selectedAsignee,
          isSendToProgramSelectedFlag: isSendToProgramSelectedFlag,
          todoModel: TodoModel(
            name: todoLocalSaveState.actionText,
            description: todoLocalSaveState.descriptionText ?? " ",
            eventAt: todoLocalSaveState.eventDate == null
                ? ''
                : todoLocalSaveState.eventTime == null
                    ? DateTime(
                        todoLocalSaveState.eventDate!.year,
                        todoLocalSaveState.eventDate!.month,
                        todoLocalSaveState.eventDate!.day,
                      ).toUtc().toIso8601String()
                    : DateTime(
                        todoLocalSaveState.eventDate!.year,
                        todoLocalSaveState.eventDate!.month,
                        todoLocalSaveState.eventDate!.day,
                        todoLocalSaveState.eventTime!.hour,
                        todoLocalSaveState.eventTime!.minute,
                      ).toUtc().toIso8601String(),
            status: "Open",
            completedBy: dueDateIsNotEmpty == false
                ? ''
                : todoLocalSaveState.dueTime == null
                    ? DateTime(
                            todoLocalSaveState.dueDate!.year,
                            todoLocalSaveState.dueDate!.month,
                            todoLocalSaveState.dueDate!.day)
                        .toUtc()
                        .toIso8601String()
                    : DateTime(
                            todoLocalSaveState.dueDate!.year,
                            todoLocalSaveState.dueDate!.month,
                            todoLocalSaveState.dueDate!.day,
                            todoLocalSaveState.dueTime!.hour,
                            todoLocalSaveState.dueTime!.minute)
                        .toUtc()
                        .toIso8601String(),
            type: todoLocalSaveState.todoType,
            venue: todoLocalSaveState.venue ?? '',
          ),
        ),
      );
    }
  }

  _addResourcesOnPressed(CreateTodoLocalSaveState todoLocalSaveState) async {
    final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);

    if (todoLocalSaveState.todoType == 'to-do type') {
      setState(() {
        errorDropdown = true;
        isCreateTodoClicked = false;
      });
    } else {
      setState(() {
        errorDropdown = false;
      });
    }
    if (todoLocalSaveState.actionText.trim().isEmpty ||
        todoLocalSaveState.actionText.length >= 81) {
      setState(() {
        errorAction = true;
        isCreateTodoClicked = false;
      });
    } else {
      setState(() {
        errorAction = false;
      });
    }
    if (todoLocalSaveState.todoType.startsWith("Event") &&
        (todoLocalSaveState.venue?.trim().isEmpty ?? true)) {
      print('error venue');
      setState(() {
        errorVenue = true;
        isCreateTodoClicked = false;
      });
    } else {
      setState(() {
        errorVenue = false;
      });
    }
    if (todoLocalSaveState.todoType.startsWith("Event") &&
        (todoLocalSaveState.eventDate == null)) {
      setState(() {
        errorEvent = true;
        isCreateTodoClicked = false;
      });
    } else {
      setState(() {
        errorEvent = false;
      });
    }

    if (todoLocalSaveState.todoType.startsWith("Event") &&
        (todoLocalSaveState.eventDate != null &&
            todoLocalSaveState.venue!.trim().isNotEmpty) &&
        (todoLocalSaveState.todoType != 'to-do type' &&
            todoLocalSaveState.actionText.trim().isNotEmpty &&
            todoLocalSaveState.actionText.length < 81)) {
      bloc.add(AddResourcesClicked());
      actionTxt = todoLocalSaveState.actionText;
      descriptionTxt = todoLocalSaveState.descriptionText ?? ' ';
    } else if (errorEvent == false &&
        errorVenue == false &&
        (todoLocalSaveState.todoType != 'to-do type' &&
            todoLocalSaveState.actionText.trim().isNotEmpty &&
            todoLocalSaveState.actionText.length < 81)) {
      print(_dateTimeStart);
      actionTxt = todoLocalSaveState.actionText;
      descriptionTxt = todoLocalSaveState.descriptionText ?? ' ';
      bloc.add(AddResourcesClicked());
    }
  }

  buildTimePicker(BuildContext context, bool isEvent,
      CreateTodoLocalSaveState todoLocalSaveState) {
    return InkWell(
      onTap: () {
        isEvent
            ? _selectTimeEvent(context, todoLocalSaveState)
            : _selectTime(context, todoLocalSaveState);
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
          child: Wrap(
            children: [
              if (isEvent)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                      todoLocalSaveState.eventTime == null
                          ? 'Time'
                          : '$_timeEve',
                      style: montserratNormal.copyWith(
                          fontSize: 12, color: defaultDark),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                ),
              if (!isEvent)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                      todoLocalSaveState.dueTime == null ? 'Time' : '$_time',
                      style: montserratNormal.copyWith(
                          fontSize: 12, color: defaultDark),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2),
                ),
            ],
          ),
        ),
      ),
    );
  }

  buildReminderTimePicker(
      BuildContext context, CreateTodoLocalSaveState todoLocalSaveState) {
    return InkWell(
      onTap: () {
        _selectTimeRem(context, todoLocalSaveState);
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
          child: Wrap(
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 8),
              //   child: SvgPicture.asset(
              //     'images/clock.svg',
              //     color: defaultDark,
              //     height: 19,
              //     width: 19,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 2),
                child: Text(
                    todoLocalSaveState.remainderTime == null
                        ? 'Time'
                        : '$_timeRem',
                    style: montserratNormal.copyWith(
                        fontSize: 12, color: defaultDark),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildDatePicker(BuildContext context, bool isEve,
      CreateTodoLocalSaveState todoLocalSaveState) {
    return InkWell(
      onTap: () {
        isEve
            ? showDatePicker(
                    context: context,
                    initialDate: todoLocalSaveState.eventDate == null
                        ? DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        : todoLocalSaveState.eventDate!,
                    firstDate: DateTime(2021),
                    lastDate: DateTime(DateTime.now().year + 2),
                    cancelText: 'CLEAR')
                .then((date) {
                setState(() {
                  if (date != null) {
                    dueDateEventIsNotEmpty = true;
                  } else {
                    dueDateEventIsNotEmpty = false;
                  }
                  _dateTimeStartEve = date;
                });
                final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
                print('eventdate $date');
                bloc.add(EventDateChanged(eventDate: date));
              })
            : showDatePicker(
                    context: context,
                    initialDate: todoLocalSaveState.dueDate == null
                        ? DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        : todoLocalSaveState.dueDate!,
                    firstDate: DateTime(2021),
                    lastDate: DateTime(DateTime.now().year + 2),
                    cancelText: 'CLEAR')
                .then((date) {
                setState(() {
                  print(date);
                  if (date != null) {
                    dueDateIsNotEmpty = true;
                  } else
                    dueDateIsNotEmpty = false;
                  _dateTimeStart = date;
                });
                final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
                bloc.add(DueDateChanged(dueDate: date));
              });
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        width: MediaQuery.of(context).size.width * 0.35,
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: (todoLocalSaveState.dueDate == null && errorDue) ||
                      (dueDateEventIsNotEmpty == false && errorEvent && isEve)
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
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: isEve
                    ? Text(
                        _dateTimeStartEve == null
                            ? 'Date'
                            : '${(todoLocalSaveState.eventDate?.month)}-${todoLocalSaveState.eventDate?.day}-${todoLocalSaveState.eventDate?.year}',
                        style: montserratNormal.copyWith(
                            fontSize: 12,
                            color: errorEvent && dueDateEventIsNotEmpty == false
                                ? todoListActiveTab
                                : defaultDark),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2)
                    : Text(
                        _dateTimeStart == null
                            ? 'Date'
                            : '${(todoLocalSaveState.dueDate?.month)}-${todoLocalSaveState.dueDate?.day}-${todoLocalSaveState.dueDate?.year}',
                        style: montserratNormal.copyWith(
                            fontSize: 12,
                            color:
                                errorDue && todoLocalSaveState.dueDate == null
                                    ? todoListActiveTab
                                    : defaultDark),
                        overflow: TextOverflow.ellipsis,
                        maxLines: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  buildReminderDatePicker(
      BuildContext context, CreateTodoLocalSaveState todoLocalSaveState) {
    return InkWell(
      onTap: () {
        showDatePicker(
                context: context,
                initialDate: todoLocalSaveState.remainderDate == null
                    ? DateTime(DateTime.now().year, DateTime.now().month,
                        DateTime.now().day)
                    : todoLocalSaveState.remainderDate!,
                firstDate: DateTime(2021),
                lastDate: DateTime(DateTime.now().year + 2),
                cancelText: 'CLEAR')
            .then((date) {
          setState(() {
            print(date);
            if (date != null) {
              reminderDateIsNotEmpty = true;
            } else
              reminderDateIsNotEmpty = false;
            _dateTimeStartRem = date;
          });
          final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
          bloc.add(RemainderDateChanged(remainderDate: date));
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
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Padding(
              //   padding: const EdgeInsets.only(right: 8),
              //   child: Icon(
              //     Icons.calendar_today,
              //     color: defaultDark,
              //     size: 19,
              //   ),
              // ),
              Padding(
                padding: const EdgeInsets.only(top: 0),
                child: Text(
                    _dateTimeStartRem == null
                        ? 'Date'
                        : '${(todoLocalSaveState.remainderDate?.month)}-${todoLocalSaveState.remainderDate?.day}-${todoLocalSaveState.remainderDate?.year}',
                    style: montserratNormal.copyWith(
                        fontSize: 12, color: defaultDark),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DateTimeHeading extends StatelessWidget {
  const DateTimeHeading({Key? key, required this.title, required this.icon})
      : super(key: key);
  final String title;
  final String? icon;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            height: 24,
            width: 24,
            decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(50),
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
              child: SvgPicture.asset(
                icon!,
                color: defaultDark,
                height: 12,
                width: 11,
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Text(title,
              style:
                  montserratNormal.copyWith(fontSize: 12, color: defaultDark))
        ],
      ),
    );
  }
}
