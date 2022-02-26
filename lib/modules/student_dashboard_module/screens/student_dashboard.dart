import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/college_application_cell.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/common_dashboard_body_widget.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/common_components/custom_circular_indicator.dart';
import 'package:palette/common_components/event_application_cell.dart';
import 'package:palette/common_components/invite_button.dart';
import 'package:palette/common_components/invite_user_screen.dart';
import 'package:palette/common_components/job_application_cell.dart';
import 'package:palette/common_components/notifications_bell_icon.dart';
import 'package:palette/common_components/static_text_widgets.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_components/student_view_components/static_heading_widgets.dart';
import 'package:palette/common_components/top_program_button.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/multi_tenant_module/widgets/top_sheet.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/common_pendo_repo/dashboard_pendo_repo.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/screens/notification_list_screen.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/modules/profile_module/bloc/profile_image_bloc/profile_image_bloc.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/student_profile_screen.dart';
import 'package:palette/modules/student_dashboard_module/models/college_application_list_model.dart';
import 'package:palette/modules/student_dashboard_module/models/event_list_model.dart';
import 'package:palette/modules/student_dashboard_module/models/job_application_list_model.dart';
import 'package:palette/modules/student_dashboard_module/widgets/unread_count_indicator.dart';
import 'package:palette/modules/student_dashboard_module/widgets/unread_counter_empty_widget.dart';
import 'package:palette/modules/student_view/bloc/student_bloc.dart';
import 'package:palette/modules/student_view/services/student_repository.dart';
import 'package:palette/modules/todo_module/screens/todo_list_screen.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import '../../../main.dart';
import '../../../utils/helpers.dart';

class StudentDashBoard extends StatefulWidget {
  final StudentProfileUserModel? student;
  final String studentId;
  StudentDashBoard({required this.student, this.studentId = ''});

  @override
  _StudentDashBoardState createState() => _StudentDashBoardState();
}

class _StudentDashBoardState extends State<StudentDashBoard> with SingleTickerProviderStateMixin{
  StudentBloc _bloc = StudentBloc(studentRepo: StudentRepository.instance);
  // final selfFirebaseUid = FirebaseChatCore.instance.firebaseUser!.uid;

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  int unreadNotifCounter =0;
  TextEditingController searchController = TextEditingController();
  late AnimationController controller;
  late Animation<Offset> offset;
  List<ContactsData> contacts = [];

  @override
  void initState() {
    super.initState();
    // getCollegeInfo();
    // getJobInfo();
    // getEventInfo();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)
        .animate(controller);
  }

  getCollegeInfo() async {
    if (mounted == true) {
      await _bloc.getCollegeInfo(widget.studentId).then((list) {
        _bloc.collegeObserver.sink.add(list);
      });
    }
  }

  getJobInfo() async {
    await _bloc.getJobInfo(widget.studentId).then((list) {
      _bloc.jobObserver.sink.add(list);
    });
  }

  getEventInfo() async {
    await _bloc.getEventInfo(widget.studentId).then((list) {
      _bloc.eventObserver.sink.add(list);
    });
  }

  Widget topTextRow() {
    return Padding(
      padding: EdgeInsets.only(top: 120, left: 28, right: 28),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'College Applications',
            style: kalamLight.copyWith(color: defaultDark, fontSize: 24),
          ),
          Text(
            'View All',
            style: kalamLight.copyWith(color: defaultDark, fontSize: 14),
          ),
        ],
      ),
    );
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomPaletteLoader()),
    );
  }

  Widget _getErrorLabel() {
    return Center(
      child: Text(
        'Something went wrong. \nTry again later !',
        textAlign: TextAlign.center,
        style: kalamTextStyle.copyWith(color: white, fontSize: 28),
      ),
    );
  }

  Widget showCollegeApplicationList() {
    // StudentBloc _bloc = BlocProvider.of<StudentBloc>(context);
    return StreamBuilder<CollegeApplicationList>(
      stream: _bloc.collegeObserver.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null &&
            snapshot.connectionState == ConnectionState.active) {
          return CollegeApplicationCell(
            model: snapshot.data!,
            onTap: () {},
          );
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _getLoadingIndicator();
        } else {
          return Container();
        }
      },
    );
  }

  Widget showJobApplicationList() {
    // StudentBloc _bloc = BlocProvider.of<StudentBloc>(context);
    return StreamBuilder<JobApplicationListModel>(
      stream: _bloc.jobObserver.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null &&
            snapshot.connectionState == ConnectionState.active) {
          return JobApplicationCell(onTap: () {}, model: snapshot.data!);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _getLoadingIndicator();
        } else {
          return Container();
        }
      },
    );
  }

  Widget showEventList() {
    return StreamBuilder<EventList>(
      stream: _bloc.eventObserver.stream,
      builder: (context, snapshot) {
        if (snapshot.data != null &&
            snapshot.connectionState == ConnectionState.active) {
          return EventApplicationCell(model: snapshot.data!);
        } else if (snapshot.connectionState == ConnectionState.waiting) {
          return _getLoadingIndicator();
        } else {
          return Container();
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final devWidth = MediaQuery.of(context).size.width;
    final devHeight = MediaQuery.of(context).size.height;
    void _onRefresh() async {
      final bloc = context.read<GetContactsBloc>();
      bloc.add(
        GetContactsEvent(),
      );
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use loadFailed(),if no data return,use LoadNodata()
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    }

    Widget getBody() {
      return BlocBuilder<GetContactsBloc, GetContactsState>(
          builder: (context, state) {
            if(state is GetContactsLoadingState){
              return _getLoadingIndicator();
            }
            else if (state is GetContactsSuccessState)
              contacts = state.contactsResponse.contacts;
            return DashboardBody(devHeight: devHeight, widget: contacts,);});
    }

    return SafeArea(
      child: Semantics(
        label:
        "Welcome to your home page. A tap on the profile image on the top left will navigate to your profile and there is a chat button on the top right will navigate to your chat page. "
            "On the center of this page you have childrens. tap for more details",
        child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Scaffold(
                backgroundColor: Colors.transparent,
                appBar: AppBar(
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                ),
                body: GestureDetector(
                  onTap: () {
                    switch (controller.status) {
                      case AnimationStatus.completed:
                        controller.reverse();
                        break;
                      default:
                    }
                  },
                  child: SmartRefresher(

                      enablePullDown: true,
                      enablePullUp: false,
                      header: WaterDropHeader(
                        waterDropColor: defaultDark,
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: TextScaleFactorClamper(
                          child: getBody())),
                )
              ),
              TopProgramButton(controller: controller),
              topLeftProfilePicture(context),
              TopSheet(controller: controller,offset: offset,)
            ],
          ),
        ),
      ),
    );
  }

  GestureDetector topLeftProfilePicture(BuildContext context) {
    return GestureDetector(
              onTap: () {
                DashboardPendoRepo.trackTapOnProfilePictureEvent(
                    buildContext: context);
                if (widget.student == null) return;
                final route = MaterialPageRoute(
                    builder: (_) => StudentProfileScreen(student: widget.student));
                Navigator.push(context, route);
              },
              child: Container(
                child: Stack(children: [
                  SvgPicture.asset(
                    'images/student_small_splash.svg',
                    height: 130,
                    semanticsLabel: "Profile Picture.",
                  ),
                  BlocBuilder<ProfileImageBloc, ProfileImageState>(
                      builder: (context, state) {
                        final String? profileImageUrl;
                        if (state is ProfileImageSuccessState) {
                          profileImageUrl = state.url;
                        } else if (state is ProfileImageDeleteState) {
                          return Container();
                        } else {
                          profileImageUrl = widget.student != null ? widget.student!.profilePicture : '';
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 22, left: 16),
                          child: CachedNetworkImage(
                            imageUrl: profileImageUrl ?? '',
                            imageBuilder: (context, imageProvider) => Container(
                              width: 59,
                              height: 59,
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                child:
                                CustomChasingDotsLoader(color: defaultDark)),
                            errorWidget: (context, url, error) => Container(),
                          ),
                        );
                      }),
                ]),
              ),
            );
  }
  Widget searchBar() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.5,
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ExcludeSemantics(
        child: TextField(
          controller: searchController,
          cursorColor: Colors.blueGrey,
          autocorrect: false,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              color: Color(0xFF545454),
            ),
            border: InputBorder.none,
            hintText: 'Search...',
          ),
          // onChanged: onSearchTextChanged,
        ),
      ),
    );
  }
}
