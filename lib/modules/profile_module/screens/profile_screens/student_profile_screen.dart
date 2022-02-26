import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/logout_button.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_components/third_person_chat_button.dart';
import 'package:palette/modules/app_info/screens/app_info_page.dart';
import 'package:palette/modules/profile_module/bloc/postimage_bloc/postImage_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_states.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_states.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/modules/profile_module/widgets/contact_row.dart';
import 'package:palette/modules/profile_module/widgets/education_history.dart';
import 'package:palette/modules/profile_module/widgets/hamburger_menu.dart';
import 'package:palette/modules/profile_module/widgets/interest_widget.dart';
import 'package:palette/modules/profile_module/widgets/profile_page_top_widget.dart';
import 'package:palette/modules/profile_module/widgets/skills_widget.dart';
import 'package:palette/modules/profile_module/widgets/social_links.dart';
import 'package:palette/modules/profile_module/widgets/studentWorkExpAndProjectsTile.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';

class StudentProfileScreen extends StatefulWidget {
  final StudentProfileUserModel? student;
  bool thirdPerson;
  bool directLoad;
  String sfid;
  String role;
  String sfuuid;
  StudentProfileScreen(
      {this.student,
      this.thirdPerson = false,
      this.directLoad = false,
      this.sfid = '',
      this.role = '',
      this.sfuuid = ''});
  @override
  _StudentProfileScreenState createState() => _StudentProfileScreenState();
}

class _StudentProfileScreenState extends State<StudentProfileScreen> {
  bool isSettingVisible = false;
  final pageController = PageController();
  final _currentPageNotifier = ValueNotifier<int>(0);
  StudentProfileUserModel? student;
  var _pageViewHeightIfAccessibilityIsOn;
  var _pageViewHeightIfAccessibilityIsOff;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    student = widget.student;
    if (student == null || student.toString().isEmpty) {
      final bloc = context.read<RefreshProfileBloc>();
      bloc.add(
        RefreshUserProfileDetails(),
      );
    }
  }

  setSFuuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    widget.sfuuid = prefs.getString(saleforceUUIDConstant) ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final devWidth = MediaQuery.of(context).size.width;
    final devHeight = MediaQuery.of(context).size.height;
    _pageViewHeightIfAccessibilityIsOn = devHeight * 0.59;
    _pageViewHeightIfAccessibilityIsOff = devHeight * 0.59;

    void _onRefresh() async {
      final bloc = context.read<RefreshProfileBloc>();
      bloc.add(
        RefreshUserProfileDetails(),
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

    return BlocProvider<PostImageBloc>(
      create: (context) =>
          PostImageBloc(profileRepo: ProfileRepository.instance),
      child: TextScaleFactorClamper(
        child: SafeArea(
          child: Semantics(
            label: widget.thirdPerson == true
                ? "This is the profile screen of ${student!.name}"
                : "Welcome to your profile screen. All your basic user information has been displayed below and you can add more to several sections. the final section on the bottom contains your contact information that will also be visible to other users that visit your profile, which can also be updated, at your convenience from the same page.",
            child: GestureDetector(
              onTap: () => setState(() => isSettingVisible = false),
              child: Scaffold(
                  backgroundColor: defaultDark,
                  body: widget.thirdPerson == false
                      ? Stack(
                          children: [
                            BlocBuilder<RefreshProfileBloc,
                                RefreshProfileState>(builder: (context, state) {
                              if (state is RefreshProfileScreenInitialState) {
                                return _getProfileBody(
                                  student: widget.student!,
                                  devWidth: devWidth,
                                  devHeight: devHeight,
                                  onLoading: _onLoading,
                                  onRefresh: _onRefresh,
                                );
                              }
                              if (state is RefreshProfileScreenLoadingState) {
                                _currentPageNotifier.value = 0;
                                return _getLoadingIndicator();
                              } else if (state
                                  is RefreshProfileScreenSuccessState) {
                                student = state.profileUser
                                    as StudentProfileUserModel;
                                return _getProfileBody(
                                  student: student!,
                                  devWidth: devWidth,
                                  devHeight: devHeight,
                                  onLoading: _onLoading,
                                  onRefresh: _onRefresh,
                                );
                              } else if (state
                                  is RefreshProfileScreenFailedState) {
                                return _getErrorLabel();
                              } else {
                                // >>>>>>> b8a606d8dc30548c49a4216cfe64bc77360456f7
                                return Container();
                              }
                            }),
                            HamburgerMenu(
                              isVisible: isSettingVisible,
                              userName: student!.name,
                              userEmail: student!.email ?? '',
                              userRole: 'student',
                              userId: student!.id,
                            )
                          ],
                        )
                      : BlocBuilder<ThirdPersonBloc, ThirdPersonState>(
                          builder: (context, state) {
                          if (state is ThirdPersonLoadingState) {
                            return _getLoadingIndicator();
                          } else if (state is ThirdPersonSuccessState) {
                            student =
                                state.profileUser as StudentProfileUserModel;
                            return _getProfileBody(
                                student: student!,
                                devWidth: devWidth,
                                devHeight: devHeight);
                          } else {
                            return Container();
                          }
                        })),
            ),
          ),
        ),
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

  Widget _getProfileBody({
    required StudentProfileUserModel student,
    required double devWidth,
    required double devHeight,
    onRefresh,
    onLoading,
  }) {
    final isAccessibilityOff = MediaQuery.of(context).accessibleNavigation;
    final _pageViewHeight = isAccessibilityOff
        ? _pageViewHeightIfAccessibilityIsOff
        : _pageViewHeightIfAccessibilityIsOn;

    return widget.thirdPerson == false
        ? SmartRefresher(
            enablePullDown: true,
            enablePullUp: false,
            header: WaterDropHeader(
              waterDropColor: defaultDark,
            ),
            controller: _refreshController,
            onRefresh: onRefresh,
            onLoading: onLoading,
            child: Stack(
              children: [
                Column(
                  children: [
                    _getTopProfileWidget(
                      screenHeight: devHeight,
                      screenWidth: devWidth,
                    ),
                    SizedBox(height: 10),
                    Container(
                      height: _pageViewHeight,
                      child: _getPageView(
                          devWidth: devWidth, devHeight: devHeight),
                    ),
                  ],
                ),
                Positioned(
                  bottom: 60,
                  left: MediaQuery.of(context).size.width / 2 - 18,
                  child: Center(
                    child: CirclePageIndicator(
                      selectedDotColor: inactiveOtpColor,
                      dotColor: defaultLight.withOpacity(0.5),
                      itemCount: 2,
                      currentPageNotifier: _currentPageNotifier,
                    ),
                  ),
                ),
                if (widget.thirdPerson == false)
                  SocialLinks(
                    userModel: student,
                    width: MediaQuery.of(context).size.width,
                    sfid: widget.sfid,
                    role: 'Student',
                    sfuuid: widget.sfuuid,
                  ),
                if (widget.thirdPerson == true)
                  Positioned(
                    bottom: 0,
                    child: ContactRow(
                      userModel: student,
                      width: MediaQuery.of(context).size.width,
                      role: widget.role,
                      sfid: widget.sfid,
                      sfuuid: widget.sfuuid,
                    ),
                  ),
                if (widget.thirdPerson == false)
                  Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                          icon: Hero(
                            tag: 'settings',
                            child: SvgPicture.asset('images/Vector.svg')),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => AppInfoPage(
                                        name: widget.student?.name ?? '',
                                        email: widget.student?.email ?? '',
                                      )),
                            );
                          },
                          color: Colors.white)
                      // child: LogoutButton(),

                      // TO show hamburgerMenu un-comment the following line
                      // child: IconButton(
                      //   splashRadius: 1,
                      //   icon: Icon(
                      //     Icons.menu,
                      //     color: defaultLight,
                      //   ),
                      //   onPressed: () => setState(() => isSettingVisible = true),
                      // ),
                      ),
                if (widget.thirdPerson == true)
                  Semantics(
                    label: "Tap to Navigated back",
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: Semantics(
                        button: true,
                        onTapHint: "Navigated back",
                        child: IconButton(
                            icon: RotatedBox(
                                quarterTurns: 1,
                                child: SvgPicture.asset(
                                  'images/dropdown.svg',
                                  color: defaultLight,
                                  semanticsLabel: "Tap to Navigated back",
                                )),
                            onPressed: () {
                              Navigator.of(context).pop();
                            }),
                      ),
                    ),
                  ),
              ],
            ),
          )
        : Stack(
            children: [
              Column(
                children: [
                  _getTopProfileWidget(
                    screenHeight: devHeight,
                    screenWidth: devWidth,
                  ),
                  SizedBox(height: 10),
                  Container(
                    height: _pageViewHeight,
                    child:
                    student.firebaseUuid == null?Center(child: Text(
                      'Yet To Activate Account',
                      style: kalamTextStyleSmall.copyWith(
                        fontSize: 18,
                        color: defaultLight,
                      ),
                    ),):_getPageView(devWidth: devWidth, devHeight: devHeight),
                  ),
                ],
              ),
              if(student.firebaseUuid != null)
              Positioned(
                bottom: 60,
                left: MediaQuery.of(context).size.width / 2 - 18,
                child: Center(
                  child: CirclePageIndicator(
                    selectedDotColor: inactiveOtpColor,
                    dotColor: defaultLight.withOpacity(0.5),
                    itemCount: 2,
                    currentPageNotifier: _currentPageNotifier,
                  ),
                ),
              ),
              if (widget.thirdPerson == false)
                SocialLinks(
                  userModel: student,
                  width: MediaQuery.of(context).size.width,
                  sfid: widget.sfid,
                  role: 'Student',
                  sfuuid: widget.sfuuid,
                ),
              if (widget.thirdPerson == true)
                Positioned(
                  bottom: 0,
                  left: MediaQuery.of(context).size.width * 0.2,
                  child: ContactRow(
                    userModel: student,
                    width: MediaQuery.of(context).size.width * 0.8,
                    role: widget.role,
                    sfid: widget.sfid,
                    sfuuid: widget.sfuuid,
                  ),
                ),
              if (widget.thirdPerson == true
                  && student.firebaseUuid != null
              )
                Positioned(
                  left: -10,
                  bottom: -10,
                  child: ThirdPersonChat(firebaseUuid: student.firebaseUuid,),
                ),
              if (widget.thirdPerson == false)
                Align(
                  alignment: Alignment.topRight,
                  child: LogoutButton(),
                ),
              if (widget.thirdPerson == true)
                Align(
                  alignment: Alignment.topLeft,
                  child: Semantics(
                    // button: true,
                    label: "Tap to navigate back",
                    onTapHint: "Navigated back",
                    child: IconButton(
                        icon: RotatedBox(
                            quarterTurns: 1,
                            child: SvgPicture.asset(
                              'images/dropdown.svg',
                              color: defaultLight,
                            )),
                        onPressed: () {
                          Navigator.of(context).pop();
                        }),
                  ),
                ),
            ],
          );
  }

  Widget _getTopProfileWidget(
      {required double screenHeight, required double screenWidth}) {
    if (student == null) return Container();
    String? age;
    final stu = this.student!;
    if (stu.dOB != null)
      age = Helper.getAge(
            birthDate: DateTime.parse("${stu.dOB} 00:00:00"),
            todaysDate: DateTime.now(),
          ) +
          ' yr • ';
    else
      age = '';

    String gender;
    if (stu.gender != null)
      gender = stu.gender! + ' • ';
    else
      gender = '';

    final mailingState = stu.mailingState ?? '';
    final subtitle = '${age + gender + mailingState}';

    return ProfilePageTopWidget(
      screenHeight: screenHeight,
      screenWidth: screenWidth,
      role: 'student',
      title: stu.name,
      subtitle: subtitle,
      thirdPerson: widget.thirdPerson,
      sfid: stu.Id,
      profilePicture: stu.profilePicture,
    );
  }

  Widget _getPageView({
    required double devWidth,
    required double devHeight,
  }) {
    if (student == null) return Container();
    return PageView(
      children: [
        SingleChildScrollView(
          physics: RangeMaintainingScrollPhysics(),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.symmetric(horizontal: devWidth * 0.06),
                  child: EducationHistoryWidget(
                    value: 'Education',
                    educationList: student!.educationList,
                  )),
              SizedBox(
                height: 20,
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: devWidth * 0.06),
                child: StudentWorkExpAndProjects(
                  value: TileType.WORK_EXP,
                  studentWorkExpList: student!.workExperience!,
                ),
              ),
              SizedBox(
                height: 20,
              ),
              devHeight >= 736
                  ? Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: devWidth * 0.06),
                      child: InterestAndActivities(
                        value: 'Interests',
                        points: student!.interests,
                        thirdPerson: widget.thirdPerson,
                        userId: student!.id,
                        sfid: widget.sfid,
                        role: widget.role,
                        sfuuid: widget.sfuuid,
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
        SingleChildScrollView(
          physics: RangeMaintainingScrollPhysics(),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: devWidth * 0.06),
            child: Column(
              children: [
                SkillWidget(
                  value: 'Skills',
                  points: student!.skills,
                  thirdPerson: widget.thirdPerson,
                  userId: student!.id,
                  sfid: widget.sfid,
                  role: widget.role,
                  sfuuid: widget.sfuuid,
                ),
                devHeight >= 736
                    ? Container()
                    : Column(
                        children: [
                          SizedBox(height: 20),
                          InterestAndActivities(
                            value: 'Interests',
                            points: student!.interests,
                            thirdPerson: widget.thirdPerson,
                            userId: student!.id,
                            sfid: widget.sfid,
                            role: widget.role,
                            sfuuid: widget.sfuuid,
                          ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ],
      controller: pageController,
      onPageChanged: (index) {
        _currentPageNotifier.value = index;
      },
    );
  }
}
