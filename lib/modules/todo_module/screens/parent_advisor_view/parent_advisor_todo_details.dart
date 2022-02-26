import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/asignee_horizontal_list_view.dart';
import 'package:palette/common_components/todo_publish_button.dart';
import 'package:palette/modules/todo_module/bloc/draft_todo_publish_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_ad_bloc/todo_ad_bloc.dart';
import 'package:palette/utils/konstants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/asignee_horizontal_list_view.dart';
import 'package:palette/common_components/todo_acccept_reject_button.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_bloc.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_event.dart';
import 'package:palette/modules/todo_module/bloc/Parent_todo_bloc/todo_parent_state.dart';
import 'package:palette/modules/todo_module/bloc/todo_accept_reject_bloc/todo_accept_reject_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_ad_bloc/todo_ad_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/bloc/todo_event.dart';
import 'package:palette/modules/todo_module/bloc/todo_state.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_status.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/parent_advisor_todo_widgets/parent_advisor_edit_todo_form.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../widget/expandable_text.dart';
import '../../widget/file_resource_card_button.dart';
import '../../widget/link_generator.dart';

class ParentTodoDetailsScreen extends StatefulWidget {
  ParentTodoDetailsScreen({
    required this.todoItem,
    this.isRequestTab = false,
    this.isObserverAdmin = false,
    this.isGlobalTab = false,
  });
  final Todo todoItem;
  final bool isObserverAdmin;
  final bool isRequestTab;
  final bool isGlobalTab;

  @override
  _ParentTodoDetailsScreenState createState() =>
      _ParentTodoDetailsScreenState(todoItem: todoItem);
}

class _ParentTodoDetailsScreenState extends State<ParentTodoDetailsScreen> {
  Todo todoItem;
  _ParentTodoDetailsScreenState({required this.todoItem});
  List<Resources> resources = [];
  List<Resources> links = [];
  bool updateState = false;
  String? sfid;
  String? sfuuid;
  String? role;
  bool canUpdateStatus = true;
  late String status;

  void getResources() {
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
    _getSfidAndRole();

    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    final isRoleAdmin = pendoState.role.toLowerCase().startsWith('admin');
    print('isROleADmin: $isRoleAdmin');

    final isCreatedByMe =
        widget.todoItem.task.listedBy.id == pendoState.accountId;

    print('isCreatedByMe: $isCreatedByMe');

    if (widget.todoItem.task.todoScope == globalString) {
      if (isRoleAdmin || isCreatedByMe) {
        canUpdateStatus = true;
      } else {
        canUpdateStatus = false;
      }
    }
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
    print('widget.todoItem.task.id: ${widget.todoItem.task.id}');
    return BlocListener(
      listener: (context, state) {
        if (role?.toLowerCase() == 'admin') {
          /// IF USER IS ADMIN
          if (state is TodoPublishSuccessState) {
            ///RELOAD TøDO LIST
            Navigator.pop(context);
            Helper.showToast('Todo Published');

            final bloc = context.read<TodoAdminBloc>();
            bloc.add(
              FetchTodosAdminEvent(),
            );
          } else if (state is TodoPublishFailedState) {
            Helper.showToast('Failed to publish at the moment');
          }
        } else {
          if (state is TodoPublishSuccessState) {
            ///RELOAD TøDO LIST
            Navigator.pop(context);
            Helper.showToast('Todo Published');

            context.read<TodoParentAdvisorBloc>().add(FetchTodosParentEvent());
          } else if (state is TodoPublishFailedState) {
            Helper.showToast('Failed to publish at the moment');
          }
        }
      },
      bloc: context.read<DraftTodoPublishBloc>(),
      child: TodoPublishButton(todoId: widget.todoItem.task.id),
    );
  }
  Widget _bottomOptions(BuildContext context) {
    print('widget.todoItem.task.id: ${widget.todoItem.task.id}');
    return BlocListener(
      listener: (context, state) {
        if (role?.toLowerCase() == 'admin') {
          /// IF USER IS ADMIN
          if (state is TodoAcceptSuccessState) {
            ///RELOAD TøDO LIST
            Navigator.pop(context);
            Helper.showToast('Todo Accepted');

            final bloc = context.read<TodoAdminBloc>();
            bloc.add(
              FetchTodosAdminEvent(),
            );
          } else if (state is TodoAcceptFailedState) {
            Helper.showToast('Failed to udpate at the moment');
          }

          if (state is TodoRejectSuccessState) {
            ///RELOAD TøDO LIST
            Navigator.pop(context);
            Helper.showToast('Todo Rejected');

            final bloc = context.read<TodoAdminBloc>();
            bloc.add(
              FetchTodosAdminEvent(),
            );
          } else if (state is TodoRejectFailedState) {
            Helper.showToast('Failed to udpate at the moment');
          }
        } else {
          if (state is TodoAcceptSuccessState) {
            ///RELOAD TøDO LIST
            Navigator.pop(context);
            Helper.showToast('Todo Accepted');

            context.read<TodoParentAdvisorBloc>().add(FetchTodosParentEvent());
          } else if (state is TodoAcceptFailedState) {
            Helper.showToast('Failed to udpate at the moment');
          }

          if (state is TodoRejectSuccessState) {
            ///RELOAD TøDO LIST
            Navigator.pop(context);
            Helper.showToast('Todo Rejected');

            context.read<TodoParentAdvisorBloc>().add(FetchTodosParentEvent());
          } else if (state is TodoRejectFailedState) {
            Helper.showToast('Failed to udpate at the moment');
          }
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
    String status = widget.todoItem.isopen
        ? TodoStatus.Open.name
        : widget.todoItem.iscomp
            ? TodoStatus.Completed.name
            : widget.todoItem.task.taskStatus == TodoStatus.Draft.name
                ? TodoStatus.Draft.name
                : TodoStatus.Closed.name;
    String description = todoItem.task.description.toString();
    final device = MediaQuery.of(context).size;
    String event = todoItem.task.eventAt.toString();
    String venue = todoItem.task.venue.toString();
    return StatefulBuilder(builder: (context, stateSetter) {
      return BlocListener(
        listener: (context, state) {
          if (state is UpdateTodoParentLoadingState) updateState = true;
          if (state is UpdateTodoParentSuccessState) {
            context.read<TodoParentAdvisorBloc>().add(FetchTodosParentEvent());
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
                if (!widget.isRequestTab)
                  BlocBuilder<TodoBloc, TodoState>(
                    builder: (context, state) {
                      final selfSfid =
                          BlocProvider.of<PendoMetaDataBloc>(context)
                              .state
                              .accountId;
                      if (widget.todoItem.task.listedBy.id != selfSfid) {
                        return Container();
                      }
                      return widget.isObserverAdmin == true
                          ? Container()
                          : BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                              builder: (context, pendoState) {
                              return todoItem.task.todoScope == globalString
                                  ? Container()
                                  : MaterialButton(
                                      onPressed: () {
                                        TodoPendoRepo.trackTapOnEditTodoEvent(
                                            pendoState: pendoState,
                                            todoTitle:
                                                widget.todoItem.task.name ?? '',
                                            todoType:
                                                widget.todoItem.task.type ??
                                                    'Other',
                                            status: status);
                                        showModalBottomSheet(
                                                backgroundColor: Colors.white,
                                                context: context,
                                                isScrollControlled: true,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30),
                                                    topRight:
                                                        Radius.circular(30),
                                                  ),
                                                ),
                                                builder: (context) {
                                                  return TextScaleFactorClamper(
                                                    child: Padding(
                                                      padding: Platform.isIOS
                                                          ? MediaQuery.of(
                                                                  context)
                                                              .viewInsets
                                                          : EdgeInsets.zero,
                                                      child: Wrap(
                                                        children: [
                                                          Container(
                                                            height:
                                                                device.height *
                                                                    0.8,
                                                            decoration:
                                                                BoxDecoration(
                                                              color:
                                                                  Colors.white,
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .only(
                                                                topLeft: Radius
                                                                    .circular(
                                                                        30),
                                                                topRight: Radius
                                                                    .circular(
                                                                        30),
                                                              ),
                                                            ),
                                                            child:
                                                                ParentAdvisorEditTodoForm(
                                                              todoItem:
                                                                  todoItem,
                                                              selfSfid:
                                                                  pendoState
                                                                      .accountId,
                                                              fileRes:
                                                                  resources,
                                                              linkRes: links,
                                                              status: status,
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  );
                                                })
                                            .whenComplete(
                                                () => stateSetter(() {}));
                                      },
                                      child: Semantics(
                                        label: "Tap to edit todo",
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          padding: EdgeInsets.all(4),
                                          decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color:
                                                _getStatusButtonColor(status),
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
                      Builder(builder: (context) {
                        final createdAtDate =
                            DateTime.parse(todoItem.task.createdAt);

                        return Row(
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
                                    "LISTED BY",
                                    style: montserratBoldTextStyle.copyWith(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: defaultDark),
                                  ),
                                  if (todoItem.task.createdAt != null &&
                                      todoItem.task.createdAt != 'null')
                                    Text(
                                      createdAtDate.year == 9998
                                          ? "${todoItem.task.listedBy.name}"
                                          : " ${todoItem.task.listedBy.name} at ${DateFormat.jm().format(DateTime.parse(todoItem.task.createdAt.toString()).toLocal())}, ${DateFormat.yMMMd('en_US').format(DateTime.parse(todoItem.task.createdAt.toString()).toLocal())}",
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
                        );
                      }),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: widget.todoItem.isopen &&
                                !widget.isRequestTab &&
                                todoItem.task.completeBy.year != 9998
                            ? MainAxisAlignment.spaceEvenly
                            : MainAxisAlignment.start,
                        children: [
                          if (!widget.isRequestTab)
                            BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                                builder: (context, pendoState) {
                              return BlocBuilder<TodoBloc, TodoState>(
                                  builder: (context, state) {
                                return Semantics(
                                  label: status,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      textStyle: montserratNormal.copyWith(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: white),
                                      primary: widget.todoItem.task.approvalStatus == TodoStatus.Removed.name?red:_getStatusButtonColor(status),
                                    ),
                                    onPressed: status == TodoStatus.Draft.name || widget.todoItem.task.approvalStatus == TodoStatus.Removed.name
                                        ? () {}
                                        : () {
                                            /// UPDATE Tødø status BOTTOM SHEET
                                            TodoPendoRepo
                                                .trackTapOnUpdateTodoStatusEvent(
                                                    status: status,
                                                    todoTitle:
                                                        todoItem.task.name ??
                                                            '',
                                                    todoType:
                                                        todoItem.task.type ??
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
                                      // width: device.width * 0.30,
                                      child: Center(
                                        child: Text(
                                          widget.todoItem.task.approvalStatus == TodoStatus.Removed.name?widget.todoItem.task.approvalStatus!.toUpperCase():status.toUpperCase(),
                                          style: TextStyle(fontSize: 13),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              });
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
                                    file: resources[ind],
                                    gid: widget.todoItem.task.gid,
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
            AsigneeHorizontalListView(
              todoItem: widget.todoItem,
            ),
          ],
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
                      height: device.height / 2.7,
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
                                              tileColor: status == TodoStatus.Open.name
                                                  ? canUpdateStatus == false
                                                  ? openOpac.withOpacity(0.2)
                                                  : openOpac
                                                  : Colors.white,
                                              leading: SvgPicture.asset(
                                                "images/rectIcon.svg",
                                                color: canUpdateStatus == false
                                                    ? openOpac.withOpacity(0.7)
                                                    : openButtonColor,
                                              ),
                                              title: Text(
                                                'Open',
                                                style: darkTextFieldStyle.copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: canUpdateStatus == false
                                                        ? openOpac.withOpacity(0.7)
                                                        : openButtonColor),
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
                                                color: canUpdateStatus == false
                                                    ? completedOpac.withOpacity(0.7)
                                                    : completedButtonColor,
                                              ),
                                              tileColor: status == TodoStatus.Completed.name
                                                  ? canUpdateStatus == false
                                                  ? completedOpac.withOpacity(0.2)
                                                  : completedOpac
                                                  : Colors.white,
                                              title: Text(
                                                'Completed',
                                                style: darkTextFieldStyle.copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: canUpdateStatus == false
                                                        ? completedOpac.withOpacity(0.7)
                                                        : completedButtonColor),
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
                                                color: canUpdateStatus == false
                                                    ? closedOpac.withOpacity(0.7)
                                                    : closedButtonColor,
                                              ),
                                              tileColor: status == TodoStatus.Closed.name
                                                  ? canUpdateStatus == false
                                                  ? closedOpac.withOpacity(0.2)
                                                  : closedOpac
                                                  : Colors.white,
                                              title: new Text(
                                                'Closed',
                                                style: darkTextFieldStyle.copyWith(
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w700,
                                                    color: canUpdateStatus == false
                                                        ? closedOpac.withOpacity(0.7)
                                                        : closedButtonColor),
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
