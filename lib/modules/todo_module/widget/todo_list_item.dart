import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/institute_logo.dart';
import 'package:palette/common_components/selected_tick_icon.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/models/todo_list_response.dart';
import 'package:palette/modules/todo_module/models/todo_status.dart';
import 'package:palette/modules/todo_module/models/ward.dart';
import 'package:palette/modules/todo_module/screens/parent_advisor_view/parent_advisor_todo_details.dart';
import 'package:palette/modules/todo_module/screens/todo_details_screen.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/circle_icon_image_todo.dart';
import 'package:palette/utils/date_time_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class TodoListItemWidget extends StatefulWidget {
  final Todo todo;
  final String imageLoc;
  final Color grad1;
  final bool isRequestTab;
  final bool isByMeTab;
  final Color grad2;
  final Color iconBackground;
  final String studentId;
  final String? stdId;
  final bool isParent;
  List<Ward>? asignee;
  bool calledFromAdvisorParent;
  bool isObserverAdmin;
  Function onLongPress;
  Function inSelectModeCallBack;
  bool inSelectMode;

  TodoListItemWidget({
    required this.todo,
    this.isRequestTab = false,
    required this.grad1,
    required this.grad2,
    required this.imageLoc,
    required this.iconBackground,
    required this.studentId,
    required this.isByMeTab,
    this.inSelectMode = false,
    this.isParent = false,
    this.stdId,
    this.asignee,
    required this.calledFromAdvisorParent,
    this.isObserverAdmin = false,
    required this.onLongPress,
    required this.inSelectModeCallBack,
  });
  @override
  _TodoListItemWidgetState createState() => _TodoListItemWidgetState();
}

// final
class _TodoListItemWidgetState extends State<TodoListItemWidget> {
  String? sfid;
  String? sfuuid;
  String? role;
  Color? color = Colors.white;

  @override
  void initState() {
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

    DateTime date = DateTime.now();
    bool isOverdue = date.isAfter(widget.todo.task.completeBy);
    color = isOverdue && widget.todo.isopen
        ? openedContainer
        : widget.todo.isopen
            ? _getStatusButtonColor(TodoStatus.Open.name)
            : widget.todo.iscomp
                ? _getStatusButtonColor(TodoStatus.Completed.name)
                : isOverdue &&
                        widget.todo.task.taskStatus == TodoStatus.Open.name
                    ? openedContainer
                    : _getStatusButtonColor(widget.todo.task.taskStatus);

    if (widget.isRequestTab || widget.isByMeTab) color = Colors.white;

    final _selectedDecoration = BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(12)),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 2),
          blurRadius: 8,
          color: Colors.black.withOpacity(0.08),
        )
      ],
      color: color,
    );
    String status = widget.todo.isopen
        ? TodoStatus.Open.name
        : widget.todo.iscomp
            ? TodoStatus.Completed.name
            : TodoStatus.Closed.name;
    return TextScaleFactorClamper(
      maxScaleFactor: 1.3,
      child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        return GestureDetector(
          onLongPress: () {
            setState(() {
              widget.onLongPress();
            });
          },
          onTap: () {
            if (widget.inSelectMode) {
              widget.inSelectModeCallBack();
              return;
            }

            TodoPendoRepo.trackTodoDetailViewEvent(
                status: status,
                todoTitle: widget.todo.task.name ?? '',
                todoType: widget.todo.task.type ?? 'Other',
                pendoState: pendoState);
            String initialStatus = widget.todo.task.taskStatus;
            if (widget.calledFromAdvisorParent) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentTodoDetailsScreen(
                    todoItem: widget.todo,
                    isObserverAdmin: widget.isObserverAdmin,
                    isRequestTab: widget.isRequestTab,
                    isGlobalTab: widget.isByMeTab,
                  ),
                ),
              ).then((value) {
                if (initialStatus != value) {
                  BlocProvider.of<TodoListBloc>(context)
                    ..add(TodoListEvent(studentId: widget.studentId));
                }
              });
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoDetailsScreen(
                    todoItem: widget.todo,
                    studentId: widget.studentId,
                    isRequestTab: widget.isRequestTab,
                    isParent: widget.isParent,
                    isGlobalTab: widget.isByMeTab,
                    stdId: widget.stdId,
                    wards: widget.asignee,
                  ),
                ),
              ).then((value) {
                if (initialStatus != value) {
                  BlocProvider.of<TodoListBloc>(context)
                    ..add(TodoListEvent(studentId: widget.studentId));
                }
              });
            }
          },
          child: Stack(
            children: [
              _item(
                selectedDecoration: _selectedDecoration,
                isOverdue: isOverdue,
                size: device,
                status: status,
              ),
              if (widget.todo.isSelected)
                Positioned(
                  left: 8,
                  top: 0,
                  child: SelectedTickMarkIcon(),
                ),
              Builder(builder: (context) {
                if (widget.isByMeTab) {
                  if (widget.todo.task.todoScope == globalString) {
                    final status =
                        widget.todo.task.approvalStatus?.toUpperCase() ?? '';
                    final color = status.startsWith('IN')
                        ? uploadIconButtonColor
                        : status.startsWith('NOT')
                            ? red
                            : green;

                    return Positioned(
                        right: widget.todo.isSelected ? 34 : 28,
                        bottom: widget.todo.isSelected ? 22 : 16,
                        child: Text(
                          status,
                          style: montserratNormal.copyWith(
                            fontSize: 14,
                            color: color,
                          ),
                        ));
                  }
                }
                return Container();
              }),
            ],
          ),
        );
      }),
    );
  }

  Widget _item({
    required BoxDecoration selectedDecoration,
    required bool isOverdue,
    required Size size,
    required String status,
  }) {
    return Container(
      margin: widget.todo.isSelected
          ? EdgeInsets.symmetric(horizontal: 20, vertical: 10)
          : null,
      decoration: widget.todo.isSelected
          ? selectedDecoration
          : BoxDecoration(color: color),
      height: widget.todo.isSelected ? 130.61 : 160.61,
      child: ConstrainedBox(
        constraints: BoxConstraints(),
        child: Row(
          children: [
            TextScaleFactorClamper(
              maxScaleFactor: 1.13,
              child: Container(
                padding: EdgeInsets.only(left: 15),
                width: size.width / 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    TextScaleFactorClamper(
                        maxScaleFactor: 1.04, child: _getTypeText()),
                    Text(
                      widget.todo.task.completeBy.year == 9998
                          ? "No Due Date"
                          : "${DateTimeUtils.getMonthAndDate(widget.todo.task.completeBy.toLocal())},\n${(widget.todo.task.completeBy.year)}",
                      style: montserratNormal.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: widget.todo.isSelected ? 13 : 15),
                    ),
                    widget.todo.task.completeBy.year == 9998
                        ? Container()
                        : Padding(
                            padding: const EdgeInsets.only(top: 4.0),
                            child: Builder(builder: (context) {
                              return Text(
                                "${DateTimeUtils.getTime(widget.todo.task.completeBy.toLocal())}",
                                style: montserratNormal.copyWith(
                                    fontSize: widget.todo.isSelected ? 13 : 15),
                              );
                            }),
                          ),
                    if ((isOverdue &&
                            widget.todo.task.taskStatus ==
                                TodoStatus.Open.name) ||
                        (isOverdue && widget.todo.isopen))
                      SizedBox(
                        height: 10,
                      ),
                    Builder(builder: (context) {
                      if (widget.isRequestTab || widget.isByMeTab)
                        return Container();
                      if ((isOverdue &&
                              widget.todo.task.taskStatus ==
                                  TodoStatus.Open.name) ||
                          (isOverdue && widget.todo.isopen))
                        return TextScaleFactorClamper(
                          maxScaleFactor: 1.04,
                          child: Text(
                            "Overdue",
                            style: montserratNormal.copyWith(
                                color: todoTypeTextColor, fontSize: 13),
                          ),
                        );

                      return Container();
                    }),
                  ],
                ),
              ),
            ),
            // SizedBox(
            //   width: 8,
            // ),
            Container(
              width: 25,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: widget.todo.isSelected ? 23.8 : 38.8,
                    width: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0, 0),
                        end: Alignment(0, -1),
                        colors: [
                          widget.grad1,
                          widget.grad2,
                        ],
                      ),
                    ),
                  ),

                  Builder(builder: (context) {
                    final assigneeIds =
                        widget.todo.task.asignee.map((e) => e.id).toList();
                    final pendoState =
                        BlocProvider.of<PendoMetaDataBloc>(context).state;
                    final createdForMe =
                        assigneeIds.contains(pendoState.accountId);

                    if (widget.todo.task.todoScope == globalString) {
                      return Container(
                        height: 28,
                        width: 28,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          color: Colors.transparent,
                        ),
                        child: InstituteLogo(radius: 12),
                      );
                    }

                    if (createdForMe) {
                      return Container(
                        height: 28,
                        width: 28,
                        padding: EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          color: widget.iconBackground,
                        ),
                        child: SvgPicture.asset(
                          widget.imageLoc,
                          fit: BoxFit.contain,
                        ),
                      );
                    } else {
                      return widget.todo.task.asignee.length == 1
                          ? Container(
                              height: 28,
                              width: 38,
                              child: Center(
                                child: CircleIcon(
                                  child: CachedNetworkImage(
                                    imageUrl: widget.todo.task.asignee[0]
                                            .profilePicture ??
                                        '',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
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
                                        CircleAvatar(
                                            radius: 5,
                                            backgroundColor: defaultDark,
                                            child: CircleAvatar(
                                                radius: 10,
                                                backgroundColor: Colors.white,
                                                child: Icon(
                                                  Icons.person,
                                                  color: defaultDark,
                                                  size: 15,
                                                ))),
                                  ),
                                ),
                              ),
                            )
                          : Center(
                              child: Container(
                                height: 28,
                                width: 38,
                                child: Center(
                                  child: Stack(
                                    children: [
                                      Positioned(
                                        left: 0,
                                        child: CircleIcon(
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                    .todo
                                                    .task
                                                    .asignee[1]
                                                    .profilePicture ??
                                                '',
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: 65,
                                              height: 65,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                CircleAvatar(
                                                    radius:
                                                        // widget.screenHeight <= 736 ? 35 :
                                                        29,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget: (context, url,
                                                    error) =>
                                                CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor:
                                                        defaultDark,
                                                    child: CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.person,
                                                          color: defaultDark,
                                                          size: 18,
                                                        ))),
                                          ),
                                        ),
                                      ),
                                      Positioned(
                                        left: 10,
                                        child: CircleIcon(
                                          child: CachedNetworkImage(
                                            imageUrl: widget
                                                    .todo
                                                    .task
                                                    .asignee[0]
                                                    .profilePicture ??
                                                '',
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              width: 65,
                                              height: 65,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                CircleAvatar(
                                                    radius:
                                                        // widget.screenHeight <= 736 ? 35 :
                                                        29,
                                                    backgroundColor:
                                                        Colors.white,
                                                    child:
                                                        CircularProgressIndicator()),
                                            errorWidget: (context, url,
                                                    error) =>
                                                CircleAvatar(
                                                    radius: 5,
                                                    backgroundColor:
                                                        defaultDark,
                                                    child: CircleAvatar(
                                                        radius: 12,
                                                        backgroundColor:
                                                            Colors.white,
                                                        child: Icon(
                                                          Icons.person,
                                                          color: defaultDark,
                                                          size: 18,
                                                        ))),
                                          ),
                                        ),
                                      ),
                                      if (widget.todo.task.asignee.length > 2)
                                        Positioned(
                                          right: 0,
                                          top: 0,
                                          child: Container(
                                            padding: EdgeInsets.all(2),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              color: pinkRed,
                                            ),
                                            child: Text(
                                              "+${widget.todo.task.asignee.length - 2}",
                                              style: montserratNormal.copyWith(
                                                  color: Colors.white,
                                                  fontSize: 6),
                                            ),
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                    }
                  }),

                  // if (!widget.isParent || !widget.calledFromAdvisorParent)

                  Container(
                    height: widget.todo.isSelected ? 78.8 : 93.8,
                    width: 4,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0, -1),
                        end: Alignment(0, 0),
                        colors: [
                          widget.grad1,
                          widget.grad2,
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // SizedBox(
            //   width: 10,
            // ),
            Expanded(
              // padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 15,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(
                      "${widget.todo.task.name}",
                      style: montserratNormal.copyWith(
                          fontSize: widget.todo.isSelected ? 14 : 16),
                      maxLines: 2,
                    ),
                  ),
                  if (widget.todo.task.venue != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Row(
                        children: [
                          SvgPicture.asset(
                            'images/place.svg',
                            width: 18,
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Flexible(
                            child: Container(
                              child: Text(
                                "${widget.todo.task.venue}",
                                style: montserratNormal.copyWith(fontSize: 10),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Builder(builder: (context) {
                        List<Resources> links = [];
                        List<Resources> resources = [];
                        widget.todo.todoResources.forEach((e) {
                          if (e.type == "Link")
                            links.add(e);
                          else
                            resources.add(e);
                        });
                        return Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            //widget.todo.todoResources == null?Container():
                            SizedBox(
                              width: 8,
                            ),
                            resources.isNotEmpty
                                ? SvgPicture.asset(
                                    'images/file.svg',
                                    width: 18,
                                  )
                                : SizedBox(),
                            resources.isNotEmpty
                                ? SizedBox(
                                    width: 10,
                                  )
                                : SizedBox(),
                            links.isNotEmpty
                                ? Icon(
                                    Icons.link,
                                    size: 18,
                                  )
                                : SizedBox(),
                          ],
                        );
                      }),
                      Builder(builder: (context) {
                        if (widget.isRequestTab) {
                          return Container();
                        } else if (widget.isByMeTab) {
                          /// Global Tab
                          // return Container();
                          return Container();
                        } else {
                          final role =
                              BlocProvider.of<PendoMetaDataBloc>(context)
                                  .state
                                  .role;
                          return Container(
                            padding: EdgeInsets.only(right: 15.0),
                            // width: 150,
                            child: Text(
                              role.toLowerCase().contains('student')
                                  ? widget.todo.task.taskStatus.toUpperCase()
                                  : status.toUpperCase(),
                              style: montserratBoldTextStyle.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: _getStatusColor(
                                      widget.todo.isopen || widget.todo.iscomp
                                          ? status
                                          : widget.todo.task.taskStatus),
                                  fontSize: widget.todo.isSelected ? 13 : 15),
                            ),
                          );
                        }
                      }),
                    ],
                  ),
                  SizedBox(
                    height: 10,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  Color? _getStatusButtonColor(String status) {
    if (status == TodoStatus.Open.name) return white;
    if (status == TodoStatus.Completed.name) return completedContainer;
    if (status == TodoStatus.Closed.name) return closedContainer;
  }

  Color? _getStatusColor(String status) {
    if (status == TodoStatus.Open.name) return todoStatusOpenStatusText;
    if (status == TodoStatus.Completed.name) return completedButtonColor;
    if (status == TodoStatus.Closed.name) return closedButtonColor;
    if (status == TodoStatus.Removed.name) return red;
  }

  Widget _getTypeText() {
    final type = widget.todo.task.type ?? 'Other';
    String text;
    if (type.startsWith('Event')) {
      text = type.split("-").last;
    } else if (type.endsWith('Application'))
      text = '';
    //text = type.split(" ").first;
    else
      text = '';
    return Column(
      children: [
        Text(
          "${text.toUpperCase()}",
          style: montserratBoldTextStyle.copyWith(
              color: todoTypeTextColor,
              fontSize: 10,
              fontWeight: FontWeight.w900),
        ),
        SizedBox(height: 15),
      ],
    );
  }
}
