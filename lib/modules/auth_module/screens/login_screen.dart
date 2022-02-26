import 'dart:async';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/admin_dashboard_module/screens/admin_dashboard_navbar.dart';
import 'package:palette/modules/advisor_dashboard_module/screens/advisor_dashboard_with_navbar.dart';
import 'package:palette/modules/auth_module/bloc/auth_bloc.dart';
import 'package:palette/modules/auth_module/bloc/auth_events.dart';
import 'package:palette/modules/auth_module/bloc/auth_states.dart';
import 'package:palette/modules/auth_module/models/login_model.dart';
import 'package:palette/modules/chat_module/services/chat_pendo_repo.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/observer_dashboard_module/screens/observer_dashboard_navbar.dart';
import 'package:palette/modules/parent_dashboard_module/screens/parent_dashboard_with_navbar.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/admin_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/modules/share_drawer_module/screens/share_screen_view.dart';
import 'package:palette/modules/student_dashboard_module/widgets/unread_counter_empty_widget.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/screens/student_dashboard_with_navbar.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/validation_regex.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import 'check_user_exist.dart';
import 'forgot_password_screen.dart';

class LoginScreen extends StatefulWidget {
  final String? urlLink;

  const LoginScreen({Key? key, this.urlLink}) : super(key: key);
  @override
  State<LoginScreen> createState() => _LoginScreen();
}

class _LoginScreen extends State<LoginScreen> {
  TextEditingController emailController = TextEditingController();
  FocusNode? emailFocus;
  TextEditingController passwordController = TextEditingController();
  FocusNode? passwordFocus;
  BaseProfileUserModel? _baseProfileUserModel;
  bool fetchingProfileScreenUser = false;
  bool emailpassFieldEnable = true;

  @override
  void initState() {
    emailFocus = FocusNode();
    passwordFocus = FocusNode();
    super.initState();
    log("At Init state Url is:${widget.urlLink}");
  }

  bool validateStructure(String value) {
    String pattern =
        r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return SafeArea(
      child: TextScaleFactorClamper(
        child: Semantics(
          label:
              "Welcome to Palette. Please enter your details in the text fields for email and password below and click the log in button just below them to log in and access the app. In case of a forgotten password, there is a link for the same under the password field. If you are not an existing user, please click the new user button at the bottom to register with us.",
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: SingleChildScrollView(
              physics: RangeMaintainingScrollPhysics(),
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: devHeight * 0.1,
                  ),
                  Container(
                      width: devWidth,
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.end,
                        alignment: WrapAlignment.center,
                        spacing: 6,
                        children: [
                          SvgPicture.asset('images/p.svg',
                              height: devHeight * 0.09),
                          SvgPicture.asset('images/a.svg',
                              height: devHeight * 0.09),
                          SvgPicture.asset('images/l.svg',
                              height: devHeight * 0.09),
                          Hero(
                              tag: 'logo',
                              child: SvgPicture.asset('images/paletteimage.svg',
                                  height: devHeight * 0.09)),
                          SvgPicture.asset('images/t.svg',
                              height: devHeight * 0.09),
                          SvgPicture.asset('images/t.svg',
                              height: devHeight * 0.09),
                          SvgPicture.asset('images/e.svg',
                              height: devHeight * 0.09),
                        ],
                      )),
                  SizedBox(height: devHeight * 0.19),
                  Container(
                    margin: EdgeInsets.fromLTRB(
                        devWidth * 0.075, devHeight * 0, devWidth * 0.075, 0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  devWidth * 0.0, 20, devWidth * 0.0, 0),
                              child: CommonTextField(
                                height: 60,
                                hintText: 'Enter Email Address',
                                inputController: emailController,
                                inputFocus: emailFocus,
                                fieldEnabled: emailpassFieldEnable,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.fromLTRB(
                                  devWidth * 0.0, 20, devWidth * 0.0, 0),
                              child: CommonTextField(
                                height: 60,
                                hintText: 'Enter password',
                                inputController: passwordController,
                                inputFocus: passwordFocus,
                                password: true,
                                fieldEnabled: emailpassFieldEnable,
                              ),
                            ),
                            Container(
                                padding: EdgeInsets.fromLTRB(
                                    devWidth * 0.0, 20, devWidth * 0.0, 0),
                                child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Material(
                                        color: Colors.transparent,
                                        child: InkWell(
                                            onTap: emailpassFieldEnable == true
                                                ? () {
                                                    Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              ForgotPassword()),
                                                    );
                                                  }
                                                : () {},
                                            child: Text("Forgot Password ?",
                                                style:
                                                    montserratSemiBoldTextStyle)),
                                      )
                                    ])),
                          ],
                        ),
                        SizedBox(height: devHeight * 0.05),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                                padding: EdgeInsets.fromLTRB(
                                    devWidth * 0.0, 20, devWidth * 0.0, 0),
                                child: loginButton(
                                    onTap: emailpassFieldEnable == true
                                        ? () {
                                            final bloc =
                                                context.read<AuthBloc>();

                                            bool validEmail = Validator
                                                .emailValid
                                                .hasMatch(emailController.text
                                                    .trim());

                                            if (emailController.text.isEmpty &&
                                                passwordController
                                                    .text.isEmpty) {
                                              Helper.showGenericDialog(
                                                  body:
                                                      'Please enter your credentials',
                                                  context: context,
                                                  okAction: () {
                                                    Navigator.pop(context);
                                                  });
                                            } else if (!validEmail) {
                                              Helper.showGenericDialog(
                                                  body:
                                                      'Please enter a valid email',
                                                  context: context,
                                                  okAction: () {
                                                    Navigator.pop(context);
                                                  });
                                            } else if (passwordController
                                                    .text.isNotEmpty &&
                                                validEmail) {
                                              setState(() {
                                                emailpassFieldEnable = false;
                                              });
                                              bloc.add(
                                                LoginEvent(
                                                    loginData: LoginModel(
                                                  email: emailController.text
                                                      .toLowerCase(),
                                                  password:
                                                      passwordController.text,
                                                )),
                                              );
                                            }
                                          }
                                        : () {})),
                            Container(
                                padding: EdgeInsets.fromLTRB(
                                    devWidth * 0.0, 20, devWidth * 0.0, 40),
                                child: newUserButton(
                                    onTap: emailpassFieldEnable == true
                                        ? () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      CheckUserExistScreen()),
                                            );
                                          }
                                        : () {})),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget loginButton({required Function() onTap}) {
    return BlocListener(
      bloc: context.read<AuthBloc>(),
      listener: (context, state) async {
        if (state is LoginSuccessState) {
          await navigateNext();
        } else if (state is LoginFailedState) {
          setState(() {
            emailpassFieldEnable = true;
          });
          Helper.showGenericDialog(
              title: 'Oops...',
              body: state.error,
              context: context,
              okAction: () {
                Navigator.pop(context);
              });
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
          return Material(
            color: state is LoginLoadingState || fetchingProfileScreenUser
                ? Colors.white
                : pureblack,
            elevation: 0,
            borderRadius: BorderRadius.circular(10),
            child: InkWell(
                onTap: onTap,
                child: Container(
                    padding: EdgeInsets.all(15),
                    decoration: BoxDecoration(
                      color: Colors.transparent,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(child: BlocBuilder<AuthBloc, AuthState>(
                      builder: (context, state) {
                        if (state is LoginLoadingState ||
                            fetchingProfileScreenUser) {
                          return CustomPaletteLoader();
                        } else {
                          //return CustomPaletteLoader();
                          return Text("LOG IN",
                              style: montserratBoldTextStyle.copyWith(
                                color: white,
                              ));
                        }
                      },
                    )))),
          );
        }),
      ),
    );
  }

  Widget newUserButton({required Function() onTap}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: pureblack, width: 3.4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 5,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Material(
        color: Colors.white,
        elevation: 0,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
            onTap: onTap,
            child: Container(
                padding: EdgeInsets.all(15),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text("NEW USER",
                        style: montserratBoldTextStyle.copyWith(
                            color: pureblack))))),
      ),
    );
  }

  Future fetchProfileUser() async {
    fetchingProfileScreenUser = true;
    try {
      _baseProfileUserModel = await ProfileRepository.instance.getProfileUser();
    } catch (e) {
      print(e.toString());
    }
    fetchingProfileScreenUser = false;
  }

  Future _fetchChatContactsForPendoRepo() async {
    final chatContactList = await ChatRepository.instance.getChatContactList();
    ChatPendoRepo.chatContacts = chatContactList;
  }

  navigateToAndroidShareDrawer(BuildContext context) {
    log("Navigating to Android share drawer");
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (_) => ShareScreenView(urlLink: widget.urlLink ?? "")));
  }

  handleNavigation(BuildContext context, String role) {
    log("ShouldNavigate Result is---------->${widget.urlLink}");
    if (widget.urlLink != null) {
      navigateToAndroidShareDrawer(context);
    } else {
      if (role == "Student") {
        final student = _baseProfileUserModel as StudentProfileUserModel?;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => StudentDashboardWithNavbar(student: student),
            settings: RouteSettings(
              name: 'DashboardNavBar',
            ),
          ),
        );
      } else if (role == "Observer") {
        final observer = _baseProfileUserModel as ObserverProfileUserModel?;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                ObserverDashboardWithNavbar(observer: observer),
            settings: RouteSettings(
              name: 'DashboardNavBar',
            ),
          ),
        );
      } else if (role == "Advisor" || role.toLowerCase() == "faculty/staff") {
        final advisor = _baseProfileUserModel as AdvisorProfileUserModel?;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdvisorDashboardWithNavbar(advisor: advisor),
            settings: RouteSettings(
              name: 'DashboardNavBar',
            ),
          ),
        );
      } else if (role == "Admin") {
        final admin = _baseProfileUserModel as AdminProfileUserModel?;

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminDashboardWithNavbar(admin: admin),
            settings: RouteSettings(
              name: 'DashboardNavBar',
            ),
          ),
        );
      } else {
        final parent = _baseProfileUserModel as ParentProfileUserModel?;
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ParentDashboardWithNavbar(parent: parent),
            settings: RouteSettings(
              name: 'DashboardNavBar',
            ),
          ),
        );
      }
    }
  }

  navigateNext() async {
    log("NavigateNext Called");
    _fetchChatContactsForPendoRepo();
    BlocProvider.of<GetContactsBloc>(context).add(GetContactsEvent());
    await fetchProfileUser();
    final prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role').toString();
    unreadMessageCountMapStreamController =
        StreamController<Map<String, int>>();

    if (role == "Student") {
      final bloc = context.read<TodoListBloc>();
      bloc.add(
        TodoListEvent(studentId: ''),
      );
      final bloc1 = context.read<RefreshProfileBloc>();
      bloc1.add(
        RefreshUserProfileDetails(),
      );
      // BlocProvider.of<ProfileBloc>(context).add(GetEducationClassData());
      final student = _baseProfileUserModel as StudentProfileUserModel?;
      final instituteName = student?.educationList?.isNotEmpty ?? false
          ? student?.educationList?.first.instituteName ?? ''
          : '';
      final instituteId = student?.educationList?.isNotEmpty ?? false
          ? student?.educationList?.first.instituteId ?? ''
          : '';
      final instituteLogo = student?.educationList?.isNotEmpty ?? false
          ? student?.educationList?.first.instituteLogo ?? ''
          : '';

      if (student != null) {
        prefs.setString(sfidConstant, student.id);
        prefs.setString(instituteNameKey, instituteName);
        prefs.setString(instituteIdKey, instituteId);
        prefs.setString(instituteLogoKey, instituteLogo);
      }

      final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
      pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
        visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
        accountId: student?.id ?? '',
        name: student?.name ?? '',
        instituteName: instituteName,
        instituteId: instituteId,
        instituteLogo: instituteLogo,
        role: 'Student',
      ));

      await Helper.setupPendoSDK();
    } else if (role == "Observer") {
      final observer = _baseProfileUserModel as ObserverProfileUserModel?;

      final instituteName = observer?.instituteList?.isNotEmpty ?? false
          ? observer?.instituteList?.first.instituteName ?? ''
          : '';

      final instituteId = observer?.instituteList?.isNotEmpty ?? false
          ? observer?.instituteList?.first.instituteId ?? ''
          : '';

      final instituteLogo = observer?.instituteList?.isNotEmpty ?? false
          ? observer?.instituteList?.first.instituteLogo ?? ''
          : '';

      if (observer != null) {
        prefs.setString(sfidConstant, observer.id);
        prefs.setString(instituteNameKey, instituteName);
        prefs.setString(instituteIdKey, instituteId);
        prefs.setString(instituteLogoKey, instituteLogo);
      }

      final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
      pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
        visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
        accountId: observer?.id ?? '',
        name: observer?.name ?? '',
        instituteName: instituteName,
        instituteId: instituteId,
        instituteLogo: instituteLogo,
        role: 'Observer',
      ));

      final bloc = context.read<RefreshProfileBloc>();
      bloc.add(
        RefreshUserProfileDetails(),
      );

      await Helper.setupPendoSDK();
    } else if (role == "Advisor" || role.toLowerCase() == "faculty/staff") {
      final advisor = _baseProfileUserModel as AdvisorProfileUserModel?;
      final bloc = context.read<RefreshProfileBloc>();

      if (advisor != null) {
        prefs.setString(sfidConstant, advisor.id);
        prefs.setString(instituteNameKey, advisor.instituteName ?? '');
        prefs.setString(instituteIdKey, advisor.instituteId);
        prefs.setString(instituteLogoKey, advisor.instituteLogo ?? '');
      }

      final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
      pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
        visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
        accountId: advisor?.id ?? '',
        name: advisor?.name ?? '',
        instituteName: advisor?.instituteName ?? '',
        instituteId: advisor?.instituteId ?? '',
        instituteLogo: advisor?.instituteLogo ?? '',
        role: 'Advisor',
      ));

      bloc.add(
        RefreshUserProfileDetails(),
      );

      await Helper.setupPendoSDK();
    } else if (role == "Admin") {
      final admin = _baseProfileUserModel as AdminProfileUserModel?;

      if (admin != null) {
        prefs.setString(instituteNameKey, admin.instituteName ?? '');
        prefs.setString(sfidConstant, admin.id);
        prefs.setString(instituteIdKey, admin.instituteId);
        prefs.setString(instituteLogoKey, admin.instituteLogo ?? '');
      }

      final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
      pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
        visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
        accountId: admin?.id ?? '',
        name: admin?.name ?? '',
        instituteName: admin?.instituteName ?? '',
        instituteId: admin?.instituteId ?? '',
        instituteLogo: admin?.instituteLogo ?? '',
        role: 'Admin',
      ));

      final bloc = context.read<RefreshProfileBloc>();
      bloc.add(
        RefreshUserProfileDetails(),
      );

      await Helper.setupPendoSDK();
    } else {
      final parent = _baseProfileUserModel as ParentProfileUserModel?;

      if (parent != null) {
        prefs.setString(sfidConstant, parent.id);
        prefs.setString(instituteNameKey, parent.instituteName ?? '');
        prefs.setString(instituteIdKey, parent.instituteId);
        prefs.setString(instituteLogoKey, parent.instituteLogo ?? '');
      }

      final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
      pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
        visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
        accountId: parent?.id ?? '',
        name: parent?.name ?? '',
        instituteName: parent?.instituteName ?? '',
        instituteId: parent?.instituteId ?? '',
        instituteLogo: parent?.instituteLogo ?? '',
        role: 'Parent',
      ));

      final bloc = context.read<RefreshProfileBloc>();
      bloc.add(
        RefreshUserProfileDetails(),
      );

      await Helper.setupPendoSDK();
    }
    if (mounted) handleNavigation(context, role);
  }
}
