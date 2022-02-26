import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_circular_indicator.dart';
import 'package:palette/common_components/logout_button.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_bloc.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_events.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_states.dart';
import 'package:palette/modules/admin_dashboard_module/models/user_models/admin_student_mentors_model.dart';
import 'package:palette/modules/admin_dashboard_module/services/admin_repository.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_events.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_states.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/models/user_models/admin_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/admin_profile_screen.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/modules/profile_module/widgets/landing_page_top_widget.dart';

class AdminLandingPage extends StatefulWidget {
  @override
  _AdminLandingPageState createState() => _AdminLandingPageState();
}

class _AdminLandingPageState extends State<AdminLandingPage>
    with TickerProviderStateMixin {
  AdminProfileUserModel? admin;
  AdminStudent? student;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(vsync: this, length: 2);
    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {});
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomCircularIndicator()),
    );
  }

  getTopWidget(screenHeight, screenWidth) {
    return GestureDetector(
      onTap: () {
        if (admin == null) return;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AdminProfileScreen(
              admin: admin!,
            ),
          ),
        );
      },
      child: Container(
        height: screenHeight * 0.45,
        color: defaultDark,
        child: BlocProvider(
          create: (BuildContext context) {
            context.read<RefreshProfileBloc>().add(RefreshUserProfileDetails());
            return ProfileBloc(profileRepo: ProfileRepository.instance)
              ..add(GetProfileScreenUser());
          },
          child: SafeArea(
            child: Scaffold(
              backgroundColor: defaultDark,
              body: BlocBuilder<ProfileBloc, ProfileState>(
                builder: (context, state) {
                  if (state is ProfileUserLoadingState) {
                    return _getLoadingIndicator();
                  } else if (state is ProfileUserSuccessState) {
                    admin = state.profileUser as AdminProfileUserModel;
                    return Stack(
                      children: [
                        Align(
                          alignment: Alignment.topRight,
                          child: LogoutButton(),
                        ),
                        LandingPageTopWidget(
                          screenWidth: screenWidth,
                          screenHeight: screenHeight,
                          role: 'admin',
                          title: admin!.name,
                        )
                      ],
                    );
                  }

                  return Container();
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  TextStyle sideDes = kalamLight.copyWith(color: defaultLight, fontSize: 14);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    return TextScaleFactorClamper(
      child: SafeArea(
        child: Semantics(
          label:
              "Welcome to your home page. A tap on the lower half will navigate to your user dashboard and a tap on the upper half will navigate you to your profile. There is a button to log out of your session on the top right.",
          child: Scaffold(
            backgroundColor: defaultDark,
            body: ListView(
              physics: NeverScrollableScrollPhysics(),
              children: [
                getTopWidget(screenHeight, screenWidth),
                GestureDetector(
                  onTap: () {
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //       builder: (context) => AdminDashboard()),
                    // );
                  },
                  child: Container(
                    height: height * 0.55,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        color: Colors.white),
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Container(
                          width: 200,
                          child: TabBar(
                            controller: _tabController,
                            indicatorColor: Colors.black,
                            labelColor: Colors.black,
                            unselectedLabelColor: Colors.grey,
                            indicator: UnderlineTabIndicator(
                              borderSide: BorderSide(width: 2.0),
                              insets: EdgeInsets.symmetric(horizontal: 20.0),
                            ),
                            indicatorPadding:
                                EdgeInsets.symmetric(vertical: 15),
                            onTap: (index) {
                              // Tab index when user select it, it start from zero
                            },
                            tabs: [
                              Tab(
                                  child: Text(
                                'Students',
                                style: kalamLight.copyWith(
                                  color: _tabController.index == 0
                                      ? defaultDark
                                      : swipeBackgroundColor,
                                  fontSize: 18,
                                ),
                              )),
                              Tab(
                                  child: Text(
                                'Mentors',
                                style: kalamLight.copyWith(
                                  color: _tabController.index == 1
                                      ? defaultDark
                                      : swipeBackgroundColor,
                                  fontSize: 18,
                                ),
                              )),
                            ],
                          ),
                        ),
                        BlocProvider(
                          create: (BuildContext context) {
                            //context.read<RefreshProfileBloc>().add(RefreshUserProfileDetails());
                            return AdminStudentBloc(
                                adminRepo: AdminRepository.instance)
                              ..add(AdminGetStudentUser());
                          },
                          child: Container(
                            height: screenHeight * 0.40,
                            child: BlocBuilder<AdminStudentBloc,
                                AdminStudentState>(
                              builder: (context, state) {
                                if (state is StudentUserLoadingState) {
                                  return _getLoadingIndicator();
                                } else if (state is StudentUserSuccessState) {
                                  student = state.adminStudentsMentorsList;
                                  return TabBarView(
                                      controller: _tabController,
                                      children: [
                                        ListView.builder(
                                          itemCount:
                                              student!.data.students.length,
                                          itemBuilder: (_, index) {
                                            var users = student!
                                                .data.students[index].name;
                                            var fullName = users.split(" ");
                                            var firstName = fullName[0].trim();
                                            var lastName = fullName[1].trim();

                                            return Container(
                                              decoration: BoxDecoration(
                                                  // border: Border.all(color: Colors.black26),
                                                  ),
                                              padding: EdgeInsets.all(10),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.indigoAccent,
                                                  child: Text(firstName
                                                          .substring(0, 1)
                                                          .toUpperCase() +
                                                      lastName
                                                          .substring(0, 1)
                                                          .toUpperCase()),
                                                ),
                                                title: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      student!.data
                                                          .students[index].name,
                                                      style:
                                                          kalamLight.copyWith(
                                                        color: defaultDark,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                    Text(
                                                      'Grade:',
                                                      style:
                                                          kalamLight.copyWith(
                                                        fontSize: 12,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                onTap: () async {},
                                              ),
                                            );
                                          },
                                        ),
                                        ListView.builder(
                                          itemCount:
                                              student!.data.mentors.length,
                                          itemBuilder: (_, index) {
                                            var users = student!
                                                .data.mentors[index].name;
                                            var fullName = users.split(" ");
                                            var firstName = fullName[0].trim();
                                            var lastName = fullName[1].trim();
                                            return Container(
                                              decoration: BoxDecoration(
                                                  // border: Border.all(color: Colors.black26),
                                                  ),
                                              padding: EdgeInsets.all(10),
                                              child: ListTile(
                                                leading: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.indigoAccent,
                                                  child: Text(firstName
                                                          .substring(0, 1)
                                                          .toUpperCase() +
                                                      lastName
                                                          .substring(0, 1)
                                                          .toUpperCase()),
                                                ),
                                                title: Text(
                                                  student!
                                                      .data.mentors[index].name,
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
                                    child: Text('here1'),
                                  );
                                }

                                return Container(
                                  child: Text('here'),
                                );
                              },
                            ),
                          ),
                        )
                      ],
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
}
