import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/institute_logo.dart';
import 'package:palette/common_components/searchbar_recipients.dart';
import 'package:palette/common_components/text_field.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_bloc.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_event.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_state.dart';
import 'package:palette/modules/todo_module/bloc/create_todo_local_save_bloc/create_todo_local_save_bloc.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/modules/todo_module/models/asignee.dart';
import 'package:palette/modules/todo_module/models/createtodo_response_model.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_model.dart';
import 'package:palette/modules/todo_module/models/ward.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/add_resource_button.dart';
import 'package:palette/modules/todo_module/widget/common_todo_popup.dart';
import 'package:palette/modules/todo_module/widget/event_venue_box_container.dart';
import 'package:palette/modules/todo_module/widget/file_resource_card_button.dart';
import 'package:palette/modules/todo_module/widget/multiSelectListItem.dart';
import 'package:palette/modules/todo_module/widget/self_assign_todo_button.dart';
import 'package:palette/modules/todo_module/widget/suggest_program_todo_button.dart';
import 'package:palette/modules/todo_module/widget/textFormfieldForTodo.dart';
import 'package:palette/modules/todo_module/widget/todo_type_dropdown.dart';
import 'package:palette/modules/todo_module/widget/upload_resources_area.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:palette/utils/validation_regex.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../create_new_form.dart';

class ParentAdvisorCreateNewTodoForm extends StatefulWidget {
  final List<Todo> todoList;
  final List<Ward> wards;
  final TabController controller;
  ParentAdvisorCreateNewTodoForm(
      {required this.todoList, required this.wards, required this.controller});

  @override
  _ParentAdvisorCreateNewTodoFormState createState() =>
      _ParentAdvisorCreateNewTodoFormState();
}

ResponseDataAfterCreateTodo? response;
String actionTxt = "";
String descriptionText = "";

class _ParentAdvisorCreateNewTodoFormState
    extends State<ParentAdvisorCreateNewTodoForm> {
  String filterDropDownValue = 'to-do type';
  String filterasigneeValue = 'Assignee';
  List<Resources> fileResources = [];
  List<FileLoaderForBloc> fileLoaderForBloc = [];
  List<Resources> linkResources = [];
  List<String> selectedAsignee = [];
  List<Asignee> filterAsigneeDropDownSelected = [];
  List<Asignee> filterAsigneeDropDown = [];
  List<Asignee> copyAsigneeList = [];
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
  bool isSelfSelectedFlag = false;
  bool isSendToProgramSelectedFlag = false;
  bool isSelectAll = false;
  bool hasCreatedTodo = false;
  bool _isAttachmentUploading = false;

  bool dueDateIsNotEmpty = false;
  bool dueDateEventIsNotEmpty = false;
  bool reminderDateIsNotEmpty = false;
  DateTime? _dateTimeStart;
  DateTime? _dateTimeStartEve;
  DateTime? _dateTimeStartRem;

  TextEditingController actionController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  FocusNode? actionFocus;
  late String _time, _timeEve, _timeRem;
  TextEditingController _timeController = TextEditingController();

  TextEditingController fileTitleController = TextEditingController();
  TextEditingController fileurlController = TextEditingController();
  TextEditingController eventVenueController = TextEditingController();
  DateTime now = DateTime.now();

  bool errorAction = false;
  bool errorDescription = false;
  bool errorVenue = false;
  bool errorDue = false;
  bool errorEvent = false;
  bool errorDropdown = false;
  bool errorAsignee = false;

  bool updateState = false;

  String? sfid;
  String? sfuuid;
  String? role;

  var name;
  var profilePicture;
  var keyboardVisibilityController = KeyboardVisibilityController();
  bool _isKeyboardVisible = false;
  ScrollController scrollController = ScrollController();

  TextEditingController searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  bool isSearching = false;

  Future<Null> _selectTime(
      BuildContext context, CreateTodoLocalSaveState todoLocalSaveState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: todoLocalSaveState.dueTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
      final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);

      _time = "${DateFormat.jm().format(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        picked.hour,
        picked.minute,
      ))}";
      _timeController.text = _time;
      _timeController.text = picked.toString();
      bloc.add(DueTimeChanged(dueTime: picked));
      // setState(() {
      //   selectedTime = picked;
      //   showSelectedTime = picked;
      //   _time =
      //       "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, showSelectedTime.hour, showSelectedTime.minute))}";
      //   _timeController.text = _time;
      //   _timeController.text = showSelectedTime.toString();
      //   //selectedAsignee
      // });
    }
  }

  Future<Null> _selectTimeEvent(
    BuildContext context,
    CreateTodoLocalSaveState todoLocalSaveState,
  ) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: todoLocalSaveState.eventTime ??
          TimeOfDay.fromDateTime(DateTime.now()),
    );
    if (picked != null) {
      _timeEve = "${DateFormat.jm().format(DateTime(
        DateTime.now().year,
        DateTime.now().month,
        DateTime.now().day,
        picked.hour,
        picked.minute,
      ))}";
      _timeController.text = _timeEve;
      _timeController.text = picked.toString();
      final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
      bloc.add(EventTimeChanged(eventTime: picked));
    }
  }

  @override
  void initState() {
    // widget.wards.forEach((element) {
    //   filterAsigneeDropDown.add(
    //     Asignee(ward: element),
    //   );
    // });
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('ketyert $visible');
      setState(() {
        _isKeyboardVisible = visible;
      });
    });
    super.initState();
    _getSfidAndRole();
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
    print(sfid);
    sfuuid = prefs.getString(saleforceUUIDConstant);
    role = prefs.getString('role').toString();
    name = prefs.getString(fullNameConstant);
    print(name);
    profilePicture = prefs.getString(profilePictureConstant);
  }

  List<ContactsData> contacts = [];
  bool isContactsLoaded = false;

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    // if (!_isKeyboardVisible) {
    //   BlocProvider.of<HideNavbarBloc>(context).add(ShowBottomNavbarEvent());
    // }
    return BlocBuilder<GetContactsBloc, GetContactsState>(
        builder: (context, state) {
      if (state is GetContactsSuccessState) {
        if (!isContactsLoaded) {
          contacts = state.contactsResponse.contacts
              .where((element) => element.canCreateTodo)
              .toList();
          filterAsigneeDropDown = [];
          contacts.forEach((element) {
            filterAsigneeDropDown.add(Asignee(
                ward: Ward(
                    id: element.sfid,
                    name: element.name,
                    profilePicture: element.profilePicture)));
          });
          copyAsigneeList = filterAsigneeDropDown;
          isContactsLoaded = true;
        }
        _searchFocusNode.addListener(() {
          if (_searchFocusNode.hasFocus) {
            setState(() {
              isSearching = true;
            });
          } else {
            setState(() {
              isSearching = false;
            });
          }
        });
      }

      return BlocBuilder<CreateTodoLocalSaveBloc, CreateTodoLocalSaveState>(
          builder: (context, todoLocalSaveState) {
        _loadLocalState(todoLocalSaveState);
        return BlocListener(
          bloc: context.read<TodoParentCrudBloc>(),
          listener: (context, state) {
            if (state is CreateTodoParentResourceSuccessState) {
              context
                  .read<TodoParentAdvisorBloc>()
                  .add(FetchTodosParentEvent());
              widget.controller.animateTo((widget.controller.index + 2) % 3);
            } else if (state is SaveTodoParentResourceSuccessState) {
              context
                  .read<TodoParentAdvisorBloc>()
                  .add(FetchTodosParentEvent());
              widget.controller.animateTo((widget.controller.index + 1) % 3);
            }
          },
          child: BlocBuilder<TodoParentCrudBloc, TodoParentCrudState>(
              builder: (context, state) {
            if (state is CreateTodoParentLoadingState) updateState = true;
            if (updateState && state is CreateTodoParentResourceSuccessState) {}
            return _body(
                todoLocalSaveState: todoLocalSaveState,
                device: device,
                todoParentCrudState: state);
          }),
        );
      });
    });
  }

  Widget _body({
    required CreateTodoLocalSaveState todoLocalSaveState,
    required Size device,
    required todoParentCrudState,
  }) {
    return TextScaleFactorClamper(
      child: ListView(
        children: [
          Padding(
            padding: EdgeInsets.fromLTRB(40, 30, 40, 0),
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
                        width: MediaQuery.of(context).size.width * .35,
                        child: Stack(children: [
                          if (filterAsigneeDropDownSelected.isEmpty &&
                              !isSendToProgramSelectedFlag)
                            Container(
                              height: 50,
                              padding: EdgeInsets.fromLTRB(20, 10, 10, 0),
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: errorAsignee
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
                                        color: errorAsignee
                                            ? todoListActiveTab
                                            : defaultDark,
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
                          if (isSendToProgramSelectedFlag)
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
                                    imageUrl: '',
                                    imageBuilder: (context, imageProvider) =>
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
                                    placeholder: (context, url) => CircleAvatar(
                                        radius:
                                            // widget.screenHeight <= 736 ? 35 :
                                            29,
                                        backgroundColor: Colors.white,
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
                                        Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                          child: CircleAvatar(
                                              backgroundColor: white,
                                              radius: 30,
                                              child:
                                                  InstituteLogo(radius: 30))),
                                    ),
                                  ),
                                )),
                          if (filterAsigneeDropDownSelected.length >= 3)
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
                                    imageUrl: filterAsigneeDropDownSelected[2]
                                            .ward
                                            .profilePicture ??
                                        '',
                                    imageBuilder: (context, imageProvider) =>
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
                                    placeholder: (context, url) => CircleAvatar(
                                        radius:
                                            // widget.screenHeight <= 736 ? 35 :
                                            29,
                                        backgroundColor: Colors.white,
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
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
                                                filterAsigneeDropDownSelected[2]
                                                    .ward
                                                    .name),
                                            style: darkTextFieldStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: aquaBlue)),
                                      ),
                                    ),
                                  ),
                                )),
                          if (filterAsigneeDropDownSelected.length > 3)
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
                                            color:
                                                Colors.black.withOpacity(0.15),
                                            blurRadius: 5,
                                            offset: Offset(0, 1),
                                          ),
                                        ]),
                                    child: Center(
                                        child: Text(
                                      (filterAsigneeDropDownSelected.length - 3)
                                          .toString(),
                                      style:
                                          TextStyle(color: white, fontSize: 10),
                                    )))),
                          if (filterAsigneeDropDownSelected.length >= 2)
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
                                    imageUrl: filterAsigneeDropDownSelected[1]
                                            .ward
                                            .profilePicture ??
                                        '',
                                    imageBuilder: (context, imageProvider) =>
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
                                    placeholder: (context, url) => CircleAvatar(
                                        radius:
                                            // widget.screenHeight <= 736 ? 35 :
                                            29,
                                        backgroundColor: Colors.white,
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
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
                                                filterAsigneeDropDownSelected[1]
                                                    .ward
                                                    .name),
                                            style: darkTextFieldStyle.copyWith(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w700,
                                                color: aquaBlue)),
                                      ),
                                    ),
                                  ),
                                )),
                          if (filterAsigneeDropDownSelected.length >= 1)
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
                                    imageUrl: filterAsigneeDropDownSelected[0]
                                            .ward
                                            .profilePicture ??
                                        '',
                                    imageBuilder: (context, imageProvider) =>
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
                                    placeholder: (context, url) => CircleAvatar(
                                        radius:
                                            // widget.screenHeight <= 736 ? 35 :
                                            29,
                                        backgroundColor: Colors.white,
                                        child: CircularProgressIndicator()),
                                    errorWidget: (context, url, error) =>
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
                                                filterAsigneeDropDownSelected[0]
                                                    .ward
                                                    .name),
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
                                  color: errorAsignee
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
                      onChanged: (newValue) {
                        final bloc =
                            BlocProvider.of<CreateTodoLocalSaveBloc>(context);
                        bloc.add(TodoTypeChanged(
                            todoType:
                                newValue != null ? newValue : 'to-do type'));
                        setState(() {
                          filterDropDownValue =
                              newValue != null ? newValue : 'to-do type';
                          if (!filterDropDownValue.startsWith('Event')) {
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
                  height: 10,
                ),
                CommonTextFieldTodo(
                  inputFocus: actionFocus,
                  height: 50,
                  hintText: 'Enter Action Text',
                  inputController: actionController,
                  isCreateForm: true,
                  isForAction: true,
                  errorFlag: errorAction,
                  initialValue: todoLocalSaveState.actionText,
                  onChanged: (value) {
                    final bloc =
                        BlocProvider.of<CreateTodoLocalSaveBloc>(context);
                    bloc.add(ActionTextChanged(actionText: value));
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
                        buildDatePicker(context, false, todoLocalSaveState),
                        !dueDateIsNotEmpty
                            ? Container()
                            : buildTimePicker(
                                context: context,
                                isEvent: false,
                                todoLocalSaveState: todoLocalSaveState),
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
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        buildReminderDatePicker(context, todoLocalSaveState),
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
                          buildDatePicker(context, true, todoLocalSaveState),
                          !dueDateEventIsNotEmpty
                              ? Container()
                              : buildTimePicker(
                                  context: context,
                                  isEvent: true,
                                  todoLocalSaveState: todoLocalSaveState),
                        ],
                      ),
                    ],
                  ),
                if (filterDropDownValue.startsWith('Event'))
                  const SizedBox(
                    height: 20,
                  ),
                CommonTextFieldTodo(
                  height: 150,
                  hintText: 'Enter Description',
                  inputController: descriptionController,
                  isCreateForm: true,
                  errorFlag: errorDescription,
                  initialValue: descriptionController.text,
                  onChanged: (value) {
                    final bloc =
                        BlocProvider.of<CreateTodoLocalSaveBloc>(context);
                    bloc.add(DescriptionTextChanged(descriptionText: value));
                  },
                ),
                const SizedBox(
                  height: 20,
                ),
                if (filterDropDownValue.startsWith('Event'))
                  EventVenueTextBox(
                      controller: eventVenueController,
                      errorFlag: errorVenue,
                      initialValue: eventVenueController.text,
                      isCreateForm: true,
                      onChanged: (value) {
                        final bloc =
                            BlocProvider.of<CreateTodoLocalSaveBloc>(context);
                        bloc.add(VenueChanged(venue: value));
                      }),
                if (filterDropDownValue.startsWith('Event'))
                  const SizedBox(
                    height: 10,
                  ),
              ],
            ),
          ),
          LayoutBuilder(builder: (context, constraints) {
            return Container(
                child: _listViewUpload(device, context, todoParentCrudState));
          }),
          BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
              builder: (context, pendoState) {
            return BlocListener(
              bloc: BlocProvider.of<TodoParentCrudBloc>(context),
              listener: (context, state) async {
                if (state is CreateTodoParentSuccessState) {
                  if (fileResources.isNotEmpty) {
                    _setAttachmentUploading(true);
                  }
                  final bloc = context.read<CreateTodoLocalSaveBloc>();
                  response = state.response;
                  for (int i = 0; i < fileResources.length; i++) {
                    print('The file resources ${fileResources[i].url}');
                    var file = fileLoaderForBloc[i];
                    try {
                      final reference = FirebaseStorage.instance
                          .ref("Resources/${response!.gId}/${file.fileName}");
                      await reference.putFile(file.file);
                      final uri = await reference.getDownloadURL();
                      fileResources[i].url = uri;
                      bloc.add(
                          FileResourcesChanged(fileresources: fileResources));
                      print('Updated file resources ${fileResources[i].url}');
                    } on FirebaseException catch (e) {
                      print('file $e ${e.message}');
                    }
                  }
                  final List<Map> responseSend = [];
                  List<Resources> resources = [];
                  resources = linkResources + fileResources;
                  resources.forEach((element) {
                    responseSend.add(element.toJson());
                  });
                  BlocProvider.of<TodoParentCrudBloc>(context).add(
                      CreateTodoParentResourceEvent(
                          todoId: response!.ids, resources: resources));
                } else if (state is SaveTodoParentSuccessState) {
                  if (fileResources.isNotEmpty) {
                    _setAttachmentUploading(true);
                  }
                  final bloc = context.read<CreateTodoLocalSaveBloc>();
                  response = state.response;
                  for (int i = 0; i < fileResources.length; i++) {
                    print('The file resources ${fileResources[i].url}');
                    var file = fileLoaderForBloc[i];
                    try {
                      final reference = FirebaseStorage.instance
                          .ref("Resources/${response!.gId}/${file.fileName}");
                      await reference.putFile(file.file);
                      final uri = await reference.getDownloadURL();
                      fileResources[i].url = uri;
                      bloc.add(
                          FileResourcesChanged(fileresources: fileResources));
                      print('Updated file resources ${fileResources[i].url}');
                    } on FirebaseException catch (e) {
                      print('file $e ${e.message}');
                    }
                  }
                  final List<Map> responseSend = [];
                  List<Resources> resources = [];
                  resources = linkResources + fileResources;
                  resources.forEach((element) {
                    responseSend.add(element.toJson());
                  });
                  BlocProvider.of<TodoParentCrudBloc>(context).add(
                      SaveTodoParentResourceEvent(
                          todoId: response!.ids, resources: resources));
                } else if (state is CreateTodoParentResourceSuccessState ||
                    state is SaveTodoParentResourceSuccessState) {
                  BlocProvider.of<CreateTodoLocalSaveBloc>(context)
                      .add(IsLoadingCreateTodo(isLoading: false));
                  BlocProvider.of<CreateTodoLocalSaveBloc>(context)
                      .add(ClearCreateTodoLocalSaveEvent());
                } else if (state is CreateTodoParentLoadingState ||
                    state is CreateTodoParentResourceLoadingState ||
                    state is SaveTodoParentLoadingState ||
                    state is SaveTodoParentResourceLoadingState) {
                  BlocProvider.of<CreateTodoLocalSaveBloc>(context)
                      .add(IsLoadingCreateTodo(isLoading: true));
                } else if (state is CreateTodoParentResourceErrorState) {
                  _setAttachmentUploading(false);
                  final bloc = context.read<CreateTodoLocalSaveBloc>();
                  bloc.add(IsLoadingCreateTodo(isLoading: false));
                  Helper.showCustomSnackBar(
                      'Unable to upload in todo,please try again', context);
                  BlocProvider.of<CreateTodoLocalSaveBloc>(context)
                      .add(IsLoadingCreateTodo(isLoading: false));
                } else if (state is CreateTodoParentErrorState) {
                  _setAttachmentUploading(false);
                  final bloc = context.read<CreateTodoLocalSaveBloc>();
                  bloc.add(IsLoadingCreateTodo(isLoading: false));
                  Helper.showCustomSnackBar(
                      'Unable to create todo,please try again', context);
                } else if (state is SaveTodoParentResourceErrorState) {
                  _setAttachmentUploading(false);
                  final bloc = context.read<CreateTodoLocalSaveBloc>();
                  bloc.add(IsLoadingCreateTodo(isLoading: false));
                  Helper.showCustomSnackBar(
                      'Unable to upload in todo,please try again', context);
                  BlocProvider.of<CreateTodoLocalSaveBloc>(context)
                      .add(IsLoadingCreateTodo(isLoading: false));
                } else if (state is SaveTodoParentErrorState) {
                  _setAttachmentUploading(false);
                  final bloc = context.read<CreateTodoLocalSaveBloc>();
                  bloc.add(IsLoadingCreateTodo(isLoading: false));
                  Helper.showCustomSnackBar(
                      'Unable to save todo,please try again', context);
                }
              },
              child: Column(
                children: [
                  // Visibility(
                  //     child: _addResourcesButton(
                  //         todoParentCrudState, todoLocalSaveState),
                  //     visible: !todoLocalSaveState.isAddResoucesClicked
                  //     ),
                  createTodoButton(
                      context: context,
                      state: todoParentCrudState,
                      todoLocalSaveState: todoLocalSaveState),
                ],
              ),
            );
          }),
          const SizedBox(
            height: 80,
          ),
        ],
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
          filterAsigneeDropDown = copyAsigneeList;
          bool _isSearching = isSearching;
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
                        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          SizedBox(height: 20),
                          // TODO: to hide this while searching uncomment
                          //   if(!isSearching)
                          SelfAssignButton(
                              name: name,
                              profilePicture: profilePicture,
                              isSelected: isSelfSelectedFlag,
                              onTap: () {
                                isSelfSelectedFlag = !isSelfSelectedFlag;
                                if (isSelfSelectedFlag) {
                                  selectedAsignee.add(sfid!);
                                  filterAsigneeDropDownSelected.add(Asignee(
                                      ward: Ward(
                                          id: sfid!,
                                          name: name,
                                          profilePicture: profilePicture)));
                                } else {
                                  selectedAsignee.remove(sfid!);
                                  filterAsigneeDropDownSelected.removeWhere(
                                      (element) => element.ward.id == sfid);
                                }
                                isSendToProgramSelectedFlag = false;
                                mysetState(() {});
                              }),
                          //   if (!isSearching)
                          SizedBox(height: 15),
                          Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: SearchBarForRecipients(
                                  searchFocusNode: _searchFocusNode,
                                  searchController: searchController,
                                  onChanged: (String text) {
                                    if (text.trim().isNotEmpty) {
                                      filterAsigneeDropDown = copyAsigneeList
                                          .where((element) => element.ward.name
                                              .toLowerCase()
                                              .contains(text.toLowerCase()))
                                          .toList();
                                    }
                                    if (text.trim().isEmpty) {
                                      filterAsigneeDropDown = copyAsigneeList;
                                    }
                                    mysetState(() {});
                                  })),
                          SizedBox(height: 15),
                          // if (!isSearching)
                          SuggestEntireProgramButton(
                              isSelected: isSendToProgramSelectedFlag,
                              onTap: () {
                                isSendToProgramSelectedFlag =
                                    !isSendToProgramSelectedFlag;
                                selectedAsignee = [];
                                filterAsigneeDropDownSelected = [];
                                filterAsigneeDropDown.forEach((element) {
                                  element.isSelected = false;
                                });
                                isSelfSelectedFlag = false;
                                mysetState(() {});
                              }),
                          // if (!isSearching)
                          SizedBox(height: 15),
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
                                        mysetState(() {});
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
                                          filterAsigneeDropDownSelected
                                              .add(filterAsigneeDropDown[ind]);
                                        }
                                      } else {
                                        selectedAsignee.remove(
                                          filterAsigneeDropDown[ind].ward.id,
                                        );
                                        filterAsigneeDropDown[ind].isSelected =
                                            false;
                                        filterAsigneeDropDownSelected
                                            .remove(filterAsigneeDropDown[ind]);
                                      }
                                      BlocProvider.of<CreateTodoLocalSaveBloc>(
                                              context)
                                          .add(AssigneeDropDownChanged(
                                              assigneeDropDown:
                                                  filterAsigneeDropDown));
                                      BlocProvider.of<CreateTodoLocalSaveBloc>(
                                              context)
                                          .add(SelectedAssigneesChanged(
                                              selectedAssignees:
                                                  selectedAsignee));
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
                                  if (selectedAsignee.length > 0)
                                    filterasigneeValue =
                                        "${selectedAsignee.length} selected";
                                  else
                                    filterasigneeValue = 'Assignee';
                                  final bloc =
                                      BlocProvider.of<CreateTodoLocalSaveBloc>(
                                          context);
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
        }).whenComplete(() {
      print(selectedAsignee);
      filterAsigneeDropDown = copyAsigneeList;
      searchController.text = "";
      setState(() {});
      final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
      if (selectedAsignee.length > 0)
        filterasigneeValue = "${selectedAsignee.length} selected";
      else {
        filterasigneeValue = 'Assignee';
      }
      bloc.add(SelectedAssigneesChanged(selectedAssignees: selectedAsignee));
      bloc.add(AssigneeChanged(assignee: filterasigneeValue));
    });
  }

  void _loadLocalState(CreateTodoLocalSaveState todoLocalSaveState) {
    filterDropDownValue = todoLocalSaveState.todoType;
    filterasigneeValue = todoLocalSaveState.assignee ?? 'Assignee';
    actionController.text = todoLocalSaveState.actionText;
    descriptionController.text = todoLocalSaveState.descriptionText ?? '';
    eventVenueController.text = todoLocalSaveState.venue ?? '';
    // _dateTimeStartEve = todoLocalSaveState.eventDate;
    if (todoLocalSaveState.dueDate != null) {
      print('vcvx v ${todoLocalSaveState.dueDate}');
      // dueDateIsNotEmpty = true;
      // _dateTimeStart = todoLocalSaveState.dueDate;
    }
    if (todoLocalSaveState.eventDate != null) {
      print('vcvx ');
      // dueDateEventIsNotEmpty = true;
      // _dateTimeStartEve = todoLocalSaveState.eventDate;
    }
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
    fileResources = todoLocalSaveState.fileResources ?? [];
    linkResources = todoLocalSaveState.linkResources ?? [];
    fileLoaderForBloc = todoLocalSaveState.filesLoaderForBloc ?? [];
    if (todoLocalSaveState.assigneeDropDown == null) {
      filterAsigneeDropDown.forEach((element) {
        element.isSelected = false;
      });
    }
    if (todoLocalSaveState.assigneeDropDown != null) {
      filterAsigneeDropDown = todoLocalSaveState.assigneeDropDown!;
    }
    filterasigneeValue = todoLocalSaveState.assignee ?? 'Assignee';
    if (todoLocalSaveState.selectedAssignees != null) {
      selectedAsignee = todoLocalSaveState.selectedAssignees!;
      // print('df d${todoLocalSaveState.selectedAssignees!}');
    }
  }

  Widget createTodoButton(
      {required BuildContext context,
      required TodoParentCrudState state,
      required CreateTodoLocalSaveState todoLocalSaveState}) {
    return Center(
      child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        return Container(
          height: 55,
          width: MediaQuery.of(context).size.width * 0.6,
          child: KeyboardDismissOnTap(
            child: IgnorePointer(
              ignoring: _isAttachmentUploading ||
                  state is CreateTodoParentLoadingState ||
                  state is CreateTodoParentResourceLoadingState ||
                  state is SaveTodoParentLoadingState ||
                  state is SaveTodoParentResourceLoadingState,
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
                      offset: Offset(-2, 6), // changes position of shadow
                    ),
                  ],
                ),
                child: state is CreateTodoParentLoadingState ||
                        state is CreateTodoParentResourceLoadingState ||
                        todoLocalSaveState.isLoading ||
                        state is CreateTodoParentLoadingState ||
                        state is SaveTodoParentLoadingState ||
                        state is SaveTodoParentResourceLoadingState
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
                            onTap: state is CreateTodoParentLoadingState ||
                                    state
                                        is CreateTodoParentResourceLoadingState ||
                                    _isAttachmentUploading
                                ? () {}
                                : () {
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
                                              _createTodoPressed(
                                                context: context,
                                                pendoState: pendoState,
                                                todoLocalSaveState:
                                                    todoLocalSaveState,
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
                                              _createTodoPressed(
                                                pendoState: pendoState,
                                                context: context,
                                                todoLocalSaveState:
                                                    todoLocalSaveState,
                                              );
                                              Navigator.pop(context);
                                            },
                                          );
                                        },
                                      );
                                    }
                                  },
                            child: state is CreateTodoParentLoadingState ||
                                    state
                                        is CreateTodoParentResourceLoadingState ||
                                    _isAttachmentUploading
                                ? Center(
                                    child: SpinKitChasingDots(
                                      color: neoGreen,
                                      size: 20,
                                    ),
                                  )
                                : Container(
                                    height: 55,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
                                    child: Row(
                                      children: [
                                        Text(
                                          _isAttachmentUploading
                                              ? 'Uploading'
                                              : "SUBMIT",
                                          style: robotoTextStyle.copyWith(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: neoGreen,
                                          ),
                                        ),
                                        SizedBox(width: 5),
                                        _isAttachmentUploading
                                            ? Container()
                                            : Icon(
                                                Icons.task_alt,
                                                color: neoGreen,
                                              )
                                      ],
                                    ),
                                  ),
                          ),
                          GestureDetector(
                            onTap: state is CreateTodoParentLoadingState ||
                                    state
                                        is CreateTodoParentResourceErrorState ||
                                    todoLocalSaveState.isLoading ||
                                    state is SaveTodoParentLoadingState
                                ? () {}
                                : () {
                                    _saveTodoPressed(
                                      todoLocalSaveState: todoLocalSaveState,
                                      pendoState: pendoState,
                                    );
                                  },
                            child: state is SaveTodoParentLoadingState ||
                                    state is SaveTodoParentResourceLoadingState
                                // ||
                                // todoLocalSaveState.isLoading
                                ? Center(
                                    child: SpinKitChasingDots(
                                      color: greyishGrey,
                                      size: 20,
                                    ),
                                  )
                                : Container(
                                    height: 55,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 4),
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
              // child: MaterialButton(
              //   shape: RoundedRectangleBorder(
              //     borderRadius: BorderRadius.all(
              //       Radius.circular(10),
              //     ),
              //   ),
              //   color: pinkRed,
              //   onPressed: state is CreateTodoParentLoadingState ||
              //           state is CreateTodoParentResourceLoadingState ||
              //           _isAttachmentUploading
              //       ? () {}
              //       : () {
              //           if (isSendToProgramSelectedFlag) {
              //             showDialog(
              //               context: context,
              //               barrierDismissible: false,
              //               builder: (BuildContext context) {
              //                 return TodoAlertPopup(
              //                   title: 'Global To-Do',
              //                   body:
              //                       'The program admin will receive an approval request for this to-do.\n\nAre you sure you want to submit?',
              //                   cancelTap: () {
              //                     Navigator.pop(context);
              //                   },
              //                   yesTap: () {
              //                     Navigator.pop(context);
              //                     _createTodoPressed(
              //                       pendoState: pendoState,
              //                       todoLocalSaveState: todoLocalSaveState,
              //                     );
              //                   },
              //                 );
              //               },
              //             );
              //           } else {
              //             showDialog(
              //               context: context,
              //               barrierDismissible: false,
              //               builder: (BuildContext context) {
              //                 return TodoAlertPopup(
              //                   title: 'Global To-Do',
              //                   body:
              //                       'Are you sure you want to create this To-Do?',
              //                   cancelTap: () {
              //                     Navigator.pop(context);
              //                   },
              //                   yesTap: () {
              //                     _createTodoPressed(
              //                       pendoState: pendoState,
              //                       todoLocalSaveState: todoLocalSaveState,
              //                     );
              //                     Navigator.pop(context);
              //                   },
              //                 );
              //               },
              //             );
              //           }
              //         },
              //   child: state is CreateTodoParentLoadingState ||
              //           state is CreateTodoParentResourceLoadingState ||
              //           _isAttachmentUploading
              //       ? Center(
              //           child: SpinKitChasingDots(
              //             color: Colors.white,
              //             size: 20,
              //           ),
              //         )
              //       : Text(
              //           _isAttachmentUploading ? 'Uploading' : "Create",
              //           style: roboto700.copyWith(
              //               fontSize: 17, color: Colors.white),
              //         ),
              // ),
            ),
          ),
        );
      }),
    );
  }

  bool validationError(CreateTodoLocalSaveState todoLocalSaveState) {
    var foundError = false;

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
    if (filterDropDownValue == 'to-do type') {
      setState(() {
        errorDropdown = true;
        foundError = true;
      });
    } else {
      setState(() {
        errorDropdown = false;
      });
    }
    // if (_dateTimeStart == null || selectedTime == null) {
    //   setState(() {
    //     errorDue = true;
    //   });
    // } else {
    //   setState(() {
    //     errorDue = false;
    //   });
    // }
    if (actionController.text.trim().isEmpty ||
        actionController.text.length >= 81) {
      setState(() {
        errorAction = true;
        foundError = true;
      });
    } else {
      setState(() {
        errorAction = false;
      });
    }
    if (filterDropDownValue.startsWith("Event") &&
        (eventVenueController.text.trim().isEmpty)) {
      setState(() {
        errorVenue = true;
        foundError = true;
      });
    } else {
      setState(() {
        errorVenue = false;
      });
    }
    if (filterDropDownValue.startsWith("Event") &&
        (_dateTimeStartEve == null || todoLocalSaveState.eventDate == null)) {
      setState(() {
        errorEvent = true;
        foundError = true;
      });
    } else {
      {
        setState(() {
          errorEvent = false;
        });
      }
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
      });
    } else {
      setState(() {
        errorAction = false;
      });
    }

    return foundError;
  }

  void _createTodoPressed({
    required PendoMetaDataState pendoState,
    required CreateTodoLocalSaveState todoLocalSaveState,
    required BuildContext context,
  }) {
    print('create todo pressed parent: $isSendToProgramSelectedFlag');
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

    /// Pendo log for creating Tødo
    TodoPendoRepo.trackCreateTodoEvent(
      title: actionController.text,
      type: filterDropDownValue,
      assignee: selectedAsignee,
      pendoState: pendoState,
      isSendToProgramSelectedFlag: isSendToProgramSelectedFlag,
      isForOthers: selectedAsignee.length > 1,
      isForSelf: isSelfSelectedFlag,
    );

    if (filterDropDownValue.startsWith("Event") &&
        (todoLocalSaveState.eventDate != null &&
            eventVenueController.text.trim().isNotEmpty) &&
        ((selectedAsignee.isNotEmpty || isSendToProgramSelectedFlag) &&
            filterDropDownValue != 'to-do type' &&
            actionController.text.trim().isNotEmpty &&
            actionController.text.length < 81)) {
      actionTxt = actionController.text;
      descriptionText = descriptionController.text;
      BlocProvider.of<TodoParentCrudBloc>(context).add(
        CreateTodoParentEvent(
            context: context,
            selfSfId: pendoState.accountId,
            todoModel: TodoModel(
              name: actionController.text,
              description: descriptionController.text.isEmpty
                  ? ' '
                  : descriptionController.text,
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
              type: filterDropDownValue,
              venue: eventVenueController.text,
            ),
            asignee: selectedAsignee,
            isSendToProgramSelectedFlag: isSendToProgramSelectedFlag),
      );
    } else if (errorEvent == false &&
        errorVenue == false &&
        // _dateTimeStart != null &&
        // selectedTime != null &&
        (selectedAsignee.isNotEmpty || isSendToProgramSelectedFlag) &&
        filterDropDownValue != 'to-do type' &&
        actionController.text.trim().isNotEmpty &&
        actionController.text.length < 81) {
      print(dueDateIsNotEmpty);
      print(_dateTimeStart);
      actionTxt = actionController.text;
      descriptionText = descriptionController.text;

      BlocProvider.of<TodoParentCrudBloc>(context).add(
        CreateTodoParentEvent(
          context: context,
          selfSfId: pendoState.accountId,
          todoModel: TodoModel(
            name: actionController.text,
            description: descriptionController.text.isEmpty
                ? ' '
                : descriptionController.text,
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
            type: filterDropDownValue,
          ),
          asignee: selectedAsignee,
          isSendToProgramSelectedFlag: isSendToProgramSelectedFlag,
        ),
      );
    }
  }

  void _saveTodoPressed({
    required PendoMetaDataState pendoState,
    required CreateTodoLocalSaveState todoLocalSaveState,
  }) {
    print('create todo pressed parent: $isSendToProgramSelectedFlag');
    BlocProvider.of<HideNavbarBloc>(context).add(ShowBottomNavbarEvent());
    saveValidationError(todoLocalSaveState);

    // Pendo log
    TodoPendoRepo.trackSaveTodoEvent(
      title: todoLocalSaveState.actionText,
      type: todoLocalSaveState.todoType,
      pendoState: pendoState,
      isSendToProgramSelectedFlag: isSendToProgramSelectedFlag,
      isForOthers: selectedAsignee.length > 1,
      isForSelf: isSelfSelectedFlag,
    );

    if (filterDropDownValue != 'to-do type' &&
        actionController.text.trim().isNotEmpty &&
        actionController.text.length < 81) {
      actionTxt = actionController.text;
      descriptionText = descriptionController.text;
      BlocProvider.of<TodoParentCrudBloc>(context).add(
        SaveTodoParentEvent(
            context: context,
            selfSfId: pendoState.accountId,
            todoModel: TodoModel(
              name: actionController.text,
              description: descriptionController.text.isEmpty
                  ? ' '
                  : descriptionController.text,
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
              type: filterDropDownValue,
              venue: eventVenueController.text,
            ),
            asignee: selectedAsignee,
            isSendToProgramSelectedFlag: isSendToProgramSelectedFlag),
      );
    }
  }

  Widget _listViewUpload(
      Size device, BuildContext context, TodoParentCrudState state) {
    return TextScaleFactorClamper(
      child: Semantics(
        label:
            "This is the page to attach resources to todo tap on upload resources to upload and than tap done",
        child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
            builder: (context, pendoState) {
          return Container(
            child: Column(
              children: [
                if (fileResources.isEmpty)
                  UploadResourcesArea(
                      onUploadTap: () {
                        TodoPendoRepo.trackTapOnUploadResourcesEvent(
                            pendoState: pendoState);
                        _showBottomSheetForUpload();
                      },
                      isAttachmentUploading: _isAttachmentUploading),
                if (fileResources.isNotEmpty)
                  Container(
                    padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
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
                            scrollDirection: Axis.horizontal,
                            controller: scrollController,
                            shrinkWrap: true,
                            itemCount: fileResources.length,
                            itemBuilder: (ctx, ind) {
                              return Container(
                                margin: EdgeInsets.fromLTRB(2, 0, 2, 0),
                                child: Stack(
                                  children: [
                                    FileResourceCardButton(
                                      file: fileResources[ind],
                                      isForm: true,
                                      gid: null,
                                      role: role,
                                      sfid: sfid,
                                      sfuuid: sfuuid,
                                      todotitle: actionController.text,
                                    ),
                                    Positioned(
                                      right: 0,
                                      top: 0,
                                      child: InkWell(
                                        onTap: () {
                                          fileResources.removeAt(ind);
                                          fileLoaderForBloc.removeAt(ind);
                                          final bloc = BlocProvider.of<
                                              CreateTodoLocalSaveBloc>(context);
                                          bloc.add(FileResourcesChanged(
                                              fileresources: fileResources));
                                          bloc.add(FilesLoaderForBlocChanged(
                                              filesLoaderForBloc:
                                                  fileLoaderForBloc));
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
                linkResources.isNotEmpty && linkResources.length > 0
                    ? Center(
                        child: Container(
                          height: 100,
                          width: device.width * 0.8,
                          margin: EdgeInsets.only(top: 10),
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
                SizedBox(height: 10),
              ],
            ),
          );
        }),
      ),
    );
  }

  Widget _addResourcesButton(
      TodoParentCrudState state, CreateTodoLocalSaveState todoLocalSaveState) {
    return Padding(
      padding: const EdgeInsets.only(right: 35, bottom: 20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            height: 40,
            child: MaterialButton(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(
                  Radius.circular(10),
                ),
              ),
              color: Colors.white,
              onPressed: state is CreateTodoParentResourceLoadingState ||
                      state is CreateTodoParentLoadingState
                  ? () {}
                  : () {
                      final bloc =
                          BlocProvider.of<CreateTodoLocalSaveBloc>(context);
                      // bloc.add(AddResourcesClicked());
                      _addResourcesOnPressed(todoLocalSaveState);
                    },
              child: Text(
                "Add Resources",
                style: robotoTextStyle.copyWith(
                    fontSize: 14, fontWeight: FontWeight.w500, color: pinkRed),
              ),
            ),
          ),
        ],
      ),
    );
  }

  _addResourcesOnPressed(CreateTodoLocalSaveState todoLocalSaveState) async {
    final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
    if (selectedAsignee.isEmpty) {
      setState(() {
        errorAsignee = true;
      });
    } else {
      setState(() {
        errorAsignee = false;
      });
    }
    if (todoLocalSaveState.todoType == 'to-do type') {
      setState(() {
        errorDropdown = true;
        // isCreateTodoClicked = false;
        // _isAddResourcesClicked = false;
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
        // isCreateTodoClicked = false;
        // _isAddResourcesClicked = false;
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
        // isCreateTodoClicked = false;
        // _isAddResourcesClicked = false;
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
        // isCreateTodoClicked = false;
        // _isAddResourcesClicked = false;
      });
    } else {
      setState(() {
        errorEvent = false;
      });
    }
    //API calls
    /// Pendo log

    if (todoLocalSaveState.todoType.startsWith("Event") &&
        (todoLocalSaveState.eventDate != null &&
            todoLocalSaveState.venue!.trim().isNotEmpty) &&
        (todoLocalSaveState.todoType != 'to-do type' &&
            todoLocalSaveState.actionText.trim().isNotEmpty &&
            todoLocalSaveState.actionText.length < 81)) {
      bloc.add(AddResourcesClicked());
      actionTxt = todoLocalSaveState.actionText;
      descriptionText = todoLocalSaveState.descriptionText ?? ' ';
    } else if (errorEvent == false &&
        errorVenue == false &&
        (todoLocalSaveState.todoType != 'to-do type' &&
            todoLocalSaveState.actionText.trim().isNotEmpty &&
            todoLocalSaveState.actionText.length < 81)) {
      print(_dateTimeStart);
      actionTxt = todoLocalSaveState.actionText;
      descriptionText = todoLocalSaveState.descriptionText ?? ' ';
      bloc.add(AddResourcesClicked());
    }
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
        child: InkWell(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // InkWell(
                  //   child: SvgPicture.asset(
                  //     "images/crossicon.svg",
                  //     color: defaultDark,
                  //     height: 16,
                  //     width: 16,
                  //   ),
                  //   onTap: () {
                  //     setState(() {
                  //       linkResources.removeAt(ind);
                  //     });
                  //   },
                  // ),
                  Container(
                    width: device.width * 0.6,
                    child: Text(
                      "   ${linkResources[ind].name}",
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
            fileTitleController.text = linkResources[ind].name;
            fileurlController.text = linkResources[ind].url;
            showLinkSheet(context, update: true, ind: ind);
            setState(() {});
          },
        ),
      ),
    );
  }

  buildTimePicker({
    required BuildContext context,
    required bool isEvent,
    required CreateTodoLocalSaveState todoLocalSaveState,
  }) {
    return InkWell(
      onTap: () {
        isEvent
            ? _selectTimeEvent(context, todoLocalSaveState)
            : _selectTime(context, todoLocalSaveState);
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 13),
        width: MediaQuery.of(context).size.width * 0.35,
        //height: 50,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
          border: Border.all(
            color:
                // (todoLocalSaveState.dueTime == null && errorDue) ||
                // (todoLocalSaveState.eventTime == null &&
                // errorEvent &&
                // isEvent)
                // ?
                //  todoListActiveTab
                // :
                Colors.transparent,
            width: 2.0,
          ),
        ),
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 9),
            child: Wrap(
              spacing: 8,
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (isEvent)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      todoLocalSaveState.eventTime == null
                          ? 'Time'
                          : '$_timeEve',
                      style: montserratNormal.copyWith(
                        fontSize: 12,
                        color:
                            // errorEvent && todoLocalSaveState.eventTime == null
                            // ? todoListActiveTab
                            // :
                            defaultDark,
                      ),
                    ),
                  ),
                if (!isEvent)
                  Padding(
                    padding: const EdgeInsets.only(top: 2),
                    child: Text(
                      todoLocalSaveState.dueTime == null ? 'Time' : '$_time',
                      style: montserratNormal.copyWith(
                          fontSize: 12,
                          color: errorDue && todoLocalSaveState.dueTime == null
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

  void _setAttachmentUploading(bool uploading) {
    _isAttachmentUploading = uploading;
  }

  void _showFilePicker() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.any,
    );

    if (result != null) {
      final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
      //_setAttachmentUploading(true);
      final fileName = result.files.single.name;
      final filePath = result.files.single.path;
      final fileType = fileName.split('.').last;
      final file = File(filePath ?? '');
      fileLoaderForBloc.add(FileLoaderForBloc(
          file: file,
          fileName: fileName,
          fileType: fileType,
          filePath: filePath ?? ''));
      bloc.add(
          FilesLoaderForBlocChanged(filesLoaderForBloc: fileLoaderForBloc));
      fileResources.add(Resources(
          name: fileName != null ? fileName : " ",
          url: filePath ?? '',
          type: fileType));
      bloc.add(FileResourcesChanged(fileresources: fileResources));

      // try {
      //   final reference =
      //       FirebaseStorage.instance.ref("Resources/${response!.gId}/fileName");
      //   await reference.putFile(file);
      //   final uri = await reference.getDownloadURL();
      //   fileResources.add(Resources(
      //       name: fileName != null ? fileName : " ", url: uri, type: fileType));
      //   _setAttachmentUploading(false);
      // } on FirebaseException catch (e) {
      //   _setAttachmentUploading(false);
      //   print(e);
      // }
    } else {
      // User canceled the picker
    }
  }

  buildDatePicker(BuildContext context, bool isEve,
      CreateTodoLocalSaveState todoLocalSaveState) {
    return InkWell(
      onTap: () {
        isEve
            ? showDatePicker(
                    context: context,
                    initialDate: _dateTimeStartEve == null
                        ? DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        : todoLocalSaveState.eventDate!,
                    firstDate: DateTime(2021),
                    lastDate: DateTime(DateTime.now().year + 2),
                    cancelText: 'CLEAR')
                .then((date) {
                final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
                if (date != null) {
                  dueDateEventIsNotEmpty = true;
                } else {
                  dueDateEventIsNotEmpty = false;
                }
                _dateTimeStartEve = date;

                bloc.add(EventDateChanged(eventDate: date));
              })
            : showDatePicker(
                    context: context,
                    initialDate: _dateTimeStart == null
                        ? DateTime(DateTime.now().year, DateTime.now().month,
                            DateTime.now().day)
                        : todoLocalSaveState.dueDate!,
                    firstDate: DateTime(2021),
                    lastDate: DateTime(DateTime.now().year + 2),
                    cancelText: 'CLEAR')
                .then((date) {
                setState(() {
                  if (date != null) {
                    dueDateIsNotEmpty = true;
                  } else
                    dueDateIsNotEmpty = false;
                  _dateTimeStart = date;

                  print(_dateTimeStart);
                });
                final bloc = BlocProvider.of<CreateTodoLocalSaveBloc>(context);
                bloc.add(DueDateChanged(dueDate: date ?? DateTime.now()));
                // setState(() {
                //   if (date != null) {
                //     dueDateIsNotEmpty = true;
                //   } else
                //     dueDateIsNotEmpty = false;
                //   _dateTimeStart = date;
                //   _showDate = date != null ? date : _showDate;
                // });
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
              //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  padding: const EdgeInsets.only(top: 2),
                  child: isEve
                      ? Text(
                          _dateTimeStartEve == null
                              ? 'Date'
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
                              ? 'Date'
                              : '${(_dateTimeStart?.month)}-${_dateTimeStart?.day}-${_dateTimeStart?.year}',
                          style: montserratNormal.copyWith(
                            fontSize: 12,
                            color: errorDue && _dateTimeStart == null
                                ? todoListActiveTab
                                : defaultDark,
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

  Future<Null> _selectTimeRem(
      BuildContext context, CreateTodoLocalSaveState todoLocalSaveState) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: todoLocalSaveState.remainderTime ?? TimeOfDay.now(),
    );
    if (picked != null) {
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
          return Container(
            height: 250,
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
                                  fileTitleController.clear();
                                  fileurlController.clear();
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
                        // Semantics(
                        //   label: "Tap to delete link",
                        //   child: InkWell(
                        //     onTap: (){
                        //       Navigator.pop(context);
                        //       setState(() {
                        //         setState(() {
                        //           linkResources.removeAt(ind);
                        //         });
                        //       });
                        //
                        //
                        //     },
                        //     child: SvgPicture.asset(
                        //       'images/trash-2.svg',
                        //       height: 20,
                        //       width: 20,
                        //     ),
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
                      inputController: fileTitleController),
                  SizedBox(
                    height: 20,
                  ),
                  CommonTextField(
                      height: 50,
                      hintText: 'Enter or paste URL',
                      isForLink: true,
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
                                final bloc =
                                    BlocProvider.of<CreateTodoLocalSaveBloc>(
                                        context);

                                if (update) {
                                  linkResources[ind].name =
                                      fileTitleController.text;
                                  linkResources[ind].url =
                                      fileurlController.text;
                                } else {
                                  linkResources.add(Resources(
                                      name: fileTitleController.text,
                                      url: link,
                                      type: 'Link'));
                                }
                                bloc.add(LinkResourcesChanged(
                                    linkresources: linkResources));
                                fileTitleController.clear();
                                fileurlController.clear();
                                Navigator.pop(context);
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
}
