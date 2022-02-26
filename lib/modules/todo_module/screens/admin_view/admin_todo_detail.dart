import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_bloc.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_state.dart';
import 'package:palette/modules/todo_module/bloc/todo_ad_bloc/todo_ad_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_state.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_status.dart';
import 'package:palette/modules/todo_module/screens/admin_view/admin_edit_todo.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/parent_advisor_todo_widgets/parent_todo_icon.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../widget/expandable_text.dart';
import '../../widget/link_generator.dart';
import '../../widget/file_resource_card_button.dart';

class AdminTodoDetailsScreen extends StatefulWidget {
  AdminTodoDetailsScreen({
    required this.todoItem,
    this.isObserverAdmin = false,
  });
  final Todo todoItem;
  final bool isObserverAdmin;

  @override
  _AdminTodoDetailsScreenState createState() =>
      _AdminTodoDetailsScreenState(todoItem: todoItem);
}

class _AdminTodoDetailsScreenState extends State<AdminTodoDetailsScreen> {
  Todo todoItem;
  _AdminTodoDetailsScreenState({required this.todoItem});
  List<Resources> resources = [];
  List<Resources> links = [];
  bool updateState = false;
  String? sfid;
  String? sfuuid;
  String? role;

  void getResources() {
    todoItem.todoResources.forEach((e) {
      if (e.type == "Link")
        links.add(e);
      else
        resources.add(e);
    });
  }

  @override
  void initState() {
    getResources();
    super.initState();
    _getSfidAndRole();
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
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: TextScaleFactorClamper(
            child: Stack(
              children: [
                Builder(builder: (context) {
                  final type = todoItem.task.type ?? 'Other';
                  final image =
                      type.startsWith('College') || type.startsWith('Education')
                          ? "images/education_WM.svg"
                          : type.startsWith('Job')
                              ? "images/business_WM.svg"
                              : _getImageStringForEvent(type: type);
                  return Positioned(
                    right: -30.0,
                    top: 0.0,
                    child: ExcludeSemantics(
                      child: SvgPicture.asset(
                        image,
                        height: device.height * 0.35,
                        color: type.startsWith('College') ||
                                type.startsWith('Education')
                            ? educationColor
                            : type.startsWith('Job')
                                ? companyColor
                                : _getImageBgColor(type: type),
                      ),
                    ),
                  );
                }),
                _listView(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  String _getImageStringForEvent({required String type}) {
    if (type == 'Event - Arts') {
      return 'images/arts_WM.svg';
    } else if (type == 'Event - Volunteer') {
      return 'images/volunteerWM.svg';
    } else if (type == 'Event - Social') {
      return 'images/social_WM.svg';
    } else if (type == 'Event - Sports') {
      return 'images/todo_sports.svg';
    } else if (type == 'Employment'){
      return 'images/employment.svg';
    } else {
      return 'images/genericVM.svg';
    }
  }

  Color? _getImageBgColor({required String type}) {
    if (type == 'Event - Arts') {
      return sportsBgColor;
    } else if (type == 'Event - Volunteer') {
      return sportsBgColor;
    } else if (type == 'Event - Social') {
      return sportsBgColor;
    } else if (type == 'Event - Sports') {
      return sportsBgColor;
    } else {
      return genericColor;
    }
  }

  Widget _listView() {
    String status = widget.todoItem.isopen
        ? TodoStatus.Open.name
        : widget.todoItem.iscomp
            ? TodoStatus.Completed.name
            : TodoStatus.Closed.name;
    String description = todoItem.task.description.toString();
    final device = MediaQuery.of(context).size;
    String event = todoItem.task.eventAt.toString();
    String venue = todoItem.task.venue.toString();
    return StatefulBuilder(builder: (context, stateSetter) {
      return BlocListener(
        listener: (context, state) {
          if (state is UpdateTodoAdminLoadingState) updateState = true;
          if (state is UpdateTodoAdminSuccessState) {
            context.read<TodoAdminBloc>().add(FetchTodosAdminEvent());
          }
          if (updateState && state is FetchTodoParentSuccessState) {
            setState(() {});
            updateState = false;
          }
        },
        bloc: context.read<TodoParentAdvisorBloc>(),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Semantics(
                  onTapHint: "Navigated back",
                  button: true,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, top: 2),
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Semantics(
                        label: "Button to navigate back to todo list",
                        child:
                            BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                                builder: (context, pendoState) {
                          return IconButton(
                            icon: RotatedBox(
                                quarterTurns: 1,
                                child: SvgPicture.asset(
                                  'images/dropdown.svg',
                                  color: defaultDark,
                                )),
                            color: defaultDark,
                            onPressed: () {
                              TodoPendoRepo.trackTapOnBackEvent(
                                  todoTitle: widget.todoItem.task.name ?? '',
                                  todoType:
                                      widget.todoItem.task.type ?? 'Other',
                                  status: status,
                                  pendoState: pendoState);
                              Navigator.pop(context);
                            },
                          );
                        }),
                      ),
                    ),
                  ),
                ),
                BlocBuilder<TodoBloc, TodoState>(
                  builder: (context, state) {
                    return widget.isObserverAdmin == true
                        ? Container()
                        : BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                            builder: (context, pendoState) {
                            return MaterialButton(
                              onPressed: () {
                                TodoPendoRepo.trackTapOnEditTodoEvent(
                                    pendoState: pendoState,
                                    todoTitle: widget.todoItem.task.name ?? '',
                                    todoType:
                                        widget.todoItem.task.type ?? 'Other',
                                    status: status);
                                showModalBottomSheet(
                                    backgroundColor: Colors.white,
                                    context: context,
                                    isScrollControlled: true,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(30),
                                        topRight: Radius.circular(30),
                                      ),
                                    ),
                                    builder: (context) {
                                      return TextScaleFactorClamper(
                                        child: Padding(
                                          padding: Platform.isIOS
                                              ? MediaQuery.of(context)
                                                  .viewInsets
                                              : EdgeInsets.zero,
                                          child: Wrap(
                                            children: [
                                              Container(
                                                height: device.height * 0.8,
                                                decoration: BoxDecoration(
                                                  color: Colors.white,
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                child:
                                                    AdminEditTodoForm(
                                                  todoItem: todoItem,
                                                  fileRes: resources,
                                                  linkRes: links,
                                                  status: status,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      );
                                    }).whenComplete(() => stateSetter(() {}));
                              },
                              child: Semantics(
                                label: "Tap to edit todo",
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: _getStatusButtonColor(status),
                                  ),
                                  child: SvgPicture.asset(
                                    "images/listed_by_todo_icon.svg",
                                    width: 17.0,
                                    height: 17.0,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            );
                          });
                  },
                ),
              ],
            ),
            Container(
              padding: EdgeInsets.fromLTRB(18, 10, 18, 10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Column(
                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width,
                        child: Text(
                          "${todoItem.task.name}",
                          textAlign: TextAlign.left,
                          style: TextStyle(
                              fontSize: 30, fontWeight: FontWeight.w700),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          SvgPicture.asset(
                            "images/listed_by_todo_icon.svg",
                            width: 18.0,
                            height: 18.0,
                          ),
                          SizedBox(width: 6),
                          Container(
                            width: device.width * 0.83,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  " LISTED BY",
                                  style: montserratBoldTextStyle.copyWith(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: defaultDark),
                                ),
                                Text(
                                  " ${todoItem.task.listedBy.name} at ${DateFormat.jm().format(DateTime.parse(todoItem.task.createdAt.toString()).toLocal())}, ${DateFormat.yMMMd('en_US').format(DateTime.parse(todoItem.task.createdAt.toString()).toLocal())}",
                                  style: montserratBoldTextStyle.copyWith(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: defaultDark),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: widget.todoItem.isopen
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.start,
                        children: [
                          BlocBuilder<TodoBloc, TodoState>(
                              builder: (context, state) {
                            return Semantics(
                              label: status,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  textStyle: montserratNormal.copyWith(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w700,
                                      color: white),
                                  primary: _getStatusButtonColor(status),
                                ),
                                onPressed: () {},
                                child: SizedBox(
                                  // width: device.width * 0.30,
                                  child: Center(
                                    child: Text(
                                      status.toUpperCase(),
                                      style: TextStyle(fontSize: 13),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                          const SizedBox(
                            width: 10,
                          ),
                          widget.todoItem.isopen
                              ? todoItem.task.completeBy.year == 9998
                                  ? Container()
                                  : Container(
                                      width: device.width * 0.50,
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            ' COMPLETE BY',
                                            style: montserratBoldTextStyle
                                                .copyWith(
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.w700,
                                                    color: defaultDark),
                                          ),
                                          Text(
                                            " ${DateFormat.jm().format(todoItem.task.completeBy.toLocal())}, ${DateFormat.yMMMd('en_US').format(todoItem.task.completeBy.toLocal())}",
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: montserratBoldTextStyle
                                                .copyWith(
                                                    fontSize: 15,
                                                    fontWeight: FontWeight.w600,
                                                    color: defaultDark),
                                          ),
                                        ],
                                      ),
                                    )
                              : Container()
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  if (todoItem.task.eventAt != null)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Event Date and Venue',
                            style: montserratNormal.copyWith(fontSize: 16),
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            children: [
                              SvgPicture.asset(
                                "images/clock.svg",
                                color: defaultDark,
                                height: 16,
                                width: 16,
                              ),
                              SizedBox(width: 10),
                              Text(
                                "${DateFormat.jm().format(DateTime.parse(event).toLocal())},",
                                style: montserratNormal.copyWith(fontSize: 16),
                              ),
                              Text(
                                "${DateFormat.yMMMd('en_US').format(DateTime.parse(event).toLocal())}",
                                style: montserratNormal.copyWith(fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 10),
                          if (todoItem.task.venue != null)
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.location_on,
                                  color: defaultDark,
                                  size: 18,
                                ),
                                SizedBox(width: 8),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.7,
                                  child: Text(
                                    "${todoItem.task.venue}",
                                    style:
                                        montserratNormal.copyWith(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          SizedBox(
                            height: 10,
                          ),
                        ],
                      ),
                    ),
                  if (description.trim() != "null" &&
                      description.trim().isNotEmpty)
                    BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
                      return ExpandableText("$description", status);
                    }),
                  SizedBox(height: resources.isNotEmpty ? 10 : 0),
                  resources.isNotEmpty
                      ? Row(
                          children: [
                            SvgPicture.asset(
                              'images/resources.svg',
                              color: defaultDark,
                            ),
                            SizedBox(width: 6),
                            Text(" Resources")
                          ],
                        )
                      : Container(),
                  SizedBox(height: resources.isNotEmpty ? 10 : 0),
                  resources.isNotEmpty
                      ? Container(
                          height: 130,
                          padding: EdgeInsets.all(8.0),
                          child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: resources.length,
                              itemBuilder: (ctx, ind) {
                                return Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: FileResourceCardButton(
                                    gid: widget.todoItem.task.gid,
                                    file: resources[ind],
                                    sfid: sfid,
                                    sfuuid: sfuuid,
                                    role: role,
                                    todotitle: todoItem.task.name ?? '',
                                  ),
                                );
                              }),
                        )
                      : Container(),
                  SizedBox(height: links.isNotEmpty ? 10 : 0),
                  links.isNotEmpty
                      ? Row(
                          children: [
                            SvgPicture.asset(
                              'images/globalLink.svg',
                              color: defaultDark,
                            ),
                            SizedBox(width: 6),
                            Text(" Links")
                          ],
                        )
                      : SizedBox(),
                  SizedBox(height: links.isNotEmpty ? 10 : 0),
                  links.isNotEmpty
                      ? links.length == 1
                          ? Container(
                              padding: EdgeInsets.all(8.0),
                              child: LinkGenerator(
                                file: links[0],
                                sfid: sfid,
                                sfuuid: sfuuid,
                                role: role,
                                todotitle: todoItem.task.name ?? '',
                              ),
                            )
                          : links.length == 2
                              ? Container(
                                  padding: EdgeInsets.all(8.0),
                                  child: Column(
                                    children: [
                                      LinkGenerator(
                                        file: links[0],
                                        sfid: sfid,
                                        sfuuid: sfuuid,
                                        role: role,
                                        todotitle: todoItem.task.name ?? '',
                                      ),
                                      LinkGenerator(
                                        file: links[1],
                                        sfid: sfid,
                                        sfuuid: sfuuid,
                                        role: role,
                                        todotitle: todoItem.task.name ?? '',
                                      ),
                                    ],
                                  ),
                                )
                              : Container(
                                  height: 95,
                                  padding: EdgeInsets.all(8.0),
                                  child: Scrollbar(
                                    child: ListView.builder(
                                        itemCount: links.length,
                                        itemBuilder: (ctx, ind) {
                                          return Container(
                                            margin:
                                                EdgeInsets.fromLTRB(0, 2, 0, 4),
                                            child: LinkGenerator(
                                                file: links[ind],
                                                sfid: sfid,
                                                sfuuid: sfuuid,
                                                role: role,
                                                todotitle:
                                                    todoItem.task.name ?? ''),
                                          );
                                        }),
                                  ),
                                )
                      : Container(),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.person),
                      Text(
                        "  ASSIGNEES",
                        style: montserratNormal,
                      ),
                    ],
                  ),
                  Container(
                      //padding: EdgeInsets.all(12),
                      height: 123,
                      width: device.width,
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: todoItem.task.asignee.length,
                        itemBuilder: (ctx, ind) {
                          var fullName =
                              todoItem.task.asignee[ind].asigneeName.split(" ");
                          var firstName =
                              fullName[0].trim().substring(0, 1).toUpperCase();
                          var lastName =
                              fullName[1].trim().substring(0, 1).toUpperCase();
                          var initial = firstName + lastName;
                          return Container(
                            //width: 80,
                            padding: const EdgeInsets.only(left: 8),
                            //margin: EdgeInsets.all(4),
                            child: Tooltip(
                              message: "${todoItem.task.taskStatus}",
                              preferBelow: false,
                              verticalOffset: 39,
                              waitDuration: Duration(seconds: 0),
                              textStyle: montserratNormal.copyWith(
                                  fontSize: 12, color: Colors.white),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                color: _getStatusToolBrColor(
                                    todoItem.task.taskStatus),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  ExcludeSemantics(
                                    child: ProfileIconTodo(
                                      initial: initial,
                                      img: todoItem.task.asignee[ind]
                                              .profilePicture ??
                                          '',
                                      height: 60,
                                      bgColor: _getStatusBrColor(
                                          todoItem.task.taskStatus),
                                    ),
                                  ),
                                  SizedBox(height: 4),
                                  Center(
                                    child: Text(
                                      todoItem.task.asignee[ind].asigneeName,
                                      style: roboto700.copyWith(
                                          color: defaultDark, fontSize: 14),
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ))
                ],
              ),
            ),
            SizedBox(
              height: 30,
            )
          ],
        ),
      );
    });
  }

  Color? _getStatusButtonColor(String status) {
    if (status == TodoStatus.Open.name) return openButtonColor;
    if (status == TodoStatus.Completed.name) return completedButtonColor;
    if (status == TodoStatus.Closed.name) return closedButtonColor;
  }

  Color _getStatusBrColor(String status) {
    if (status == TodoStatus.Open.name)
      return openOpac;
    else if (status == TodoStatus.Completed.name)
      return completedOpac;
    else
      return closedOpac;
  }

  Color _getStatusToolBrColor(String status) {
    if (status == TodoStatus.Open.name)
      return openOpacTool;
    else if (status == TodoStatus.Completed.name)
      return completedOpacTool;
    else
      return closedOpacTool;
  }
}
