import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_circular_indicator.dart';
import 'package:palette/common_components/logout_button.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_events.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_states.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/parent_profile_screen.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/modules/profile_module/widgets/landing_page_top_widget.dart';

class ParentLandingPage extends StatefulWidget {
  @override
  _ParentLandingPageState createState() => _ParentLandingPageState();
}

class _ParentLandingPageState extends State<ParentLandingPage> {
  ParentProfileUserModel? parent;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return TextScaleFactorClamper(
      child: SafeArea(
        child: Semantics(
          label:
              "Welcome to your home page. A tap on the lower half will navigate to your user dashboard and a tap on the upper half will navigate you to your profile. There is a button to log out of your session on the top right.",
          child: Scaffold(
            backgroundColor: defaultDark,
            body: Column(
              children: [
                getTopWidget(screenHeight, screenWidth),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => ParentProfileView()),
                      // );
                    },
                    child: Container(
                      height: screenHeight * 0.55,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30),
                            topRight: Radius.circular(30),
                          ),
                          color: Colors.white),
                      child: Center(
                        child: Text("Coming Soon"),
                      ),
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

  getTopWidget(screenHeight, screenWidth) {
    return Expanded(
      child: Container(
        height: screenHeight * 0.45,
        child: GestureDetector(
          onTap: () {
            if (parent == null) return;
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ParentProfileScreen(parent: parent!)),
            );
          },
          child: Container(
            height: screenHeight * 0.45,
            color: defaultDark,
            child: BlocProvider(
              create: (BuildContext context) {
                context
                    .read<RefreshProfileBloc>()
                    .add(RefreshUserProfileDetails());
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
                        parent = state.profileUser as ParentProfileUserModel;
                        return Stack(
                          children: [
                            Align(
                              alignment: Alignment.topRight,
                              child: LogoutButton(),
                            ),
                            LandingPageTopWidget(
                              screenWidth: screenWidth,
                              screenHeight: screenHeight,
                              role: 'parent',
                              title: parent!.name,
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
        ),
      ),
    );
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomCircularIndicator()),
    );
  }

  TextStyle sideDes = kalamLight.copyWith(color: defaultLight, fontSize: 14);
}
