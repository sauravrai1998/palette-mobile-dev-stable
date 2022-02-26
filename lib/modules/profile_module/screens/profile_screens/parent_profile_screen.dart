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
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/modules/profile_module/widgets/contact_row_parent.dart';
import 'package:palette/modules/profile_module/widgets/hamburger_menu.dart';
import 'package:palette/modules/profile_module/widgets/profile_page_top_widget.dart';
import 'package:palette/modules/profile_module/widgets/social_link_parent_admin.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentProfileScreen extends StatefulWidget {
  final ParentProfileUserModel parent;

  bool thirdPerson;

  ParentProfileScreen({required this.parent, this.thirdPerson = false});
  @override
  _ParentProfileScreenState createState() => _ParentProfileScreenState();
}

class _ParentProfileScreenState extends State<ParentProfileScreen> {
  bool isSettingVisible = false;
  final pageController = PageController();
  ParentProfileUserModel? parent;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? sfuuid;

  @override
  void initState() {
    super.initState();
    parent = widget.parent;
    if (parent == null || parent.toString().isEmpty) {
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
    final devWidth = MediaQuery.of(context).size.width;
    final devHeight = MediaQuery.of(context).size.height;

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
                  body: widget.thirdPerson == false?
                  Stack(
                    children: [
                      BlocBuilder<RefreshProfileBloc, RefreshProfileState>(
                        builder: (context, state) {
                          if (state is RefreshProfileScreenInitialState) {
                            return _getProfileBody(
                              parent: widget.parent,
                              devWidth: devWidth,
                              devHeight: devHeight,
                              onLoading: _onLoading,
                              onRefresh: _onRefresh,
                            );
                          }
                          if (state is RefreshProfileScreenLoadingState) {
                            return _getLoadingIndicator();
                          } else if (state
                              is RefreshProfileScreenSuccessState) {
                            parent =
                                state.profileUser as ParentProfileUserModel;
                            return _getProfileBody(
                              parent: widget.parent,
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
                        },
                      ),
                      HamburgerMenu(
                        isVisible: isSettingVisible,
                        userName: parent!.name,
                        userEmail: parent!.email,
                        userRole: 'parent',
                        userId: parent!.id,
                      )
                    ],
                  ):
                  BlocBuilder<ThirdPersonBloc, ThirdPersonState>(
                      builder: (context, state) {
                        if (state is ThirdPersonLoadingState) {
                          return _getLoadingIndicator();
                        } else if (state is ThirdPersonSuccessState) {
                          parent =
                          state.profileUser as ParentProfileUserModel;
                          return _getProfileBody(
                              parent: parent!,
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

  Widget _getProfileBody({
    required ParentProfileUserModel parent,
    required double devWidth,
    required double devHeight,
    onRefresh,
    onLoading,
  }) {
    if (parent == null) return Container();
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
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                children: [
                  Stack(
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
                                        name: widget.parent.name,
                                        email: widget.parent.email,
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
                      ProfilePageTopWidget(
                        screenHeight: devHeight,
                        screenWidth: devWidth,
                        role: 'parent',
                        title: parent.name,
                        subtitle: '',
                        sfid: parent.id,
                        profilePicture: parent.profilePicture,
                      ),
                    ],
                  ),
                  // Padding(
                  //   padding: EdgeInsets.symmetric(horizontal: devWidth * 0.06),
                  //   child: Column(
                  //     children: [
                  //       Align(
                  //           alignment: Alignment.centerLeft,
                  //           child: ChildrenListView(
                  //             pupils: parent!.pupils,
                  //           )),
                  //     ],
                  //   ),
                  // ),
                ],
              ),
            ],
          ),
          SocialLinkForParent(
            userModel: parent,
            width: MediaQuery.of(context).size.width,
            sfuuid: sfuuid ?? '',
          )
        ],
      ),
    ):Stack(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
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
                                    name: widget.parent.name,
                                    email: widget.parent.email,
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
                    ProfilePageTopWidget(
                      screenHeight: devHeight,
                      screenWidth: devWidth,
                      role: 'parent',
                      title: parent.name,
                      subtitle: '',
                      sfid: parent.id,
                      profilePicture: parent.profilePicture,
                      thirdPerson: true,
                    ),
                  ],
                ),
                if (parent.firebaseUuid == null)
                  Padding(
                    padding:  EdgeInsets.only(top: devHeight * 0.2),
                    child: Text(
                      'Yet To Activate Account',
                      style: kalamTextStyleSmall.copyWith(
                        fontSize: 18,
                        color: defaultLight,
                      ),
                    ),
                  )
                // Padding(
                //   padding: EdgeInsets.symmetric(horizontal: devWidth * 0.06),
                //   child: Column(
                //     children: [
                //       Align(
                //           alignment: Alignment.centerLeft,
                //           child: ChildrenListView(
                //             pupils: parent!.pupils,
                //           )),
                //     ],
                //   ),
                // ),
              ],
            ),
          ],
        ),
        if (widget.thirdPerson == false)
        SocialLinkForParent(
          userModel: parent,
          width: MediaQuery.of(context).size.width,
          sfuuid: sfuuid ?? '',
          thirdPerson: widget.thirdPerson,
        ),
        if (widget.thirdPerson == true)
          Positioned(
            bottom: 0,
            left: MediaQuery.of(context).size.width * 0.2,
            child: ContactRowParent(
              userModel: parent,
              width: MediaQuery.of(context).size.width * 0.8,
              role: 'Guardian',
              sfid: parent.id,
              sfuuid: sfuuid ?? "",
            ),
          ),
        if (widget.thirdPerson == true
            && parent.firebaseUuid != null
        )
          Positioned(
            left: -10,
            bottom: -10,
            child: ThirdPersonChat(firebaseUuid: parent.firebaseUuid,),
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
}
