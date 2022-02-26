import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/asignee_horizontal_list_view.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/common_components/text_area.dart';
import 'package:palette/common_components/todo_acccept_reject_button.dart';
import 'package:palette/common_components/todo_publish_button.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/explore_module/widgets/common_textbox_opportunity.dart';
import 'package:palette/modules/todo_module/bloc/draft_todo_publish_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bloc/todo_accept_reject_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_event.dart';
import 'package:palette/modules/todo_module/bloc/todo_state.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_status.dart';
import 'package:palette/modules/todo_module/models/ward.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/edit_todo_form.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

import '../widget/expandable_text.dart';
import '../widget/file_resource_card_button.dart';
import '../widget/link_generator.dart';

class TodoDetailsScreen extends StatefulWidget {
  TodoDetailsScreen({
    required this.todoItem,
    required this.studentId,
    this.isRequestTab = false,
    this.isGlobalTab = false,
    this.stdId,
    this.wards,
    this.isParent = false,
  });
  final Todo todoItem;
  final String studentId;
  final String? stdId;
  final bool isParent;
  final List<Ward>? wards;
  final bool isRequestTab;
  final bool isGlobalTab;

  @override
  _TodoDetailsScreenState createState() => _TodoDetailsScreenState();
}

class _TodoDetailsScreenState extends State<TodoDetailsScreen> {
  late Todo todoItem;
  List<Resources> resources = [];
  List<Resources> links = [];
  bool updateState = false;
  bool checkforback = false;
  bool canUpdateStatus = true;

  void getResources() {
    todoItem = widget.todoItem;
    status = todoItem.task.taskStatus;
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

    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    final isRoleAdmin = pendoState.role.toLowerCase().startsWith('admin');
    final isCreatedByMe =
        widget.todoItem.task.listedBy.id == pendoState.accountId;

    if (widget.todoItem.task.todoScope == globalString) {
      if (isRoleAdmin || isCreatedByMe) {
        canUpdateStatus = true;
      } else {
        canUpdateStatus = false;
      }
    }
  }

  late String status;

  @override
  Widget build(BuildContext context) {
    final device = MediaQuery.of(context).size;
    return WillPopScope(
      onWillPop: () async {
        log("Updated status is:$status");
        return true;
      },
      child: SafeArea(
        child: Scaffold(
          backgroundColor: Colors.white,
          // appBar: AppBar(),
          body: TextScaleFactorClamper(
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
                if (status == TodoStatus.Draft.name)
                  Positioned(
                      left: 0,
                      bottom: 20,
                      right: 0,
                      child: _publishOptions(context)),
                if (widget.isRequestTab)
                  Positioned(
                      left: 0,
                      bottom: 20,
                      right: 0,
                      child: _bottomOptions(context)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _publishOptions(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        if (state is TodoPublishSuccessState) {
          ///RELOAD TøDO LIST
          Navigator.pop(context);
          Helper.showToast('Todo Published');

          final bloc = context.read<TodoListBloc>();
          bloc.add(
            TodoListEvent(studentId: ''),
          );
        } else if (state is TodoPublishFailedState) {
          Helper.showToast('Failed to publish at the moment');
        }
      },
      bloc: context.read<DraftTodoPublishBloc>(),
      child: TodoPublishButton(todoId: widget.todoItem.task.id),
    );
  }

  Widget _bottomOptions(BuildContext context) {
    return BlocListener(
      listener: (context, state) {
        if (state is TodoAcceptSuccessState) {
          ///RELOAD TøDO LIST
          Navigator.pop(context);
          Helper.showToast('Todo Accepted');

          final bloc = context.read<TodoListBloc>();
          bloc.add(
            TodoListEvent(studentId: ''),
          );
        } else if (state is TodoAcceptFailedState) {
          Helper.showToast('Failed to update at the moment');
        }

        if (state is TodoRejectSuccessState) {
          ///RELOAD TøDO LIST
          Navigator.pop(context);
          Helper.showToast('Todo Rejected');

          final bloc = context.read<TodoListBloc>();
          bloc.add(
            TodoListEvent(studentId: ''),
          );
        } else if (state is TodoRejectFailedState) {
          Helper.showToast('Failed to update at the moment');
        }
      },
      bloc: context.read<TodoAcceptRejectBloc>(),
      child: TodoAcceptRejectButton(todoId: widget.todoItem.task.id),
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
    } else if (type == 'Employment') {
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
    status = todoItem.task.taskStatus;
    String description = todoItem.task.description.toString();
    final device = MediaQuery.of(context).size;
    String event = (todoItem.task.eventAt).toString();
    return StatefulBuilder(builder: (context, stateSetter) {
      return BlocListener(
        listener: (context, state) {
          if (state is UpdateTodoLoadingState) updateState = true;
          if (state is UpdateTodoStatusLoadingState)
            checkforback = true;
          else
            checkforback = false;
          if (updateState && state is TodoListSuccessState) {
            setState(() {});
            updateState = false;
          }
        },
        bloc: context.read<TodoBloc>(),
        child: WillPopScope(
          onWillPop: () async {
            log("WIllPop Scoped");
            if (checkforback)
              BlocProvider.of<TodoListBloc>(context)
                  .add(TodoListEvent(studentId: widget.studentId));
            return true;
          },
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  BlocBuilder<TodoBloc, TodoState>(builder: (context, state) {
                    return Semantics(
                      onTapHint: "Navigated back",
                      button: true,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 8.0, top: 2),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: Semantics(
                            label: "Button to navigate back to todo list",
                            child: IgnorePointer(
                              ignoring: state is UpdateTodoStatusLoadingState,
                              child: BlocBuilder<PendoMetaDataBloc,
                                      PendoMetaDataState>(
                                  builder: (context, pendoState) {
                                return IconButton(
                                  icon: RotatedBox(
                                      quarterTurns: 1,
                                      child: SvgPicture.asset(
                                        'images/dropdown.svg',
                                        color: defaultDark,
                                      )),
                                  color: defaultDark,
                                  onPressed: () async {
                                    log("Current Status is:$status");
                                    if (checkforback)
                                      BlocProvider.of<TodoListBloc>(context)
                                          .add(TodoListEvent(
                                              studentId: widget.studentId));
                                    TodoPendoRepo.trackTapOnBackEvent(
                                        status: status,
                                        todoTitle: todoItem.task.name ?? '',
                                        todoType: todoItem.task.type ?? 'Other',
                                        pendoState: pendoState);
                                    Navigator.pop(context, status);
                                  },
                                );
                              }),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                  if (!widget.isParent)
                    Builder(
                      builder: (context) {
                        print('widget.stdId: ${widget.stdId}');
                        print(
                            'todoItem.task.listedBy.id: ${todoItem.task.listedBy.id}');
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            if (widget.stdId != null &&
                                widget.stdId! == todoItem.task.listedBy.id)
                              BlocBuilder<PendoMetaDataBloc,
                                      PendoMetaDataState>(
                                  builder: (context, pendoState) {
                                return MaterialButton(
                                  onPressed: () {
                                    TodoPendoRepo.trackTapOnEditTodoEvent(
                                        status: status,
                                        todoTitle: todoItem.task.name ?? '',
                                        todoType: todoItem.task.type ?? 'Other',
                                        pendoState: pendoState);
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
                                                child: Wrap(
                                                  children: [
                                                    Container(
                                                      height:
                                                          device.height * 0.8,
                                                      decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  30),
                                                          topRight:
                                                              Radius.circular(
                                                                  30),
                                                        ),
                                                      ),
                                                      child: EditTodoForm(
                                                        todoItem: todoItem,
                                                        fileRes: resources,
                                                        selfSfid: pendoState
                                                            .accountId,
                                                        linkRes: links,
                                                        todostatus: status,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              );
                                            })
                                        .whenComplete(() => stateSetter(() {}));
                                  },
                                  child: Semantics(
                                    onTapHint: "Edit",
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
                              }),
                            const SizedBox(width: 20),
                          ],
                        );
                      },
                    ),
                ],
              ),
              Container(
                padding: EdgeInsets.fromLTRB(18, 10, 18, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 30),
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
                        SizedBox(height: 10),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            SvgPicture.asset(
                              "images/listed_by_todo_icon.svg",
                              width: 18.0,
                              height: 18.0,
                            ),
                            SizedBox(width: 6),
                            Builder(builder: (context) {
                              final createdAtDate =
                                  DateTime.parse(todoItem.task.createdAt);
                              return Container(
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
                                    if (todoItem.task.createdAt != null &&
                                        todoItem.task.createdAt != 'null' &&
                                        (todoItem.task.createdAt).isNotEmpty)
                                      Text(
                                        createdAtDate.year == 9998
                                            ? "${todoItem.task.listedBy.name}"
                                            : " ${todoItem.task.listedBy.name} at ${DateFormat.jm().format(DateTime.parse(todoItem.task.createdAt.toString()).toLocal())}, ${DateFormat.yMMMd('en_US').format(DateTime.parse(todoItem.task.createdAt.toString()).toLocal())}",
                                        style: montserratBoldTextStyle.copyWith(
                                            fontSize: 12,
                                            fontWeight: FontWeight.w700,
                                            color: defaultDark),
                                      ),
                                  ],
                                ),
                              );
                            }),
                          ],
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment:
                              todoItem.task.taskStatus == 'open' &&
                                      !widget.isRequestTab &&
                                      todoItem.task.completeBy.year != 9998
                                  ? MainAxisAlignment.spaceEvenly
                                  : MainAxisAlignment.start,
                          children: [
                            if (!widget.isRequestTab)
                              BlocBuilder<TodoBloc, TodoState>(
                                  builder: (context, state) {
                                return Semantics(
                                  onTapHint: "Update status",
                                  label: "",
                                  child: IgnorePointer(
                                    ignoring:
                                        state is UpdateTodoStatusLoadingState,
                                    child: BlocBuilder<PendoMetaDataBloc,
                                            PendoMetaDataState>(
                                        builder: (context, pendoState) {
                                      return ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          textStyle: montserratNormal.copyWith(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w700,
                                              color: white),
                                          primary:
                                          widget.todoItem.task.approvalStatus == TodoStatus.Removed.name?red:_getStatusButtonColor(status),
                                          //fixedSize: Size(145, 42),
                                        ),
                                        onPressed: widget.studentId != '' ||
                                                status == TodoStatus.Draft.name || widget.todoItem.task.approvalStatus == TodoStatus.Removed.name
                                            ? () {
                                                print(
                                                    'widget.studentId : ${widget.studentId}');
                                              }
                                            : () {
                                                print(
                                                    'widget.studentId : ${widget.studentId}');
                                                TodoPendoRepo
                                                    .trackTapOnUpdateTodoStatusEvent(
                                                        status: status,
                                                        todoTitle: todoItem
                                                                .task.name ??
                                                            '',
                                                        todoType: todoItem
                                                                .task.type ??
                                                            'Other',
                                                        pendoState: pendoState);
                                                _showStatusBottomSheet(
                                                    status, device, (String s) {
                                                  stateSetter(() {
                                                    status = s;
                                                  });
                                                });
                                              },
                                        child: SizedBox(
                                          width: device.width * 0.31,
                                          child: state
                                                  is UpdateTodoStatusLoadingState
                                              ? Center(
                                                  child: SpinKitChasingDots(
                                                    color: Colors.white,
                                                    size: 20,
                                                  ),
                                                )
                                              : Center(
                                                  child: Text(
                                                    widget.todoItem.task.approvalStatus == TodoStatus.Removed.name?widget.todoItem.task.approvalStatus!.toUpperCase():status.toUpperCase(),
                                                    style:
                                                        TextStyle(fontSize: 13),
                                                    overflow: TextOverflow.fade,
                                                    maxLines: 2,
                                                    semanticsLabel:
                                                        "$status. Tap to update status",
                                                  ),
                                                ),
                                        ),
                                      );
                                    }),
                                  ),
                                );
                              }),
                            const SizedBox(width: 10),
                            status.toLowerCase() == 'open'
                                ? todoItem.task.completeBy.year == 9998
                                    ? Container()
                                    : Container(
                                        width: device.width * 0.46,
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ' COMPLETE BY',
                                              style: montserratNormal.copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w700,
                                                  color: defaultDark),
                                            ),
                                            Text(
                                              " ${DateFormat.jm().format(todoItem.task.completeBy.toLocal())},${DateFormat.yMMMd('en_US').format(todoItem.task.completeBy.toLocal())}",
                                              style: montserratNormal.copyWith(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w700,
                                                  color: defaultDark),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ],
                                        ),
                                      )
                                : Container()
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 30),
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
                              crossAxisAlignment: WrapCrossAlignment.center,
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
                                    style: montserratNormal.copyWith(
                                        fontSize: 16)),
                                Text(
                                    " ${DateFormat.yMMMd('en_US').format(DateTime.parse(event).toLocal())}",
                                    style:
                                        montserratNormal.copyWith(fontSize: 16))
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
                                      style: montserratNormal.copyWith(
                                          fontSize: 16),
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
                      BlocBuilder<TodoBloc, TodoState>(
                          builder: (context, state) {
                        return ExpandableText("$description", status);
                      }),
                    const SizedBox(
                      height: 30,
                    ),
                    AsigneeHorizontalListView(todoItem: todoItem),
                    const SizedBox(
                      height: 20,
                    ),
                    Visibility(
                      visible: resources.isNotEmpty,
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'images/resources.svg',
                            color: defaultDark,
                          ),
                          SizedBox(width: 6),
                          Text(" Resources")
                        ],
                      ),
                    ),
                    SizedBox(
                      height: resources.isNotEmpty ? 30 : 10,
                    ),
                    Visibility(
                      visible: resources.isNotEmpty,
                      child: Container(
                        height: 125,
                        padding: EdgeInsets.all(6),
                        child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: resources.length,
                            itemBuilder: (ctx, ind) {
                              return Padding(
                                padding: const EdgeInsets.only(right: 10),
                                child: FileResourceCardButton(
                                  gid: widget.todoItem.task.gid,
                                  file: resources[ind],
                                  todotitle: todoItem.task.name ?? '',
                                ),
                              );
                            }),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    links.isNotEmpty
                        ? Row(
                            children: [
                              SvgPicture.asset(
                                'images/globalLink.svg',
                                color: defaultDark,
                              ),
                              SizedBox(width: 6),
                              Text(" Links"),
                            ],
                          )
                        : SizedBox(),
                    const SizedBox(
                      height: 10,
                    ),
                    links.isNotEmpty
                        ? Builder(builder: (context) {
                            List<Widget> _children = [];
                            links.forEach((link) {
                              _children.add(LinkGenerator(
                                  file: link,
                                  todotitle: todoItem.task.name ?? ''));
                            });
                            return Container(
                              padding: EdgeInsets.all(8.0),
                              child: Column(
                                children: _children,
                              ),
                            );
                          })
                        : Container(),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              )
            ],
          ),
        ),
      );
    });
  }

  _showStatusBottomSheet(
      String status, Size device, Function callBackToChangeStatus) {
    String selectedStatus = '';
    TextEditingController textAreaController = TextEditingController();
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
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: TextScaleFactorClamper(
              child: IgnorePointer(
                ignoring: canUpdateStatus == false,
                child: StatefulBuilder(
                  builder: (context, setState) {
                    return Container(
                      // height: device.height / 2.7,
                      child: SingleChildScrollView(
                        physics: RangeMaintainingScrollPhysics(),
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: canUpdateStatus
                                  ? EdgeInsets.all(8.0)
                                  : EdgeInsets.fromLTRB(
                                      20,
                                      10,
                                      20,
                                      10,
                                    ),
                              child: Text(
                                canUpdateStatus
                                    ? "UPDATE STATUS"
                                    : "You cannot update the status of a global to-do",
                                style: montserratBoldTextStyle.copyWith(
                                  fontSize: canUpdateStatus ? 24 : 17,
                                  fontWeight: FontWeight.w900,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            SizedBox(height: 10),
                            BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                                builder: (context, pendoState) {
                              return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Visibility(
                                    visible: selectedStatus == '' ||
                                        selectedStatus == TodoStatus.Open.name,
                                    child: Semantics(
                                      label: "Update to open status",
                                      child: ExcludeSemantics(
                                        child: ListTile(
                                          tileColor: canUpdateStatus == false
                                              ? Colors.black.withOpacity(0.1)
                                              : status == TodoStatus.Open.name
                                                  ? openOpac
                                                  : Colors.white,
                                          leading: SvgPicture.asset(
                                            "images/rectIcon.svg",
                                            color: openButtonColor,
                                          ),
                                          title: Text(
                                            'Open',
                                            style: darkTextFieldStyle.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: openButtonColor),
                                          ),
                                          onTap: () async {
                                            selectedStatus =
                                                TodoStatus.Open.name;
                                            status = TodoStatus.Open.name;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selectedStatus == '' ||
                                        selectedStatus ==
                                            TodoStatus.Completed.name,
                                    child: Semantics(
                                      label: "Update to completed status",
                                      child: ExcludeSemantics(
                                        child: ListTile(
                                          leading: SvgPicture.asset(
                                            "images/rectIcon.svg",
                                            color: completedButtonColor,
                                          ),
                                          tileColor: canUpdateStatus == false
                                              ? Colors.black.withOpacity(0.1)
                                              : status ==
                                                      TodoStatus.Completed.name
                                                  ? completedOpac
                                                  : Colors.white,
                                          title: Text(
                                            'Completed',
                                            style: darkTextFieldStyle.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: completedButtonColor),
                                          ),
                                          onTap: () async {
                                            status = TodoStatus.Completed.name;
                                            selectedStatus =
                                                TodoStatus.Completed.name;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selectedStatus == '' ||
                                        selectedStatus ==
                                            TodoStatus.Closed.name,
                                    child: Semantics(
                                      label: "Update to closed status",
                                      child: ExcludeSemantics(
                                        child: ListTile(
                                          leading: SvgPicture.asset(
                                            "images/rectIcon.svg",
                                            color: closedButtonColor,
                                          ),
                                          tileColor: canUpdateStatus == false
                                              ? Colors.black.withOpacity(0.1)
                                              : status == TodoStatus.Closed.name
                                                  ? closedOpac
                                                  : Colors.white,
                                          title: new Text(
                                            'Closed',
                                            style: darkTextFieldStyle.copyWith(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w700,
                                                color: closedButtonColor),
                                          ),
                                          onTap: () async {
                                            status = TodoStatus.Closed.name;
                                            selectedStatus =
                                                TodoStatus.Closed.name;
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                  Visibility(
                                    visible: selectedStatus != '',
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: TextField(
                                              controller: textAreaController,
                                              decoration: InputDecoration(
                                                border: InputBorder.none,
                                                hintText:
                                                    'Enter note... (optional)',
                                                hintStyle:
                                                    robotoTextStyle.copyWith(
                                                        color: defaultDark),
                                              ),
                                            ),
                                            height: 125,
                                            color: Color(0xFFFAFAFA),
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          children: [
                                            MaterialButton(
                                              onPressed: () {
                                                selectedStatus = '';
                                                setState((){});
                                              },
                                              shape: RoundedRectangleBorder(
                                                  side: BorderSide(color: _getStatusButtonColor(selectedStatus),width: 2),
                                                  borderRadius: BorderRadius.circular(20)),
                                              child: Text("CANCEL",style: darkTextFieldStyle.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: _getStatusButtonColor(selectedStatus))),
                                            ),
                                            MaterialButton(
                                              color: _getStatusButtonColor(selectedStatus),
                                              onPressed: () {
                                                TodoPendoRepo.trackTodoStatusChange(
                                                    todoId: widget.todoItem.task
                                                        .asignee[0].todoId,
                                                    status: selectedStatus,
                                                    todoTitle:
                                                    widget.todoItem.task.name ??
                                                        '',
                                                    todoType:
                                                    widget.todoItem.task.type ??
                                                        'Other',
                                                    pendoState: pendoState);

                                                callBackToChangeStatus(selectedStatus);
                                                BlocProvider.of<TodoBloc>(context).add(
                                                  UpdateTodoStatusEvent(
                                                      taskId: widget
                                                          .todoItem.task.id,
                                                      status: selectedStatus,
                                                  note: textAreaController.text.trim()),
                                                );
                                                Navigator.pop(context);
                                              },
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(20)),
                                              child: Text("DONE",style: darkTextFieldStyle.copyWith(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.w500,
                                                  color: Colors.white)),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  )
                                ],
                              );
                            }),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          );
        });
  }

  Color _getStatusButtonColor(String status) {
    if (status == TodoStatus.Open.name) return openButtonColor;
    if (status == TodoStatus.Completed.name) return completedButtonColor;
    if (status == TodoStatus.Closed.name) return closedButtonColor;
    if (status == TodoStatus.Draft.name) return greyishGrey;
    return openButtonColor;
  }
}
