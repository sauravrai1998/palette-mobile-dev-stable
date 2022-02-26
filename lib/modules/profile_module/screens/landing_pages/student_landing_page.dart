import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_circular_indicator.dart';
import 'package:palette/common_components/logout_button.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_events.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_states.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/student_profile_screen.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/modules/profile_module/widgets/landing_page_top_widget.dart';

import 'package:palette/utils/helpers.dart';

import '../../../../main.dart';

class StudentLandingPage extends StatefulWidget {
  @override
  _StudentLandingPageState createState() => _StudentLandingPageState();
}

class _StudentLandingPageState extends State<StudentLandingPage> {
  TextStyle sideDes = kalamLight.copyWith(color: defaultLight, fontSize: 14);
  StudentProfileUserModel? student;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return BlocProvider(
      create: (BuildContext context) {
        context.read<RefreshProfileBloc>().add(RefreshUserProfileDetails());
        return ProfileBloc(profileRepo: ProfileRepository.instance)
          ..add(GetProfileScreenUser());
      },
      child: TextScaleFactorClamper(
        child: SafeArea(
          child: Semantics(
            label:
                "Welcome to your home page. A tap on the lower half will navigate to your user dashboard and a tap on the upper half will navigate you to your profile. There is a button to log out of your session on the top right.",
            child: Scaffold(
              backgroundColor: defaultDark,
              body: Column(
                children: [
                  getTopWidget(screenHeight, screenWidth),
                  GestureDetector(
                    onTap: () {
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //       builder: (context) => StudentDashBoard()),
                      // );
                    },
                    child: Container(
                        height: screenHeight * 0.52,
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
                              height: 40,
                            ),
                            Expanded(child: Text("Education Screen"))
                          ],
                        )),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  getTopWidget(screenHeight, screenWidth) {
    return GestureDetector(
      onTap: () {
        if (student != null)
          Future.delayed(const Duration(milliseconds: 500), () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => StudentProfileScreen(student: student!),
              ),
            );
          });
      },
      child: Container(
        height: screenHeight * 0.45,
        color: defaultDark,
        child: BlocBuilder<ProfileBloc, ProfileState>(
          builder: (context, state) {
            if (state is ProfileUserLoadingState) {
              return _getLoadingIndicator();
            } else if (state is ProfileUserSuccessState) {
              student = state.profileUser as StudentProfileUserModel;
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

              return Stack(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: LogoutButton(),
                  ),
                  LandingPageTopWidget(
                    screenWidth: screenWidth,
                    screenHeight: screenHeight,
                    role: 'student',
                    title: student!.name,
                    subtitle: '${age + gender + mailingState}',
                  ),
                ],
              );
            }
            return Container();
          },
        ),
      ),
    );
  }

  callBackToAddSkill(newSkills, value) {
    print("printing DATA");
    print(newSkills);
    print(value);
    if (newSkills == null || value == null) {
    } else {
      print("call bach function called");
      setState(() {
        if (value == "Classes") {}
      });
    }
  }

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomCircularIndicator()),
    );
  }
}
