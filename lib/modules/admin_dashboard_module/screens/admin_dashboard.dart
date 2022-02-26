import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_components/common_dashboard_body_widget.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/common_components/invite_button.dart';
import 'package:palette/common_components/invite_user_screen.dart';
import 'package:palette/common_components/notifications_bell_icon.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_components/top_program_button.dart';
import 'package:palette/modules/advisor_dashboard_module/widgets/student_mentor_circular_button.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/multi_tenant_module/widgets/top_sheet.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_bloc.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_events.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_states.dart';
import 'package:palette/modules/admin_dashboard_module/models/user_models/admin_student_mentors_model.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/common_pendo_repo/dashboard_pendo_repo.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/screens/notification_list_screen.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/modules/profile_module/bloc/profile_image_bloc/profile_image_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_events.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_states.dart';
import 'package:palette/modules/profile_module/models/user_models/admin_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/admin_profile_screen.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/screens/todo_list_screen.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminDashboard extends StatefulWidget {
  final AdminProfileUserModel? admin;

  AdminDashboard({required this.admin});
  @override
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard>
    with TickerProviderStateMixin {
  String? selectedId;
  AdminStudent? student;
  late TabController _tabController;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? sfid;
  String? sfuuid;
  String? role;
  List<CommonStudentMentor> list = [];
  List<ContactsData> contacts = [];
  List<CommonStudentMentor> filteredList = [];
  bool isSort = false;

  int unreadNotifCounter = 0;

  TextEditingController searchController = TextEditingController();
  late AnimationController controller;
  late Animation<Offset> offset;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
    final bloc = context.read<AdminStudentBloc>();
    bloc.add(AdminGetStudentUser());
    _getSfidAndRole();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)
        .animate(controller);
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
    sfuuid = prefs.getString(saleforceUUIDConstant);
    role = prefs.getString('role').toString();
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(
          height: 38,
          width: 50,
          child: CustomChasingDotsLoader(
            color: defaultDark,
          )),
    );
  }

  @override
  Widget build(BuildContext context) {
    print('build');
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
    final devWidth = MediaQuery.of(context).size.width;
    final devHeight = MediaQuery.of(context).size.height;

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

    return Semantics(
      label:
          "Welcome to your home page. A tap on the profile image on the top left will navigate to your profile and there is a chat button on the top right will navigate to your chat page. "
          "On the center of this page you have list of students and mentors tap for more details",
      child: SafeArea(
          child: Scaffold(
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
                      // footer: CustomFooter(
                      //   builder: (BuildContext context, LoadStatus mode) {
                      //     Widget body;
                      //     if (mode == LoadStatus.idle) {
                      //       body = Text("pull up load");
                      //     } else if (mode == LoadStatus.loading) {
                      //       body = CupertinoActivityIndicator();
                      //     } else if (mode == LoadStatus.failed) {
                      //       body = Text("Load Failed!Click retry!");
                      //     } else if (mode == LoadStatus.canLoading) {
                      //       body = Text("release to load more");
                      //     } else {
                      //       body = Text("No more Data");
                      //     }
                      //     return Container(
                      //       height: 55.0,
                      //       child: Center(child: body),
                      //     );
                      //   },
                      // ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: TextScaleFactorClamper(
                        child: getBody()
                      ),
                    ),
                  ),
                ),
                TopProgramButton(controller: controller),
                GestureDetector(
                  onTap: () {
                    DashboardPendoRepo.trackTapOnProfilePictureEvent(
                        buildContext: context);
                    if (widget.admin == null) return;
                    final route = MaterialPageRoute(
                      builder: (_) => AdminProfileScreen(admin: widget.admin!),
                    );
                    Navigator.push(context, route);
                  },
                  child: Container(
                    child: Stack(children: [
                      SvgPicture.asset(
                        'images/admin_small_splash.svg',
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
                          profileImageUrl = widget.admin?.profilePicture;
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
                                child: CustomChasingDotsLoader(
                                  color: defaultDark,
                                )),
                            errorWidget: (context, url, error) => Container(),
                          ),
                        );
                      }),
                    ]),
                  ),
                ),
                TopSheet(controller: controller,offset: offset,)
              ],
            ),
          ),
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
  Widget _widget() {
    return Container(
      height: MediaQuery.of(context).size.height * 0.5,
      child: BlocBuilder<AdminStudentBloc, AdminStudentState>(
        builder: (context, state) {
          if (state is StudentUserLoadingState) {
            return CustomPaletteLoader();
          } else if (state is StudentUserSuccessState) {
            student = state.adminStudentsMentorsList;
            return TabBarView(controller: _tabController, children: [
              ListView.builder(
                itemCount: student!.data.students.length,
                itemBuilder: (_, index) {
                  var users = student!.data.students[index].name;
                  var fullName = users.split(" ");
                  var firstName = fullName[0].trim();
                  var lastName = fullName[1].trim();
                  var no = index + 1;

                  return Container(
                    decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black26),
                        ),
                    padding: EdgeInsets.all(10),
                    child: Semantics(
                      label: "Student $no",
                      child: ListTile(
                        leading: ExcludeSemantics(
                          child: student!.data.students[index].profilePicture !=
                                  null
                              ? CachedNetworkImage(
                                  imageUrl: student!.data.students[index]
                                          .profilePicture ??
                                      '',
                                  imageBuilder: (context, imageProvider) =>
                                      Container(
                                    width: 42,
                                    height: 42,
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
                                          20,
                                      backgroundColor: Colors.indigoAccent,
                                      child: Container(
                                        child: Text(firstName
                                                .substring(0, 1)
                                                .toUpperCase() +
                                            lastName
                                                .substring(0, 1)
                                                .toUpperCase()),
                                      )),
                                  errorWidget: (context, url, error) =>
                                      CircleAvatar(
                                    backgroundColor: Colors.indigoAccent,
                                    child: Text(firstName
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        lastName.substring(0, 1).toUpperCase()),
                                  ),
                                )
                              : CircleAvatar(
                                  backgroundColor: Colors.indigoAccent,
                                  child: Text(firstName
                                          .substring(0, 1)
                                          .toUpperCase() +
                                      lastName.substring(0, 1).toUpperCase()),
                                ),
                        ),
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              student!.data.students[index].name,
                              style: kalamLight.copyWith(
                                color: defaultDark,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              (student!.data.students[index].grade == null
                                  ? ''
                                  : student!.data.students[index].grade)!,
                              style: kalamLight.copyWith(
                                  fontSize: 12, color: inactiveOtpColor),
                            ),
                          ],
                        ),
                        onTap: () {
                          final selectedId = student!.data.students[index].id;
                          this.selectedId = selectedId;
                          final bloc = context.read<ThirdPersonBloc>();
                          bloc.add(GetThirdPersonProfileScreenUser(
                              studentId: selectedId, context: context, role: 'Student'));
                          // var selectedId =
                          //     student!
                          //         .data
                          //         .students[index]
                          //         .id;
                          // final bloc = context.read<
                          //     ThirdPersonBloc>();
                          // bloc.add(
                          //     GetThirdPersonProfileScreenUser(
                          //   studentId: selectedId,
                          // ));
                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(
                          //     builder: (context) =>
                          //         StudentProfileScreen(
                          //             directLoad:
                          //                 true,
                          //             thirdPerson:
                          //                 true),
                          //   ),
                          // );
                        },
                      ),
                    ),
                  );
                },
              ),
              ListView.builder(
                itemCount: student!.data.mentors.length,
                itemBuilder: (_, index) {
                  var users = student!.data.mentors[index].name;
                  var fullName = users.split(" ");
                  var firstName = fullName[0].trim();
                  var lastName = fullName[1].trim();
                  var no = index + 1;
                  return Container(
                    decoration: BoxDecoration(
                        // border: Border.all(color: Colors.black26),
                        ),
                    padding: EdgeInsets.all(10),
                    child: ListTile(
                      leading: Semantics(
                          label: "Mentor $no",
                          child: ExcludeSemantics(
                            child: student!
                                        .data.mentors[index].profilePicture !=
                                    null
                                ? CachedNetworkImage(
                                    imageUrl: student!.data.mentors[index]
                                            .profilePicture ??
                                        '',
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                      width: 42,
                                      height: 42,
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
                                            20,
                                        backgroundColor: Colors.indigoAccent,
                                        child: Container(
                                          child: Text(firstName
                                                  .substring(0, 1)
                                                  .toUpperCase() +
                                              lastName
                                                  .substring(0, 1)
                                                  .toUpperCase()),
                                        )),
                                    errorWidget: (context, url, error) =>
                                        CircleAvatar(
                                      backgroundColor: Colors.indigoAccent,
                                      child: Text(firstName
                                              .substring(0, 1)
                                              .toUpperCase() +
                                          lastName
                                              .substring(0, 1)
                                              .toUpperCase()),
                                    ),
                                  )
                                : CircleAvatar(
                                    backgroundColor: Colors.indigoAccent,
                                    child: Text(firstName
                                            .substring(0, 1)
                                            .toUpperCase() +
                                        lastName.substring(0, 1).toUpperCase()),
                                  ),
                          )),
                      title: Text(
                        student!.data.mentors[index].name,
                        style: kalamLight.copyWith(
                          color: defaultDark,
                          fontSize: 16,
                        ),
                      ),
                      onTap: () async {},
                    ),
                  );
                },
              ),
            ]);
          } else if (state is StudentUserFailedState) {
            return Container(
              child: _getLoadingIndicator(),
            );
          }

          return Container(
            child: Text('here'),
          );
        },
      ),
    );
  }
}
