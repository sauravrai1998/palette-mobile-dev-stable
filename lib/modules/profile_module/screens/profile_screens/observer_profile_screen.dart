import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_components/third_person_chat_button.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/app_info/screens/app_info_page.dart';
import 'package:palette/modules/profile_module/bloc/postimage_bloc/postImage_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_states.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_states.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/modules/profile_module/widgets/contact_row_observer.dart';
import 'package:palette/modules/profile_module/widgets/education_history_widget.dart';
import 'package:palette/modules/profile_module/widgets/hamburger_menu.dart';
import 'package:palette/modules/profile_module/widgets/profile_page_top_widget.dart';
import 'package:palette/modules/profile_module/widgets/social_links.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ObserverProfileScreen extends StatefulWidget {
  final ObserverProfileUserModel observer;
  bool thirdPerson;

  ObserverProfileScreen({required this.observer, this.thirdPerson = false});
  @override
  _ObserverProfileScreenState createState() => _ObserverProfileScreenState();
}

class _ObserverProfileScreenState extends State<ObserverProfileScreen> {
  bool isSettingVisible = false;
  final pageController = PageController();
  ObserverProfileUserModel? observer;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? sfuuid;

  @override
  void initState() {
    super.initState();
    observer = widget.observer;
    if (observer == null || observer.toString().isEmpty) {
      final bloc = context.read<RefreshProfileBloc>();
      bloc.add(
        RefreshUserProfileDetails(),
      );
    }
  }

  setSFuuid() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    sfuuid = prefs.getString(saleforceUUIDConstant);
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;

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
              label:
                  "Welcome to your profile screen. All your basic user information has been displayed below and you can add more to several sections. the final section on the bottom contains your contact information that will also be visible to other users that visit your profile, which can also be updated, at your convenience from the same page.",
              child: GestureDetector(
                onTap: () => setState(() => isSettingVisible = false),
                child: Scaffold(
                  backgroundColor: defaultDark,
                  body: widget.thirdPerson == false?Stack(
                    children: [
                      BlocBuilder<RefreshProfileBloc, RefreshProfileState>(
                          builder: (context, state) {
                        if (state is RefreshProfileScreenInitialState) {
                          return _getProfileBody(
                            observer: widget.observer,
                            devWidth: devWidth,
                            devHeight: devHeight,
                            onLoading: _onLoading,
                            onRefresh: _onRefresh,
                          );
                        }
                        if (state is RefreshProfileScreenLoadingState) {
                          return _getLoadingIndicator();
                        } else if (state is RefreshProfileScreenSuccessState) {
                          observer =
                              state.profileUser as ObserverProfileUserModel;
                          return _getProfileBody(
                            observer: observer!,
                            devWidth: devWidth,
                            devHeight: devHeight,
                            onLoading: _onLoading,
                            onRefresh: _onRefresh,
                          );
                        } else if (state is RefreshProfileScreenFailedState) {
                          return _getErrorLabel();
                        } else {
                          return Container();
                        }
                      }),
                      HamburgerMenu(
                        isVisible: isSettingVisible,
                        userName: observer!.name,
                        userEmail: observer!.email ?? '',
                        userRole: 'observer',
                        userId: observer!.id,
                      )
                    ],
                  ):BlocBuilder<ThirdPersonBloc, ThirdPersonState>(
                      builder: (context, state) {
                        if (state is ThirdPersonLoadingState) {
                          return _getLoadingIndicator();
                        } else if (state is ThirdPersonSuccessState) {
                          observer =
                          state.profileUser as ObserverProfileUserModel;
                          return _getProfileBody(
                              observer: observer!,
                              devWidth: devWidth,
                              devHeight: devHeight);
                        } else {
                          return Container();
                        }
                      }),
                ),
              ),
            ),
          ),
        ));
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
    required ObserverProfileUserModel observer,
    required double devWidth,
    required double devHeight,
    onRefresh,
    onLoading,
  }) {
    return widget.thirdPerson == false?
    SmartRefresher(
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
                                        name: widget.observer.name,
                                        email: widget.observer.email ?? '',
                                      )),
                            );
                          },
                          color: Colors.white),
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
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    SizedBox(height: 18),
                    ProfilePageTopWidget(
                        screenHeight: devHeight,
                        screenWidth: devWidth,
                        role: 'observer',
                        title: observer.name,
                        subtitle: '',
                        sfid: observer.id,
                        profilePicture: observer.profilePicture),
                    Padding(
                      padding:
                          EdgeInsets.symmetric(horizontal: devWidth * 0.06),
                      child: InstituteListWidget(
                          value: 'Institute',
                          educationList: observer.instituteList),
                    ),
                  ],
                ),
              ],
            ),
            SocialLinks(
              userModel: observer,
              width: MediaQuery.of(context).size.width,
              sfid: observer.id,
              role: 'Observer',
              sfuuid: sfuuid ?? '',
            )
          ],
        )):
    Stack(
      children: [
        if(widget.thirdPerson == false)
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
                        name: widget.observer.name,
                        email: widget.observer.email ?? '',
                      )),
                );
              },
              color: Colors.white),
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
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                SizedBox(height: 18),
                ProfilePageTopWidget(
                    screenHeight: devHeight,
                    screenWidth: devWidth,
                    role: 'observer',
                    title: observer.name,
                    subtitle: '',
                    sfid: observer.id,
                    profilePicture: observer.profilePicture,thirdPerson: true,),
                Padding(
                  padding:
                  EdgeInsets.symmetric(horizontal: devWidth * 0.06),
                  child: observer.firebaseUuid == null
                      ? Center(
                    child: Text(
                      'Yet To Activate Account',
                      style: kalamTextStyleSmall.copyWith(
                        fontSize: 18,
                        color: defaultLight,
                      ),
                    ),
                  )
                      : InstituteListWidget(
                      value: 'Institute',
                      educationList: observer.instituteList),
                ),
              ],
            ),
          ],
        ),
        if (widget.thirdPerson == false)
        SocialLinks(
          userModel: observer,
          width: MediaQuery.of(context).size.width,
          sfid: observer.id,
          role: 'Observer',
          sfuuid: sfuuid ?? '',
        ),
        if (widget.thirdPerson == true)
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.2,
            child: ContactRowObserver(
              userModel: observer,
              width: MediaQuery.of(context).size.width * 0.8,
              role: 'Observer',
              sfid: observer.id,
              sfuuid: sfuuid ?? "",
            ),
          ),
        if (widget.thirdPerson == true && observer.firebaseUuid != null)
          Positioned(
            left: -10,
            bottom: -10,
            child: ThirdPersonChat(firebaseUuid: observer.firebaseUuid!,),
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
}
