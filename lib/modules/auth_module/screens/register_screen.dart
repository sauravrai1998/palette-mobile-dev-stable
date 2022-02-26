// import 'dart:async';

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/admin_dashboard_module/screens/admin_dashboard_navbar.dart';
import 'package:palette/modules/advisor_dashboard_module/screens/advisor_dashboard_with_navbar.dart';
import 'package:palette/modules/auth_module/bloc/auth_bloc.dart';
import 'package:palette/modules/auth_module/bloc/auth_events.dart';
import 'package:palette/modules/auth_module/bloc/auth_states.dart';
import 'package:palette/modules/auth_module/models/login_model.dart';
import 'package:palette/modules/auth_module/screens/login_screen.dart';
import 'package:palette/modules/auth_module/services/auth_pendo_repo.dart';
import 'package:palette/modules/chat_module/services/chat_pendo_repo.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/observer_dashboard_module/screens/observer_dashboard_navbar.dart';
import 'package:palette/modules/parent_dashboard_module/screens/parent_dashboard_with_navbar.dart';
import 'package:palette/modules/profile_module/models/user_models/abstract_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/admin_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/modules/student_dashboard_module/widgets/unread_counter_empty_widget.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/screens/student_dashboard_with_navbar.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../common_components/common_components_link.dart';

class RegisterScreen extends StatefulWidget {
  final String email;
  RegisterScreen({required this.email});

  @override
  State<RegisterScreen> createState() => _RegisterScreen();
}

class _RegisterScreen extends State<RegisterScreen> {
  FocusNode? emailFocus;
  TextEditingController passwordController1 = TextEditingController();
  FocusNode? passwordFocus1;
  TextEditingController passwordController2 = TextEditingController();
  FocusNode? passwordFocus2;
  bool startRegistration = false;
  BaseProfileUserModel? _baseProfileUserModel;
  bool fetchingProfileScreenUser = false;
  String? role;
  @override
  void initState() {
    emailFocus = FocusNode();
    passwordFocus1 = FocusNode();
    passwordFocus2 = FocusNode();
    super.initState();
    _getSfidAndRole();
    AuthPendoRepo.trackUserExistEvent(
        context: context,
        userEmail: widget.email.toLowerCase(),
        role: role ?? '');
    _modalBottomSheetMenu();
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString(roleFromUserExistAPIKey);
    setState(() {});
  }

  void _modalBottomSheetMenu() async {
    final prefs = await SharedPreferences.getInstance();
    var role = prefs.getString(roleFromUserExistAPIKey);
    if (role == null) return;
    role = role.toLowerCase();

    if (role == 'student' || role == 'guardian') {
      final _boxShadow = [
        BoxShadow(
          color: todoListActiveTab.withOpacity(0.25),
          blurRadius: 4,
          offset: Offset(0, 2),
        ),
      ];
      WidgetsBinding.instance!.addPostFrameCallback((_) async {
        await showModalBottomSheet(
            elevation: 2,
            isDismissible: false,
            enableDrag: false,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(18),
                topRight: Radius.circular(18),
              ),
            ),
            context: context,
            builder: (builder) {
              return Semantics(
                label:
                    "Please accept ferpa compliance in order to register a new account",
                child: Column(
                  children: [
                    SizedBox(height: 22),
                    Text(
                      'FERPA Compliance',
                      style: roboto700.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(height: 30),
                    Expanded(
                      child: Scrollbar(
                        isAlwaysShown: true,
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 35, right: 40),
                            child: Text(
                              ferpaCompilanceText,
                              style: robotoTextStyle.copyWith(fontSize: 14),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                            Helper.showGenericDialog(
                                title: 'Oops...',
                                barrierDismissible: false,
                                body:
                                    'You need to accept in order to create an account',
                                context: context,
                                okAction: () {
                                  Navigator.pushAndRemoveUntil(
                                      context,
                                      MaterialPageRoute(
                                          builder: (BuildContext context) =>
                                              LoginScreen()),
                                      (Route<dynamic> route) => false);
                                });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: white,
                                border: Border.all(color: todoListActiveTab),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _boxShadow),
                            height: 32,
                            width: 120,
                            child: Center(
                                child: Text(
                              'DENY',
                              style: TextStyle(color: todoListActiveTab),
                            )),
                          ),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pop(context);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: todoListActiveTab,
                                border: Border.all(color: todoListActiveTab),
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: _boxShadow),
                            height: 32,
                            width: 120,
                            child: Center(
                                child: Text(
                              'ACCEPT',
                              style: TextStyle(color: white),
                            )),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 12),
                  ],
                ),
              );
            });
      });
    }
  }

  bool validateStructure(String value) {
    String pattern = r'^[a-zA-Z0-9!@#$%^&*()_+\-=\[\]{};:\\|,.<>\/?]{6,}$';
    // r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{6,}$';
    RegExp regExp = new RegExp(pattern);
    return regExp.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return TextScaleFactorClamper(
      child: SafeArea(
        child: Semantics(
          label:
              "Please enter your email address below and hit the continue button at the bottom of the screen to continue.",
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: Container(
              height: devHeight - MediaQuery.of(context).padding.top,
              child: SingleChildScrollView(
                physics: RangeMaintainingScrollPhysics(),
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: pureblack,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                    Container(
                      width: devWidth * .6,
                      padding: EdgeInsets.only(
                          top: devHeight * 0.07, bottom: devHeight * .1),
                      child: Image.asset(
                        'images/palettelogonobg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(
                        devWidth * 0.075,
                        0,
                        devWidth * 0.075,
                        0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                              child: Text("Welcome to Palette!",
                                  style: montserratSemiBoldTextStyle.copyWith(
                                      fontSize: 22))),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                                "Entered email address: \n${widget.email} \nPlease select your password",
                                style: montserratSemiBoldTextStyle.copyWith(
                                    color: colorForPlaceholders)),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  devWidth * 0.0,
                                  20,
                                  devWidth * 0.0,
                                  0,
                                ),
                                child: CommonTextField(
                                  height: 60,
                                  hintText: 'Enter Password',
                                  inputController: passwordController1,
                                  inputFocus: passwordFocus1,
                                  password: true,
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.fromLTRB(
                                  devWidth * 0.0,
                                  20,
                                  devWidth * 0.0,
                                  0,
                                ),
                                child: CommonTextField(
                                  height: 60,
                                  hintText: 'Confirm Password',
                                  inputController: passwordController2,
                                  inputFocus: passwordFocus2,
                                  password: true,
                                ),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    devWidth * 0.0,
                                    20,
                                    devWidth * 0.0,
                                    0,
                                  ),
                                  child: registerButton(onTap: () async {
                                    final prefs =
                                        await SharedPreferences.getInstance();
                                    var role = prefs
                                        .getString(roleFromUserExistAPIKey);
                                    AuthPendoRepo.trackNewUserRegisterEvent(
                                        context: context,
                                        userEmail: widget.email.toLowerCase(),
                                        role: role ?? '');
                                    final bloc = context.read<AuthBloc>();
                                    if (validateStructure(
                                            passwordController1.text) &&
                                        validateStructure(
                                            passwordController2.text)) {
                                      if (passwordController1.text ==
                                          passwordController2.text) {
                                        bloc.add(
                                          PreRegisterEvent(
                                              registerData: LoginModel(
                                            email: widget.email,
                                            password: passwordController1.text,
                                          )),
                                        );
                                        setState(() {
                                          startRegistration = true;
                                        });
                                      } else {
                                        passwordController1.clear();
                                        passwordController2.clear();
                                        Helper.showGenericDialog(
                                            title: 'Passwords do not match',
                                            body:
                                                'Please input the passwords and try again',
                                            context: context,
                                            okAction: () {
                                              Navigator.pop(context);
                                            });
                                      }
                                    } else {
                                      passwordController1.clear();
                                      passwordController2.clear();
                                      Helper.showGenericDialog(
                                          body:
                                              'Passwords must be at least 6 characters long',
                                          context: context,
                                          okAction: () {
                                            Navigator.pop(context);
                                          });
                                    }
                                  })),
                              Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    devWidth * 0.0,
                                    20,
                                    devWidth * 0.0,
                                    40,
                                  ),
                                  child: alreadHaveAccountButton(
                                      onTap: startRegistration
                                          ? () {}
                                          : () {
                                              Navigator.pushAndRemoveUntil(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          LoginScreen()),
                                                  (Route<dynamic> route) =>
                                                      false);
                                            }))
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
      ),
    );
  }

  Widget registerButton({required Function() onTap}) {
    return BlocListener(
        bloc: context.read<AuthBloc>(),
        listener: (context, state) async {
          if (startRegistration) {
            if (state is PreRegisterSuccessState) {
              String preRegisterMessage =
                  'The user has been registered successfully.';
              Helper.showGenericDialog(
                  body: preRegisterMessage,
                  context: context,
                  okAction: () {
                    // Navigator.pushAndRemoveUntil(
                    //     context,
                    //     MaterialPageRoute(
                    //         builder: (BuildContext context) => LoginScreen()),
                    //     (Route<dynamic> route) => false);
                    final bloc = context.read<AuthBloc>();
                    bloc.add(
                      LoginEvent(
                          loginData: LoginModel(
                        email: widget.email,
                        password: passwordController1.text,
                      )),
                    );
                    Navigator.pop(context);
                  }
                  // okAction: () async {
                  //   await navigateNext();
                  // }
                  );

              print('success');
            } else if (state is LoginSuccessState) {
              await navigateNext();
            } else if (state is LoginFailedState) {
              setState(() => startRegistration = false);
              Helper.showGenericDialog(
                  title: 'Oops...',
                  body: state.error,
                  context: context,
                  okAction: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => LoginScreen()),
                        (Route<dynamic> route) => false);
                  });
            } else if (state is PreRegisterFailedState) {
              setState(() => startRegistration = false);
              Helper.showGenericDialog(
                  title: 'Oops...',
                  body: state.error,
                  context: context,
                  okAction: () {
                    Navigator.pop(context);
                  });
            }
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
          child: Center(
            child: BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
              return Material(
                color: state is PreRegisterLoadingState
                    ? Colors.white
                    : Colors.black,
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
                            if (state is PreRegisterLoadingState) {
                              return CustomPaletteLoader();
                            } else if (state is LoginLoadingState || state is LoginSuccessState ) {
                              return Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Text("LOGGING IN...",
                                      style: montserratBoldTextStyle.copyWith(
                                          color: white)),
                                  Container(
                                    width: 30,
                                    height: 17,
                                    child: CustomPaletteLoader(),
                                  )
                                ],
                              );
                            } else {
                              return Text("REGISTER",
                                  style: montserratBoldTextStyle.copyWith(
                                      color: white));
                            }
                          },
                        )))),
              );
            }),
          ),
        ));
  }

  Widget alreadHaveAccountButton({required Function() onTap}) {
    return Container(
      child: Material(
        color: white,
        elevation: 0,
        borderRadius: BorderRadius.circular(10),
        child: InkWell(
            onTap: onTap,
            child: Container(
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                decoration: BoxDecoration(
                  color: Colors.transparent,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Center(
                    child: Text("Already have an account?",
                        style: montserratBoldTextStyle.copyWith(
                            fontSize: 16, color: Colors.black))))),
      ),
    );
  }

  navigateNext() async {
    await fetchProfileUser();
    _fetchChatContactsForPendoRepo();
    BlocProvider.of<GetContactsBloc>(context).add(GetContactsEvent());
    final prefs = await SharedPreferences.getInstance();
    final String role = prefs.getString('role').toString();
    unreadMessageCountMapStreamController =
        StreamController<Map<String, int>>();
    if (role == "Student") {
      print("calling");
      final bloc = context.read<TodoListBloc>();
      bloc.add(
        TodoListEvent(studentId: ''),
      );
      // BlocProvider.of<ProfileBloc>(context).add(GetEducationClassData());
      final student = _baseProfileUserModel as StudentProfileUserModel?;
      final instituteName = student?.educationList?.isNotEmpty ?? false
          ? student?.educationList?.first.instituteName ?? ''
          : '';
      final instituteLogo = student?.educationList?.isNotEmpty ?? false
          ? student?.educationList?.first.instituteLogo ?? ''
          : ''; 
      
      if (student != null) {
        prefs.setString(instituteNameKey, instituteName);
        prefs.setString(sfidConstant, student.id);
        prefs.setString(instituteLogoKey, instituteLogo);
      }
      

      final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
      pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
        visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
        accountId: student?.id ?? '',
        name: student?.name ?? '',
        instituteName: instituteName,
        instituteId: student?.educationList?.isNotEmpty ?? false
            ? student?.educationList?.first.instituteId ?? ''
            : '',
        instituteLogo: instituteLogo,
        role: 'Student',
      ));
      AuthPendoRepo.trackNewUserRegisterEvent(
          context: context, userEmail: widget.email, role: role);

      await Helper.setupPendoSDK();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => StudentDashboardWithNavbar(student: student),
          settings: RouteSettings(
            name: 'DashboardNavBar',
          ),),
        (Route<dynamic> route) => false,
      );
    } else if (role == "Observer") {
      final observer = _baseProfileUserModel as ObserverProfileUserModel?;
      final instituteName = observer?.instituteList?.isNotEmpty ?? false
          ? observer?.instituteList?.first.instituteName ?? ''
          : '';
      final instituteLogo = observer?.instituteList?.isNotEmpty ?? false
          ? observer?.instituteList?.first.instituteLogo ?? ''
          : '';

      if (observer != null) {
        prefs.setString(sfidConstant, observer.id);
        prefs.setString(instituteNameKey, instituteName);
        prefs.setString(instituteLogoKey, instituteLogo);
      }

      final pendoMetaDataBloc = BlocProvider.of<PendoMetaDataBloc>(context);
      pendoMetaDataBloc.add(PendoMetaDataWithValuesEvent(
        visitorId: FirebaseChatCore.instance.firebaseUser?.uid ?? '',
        accountId: observer?.id ?? '',
        name: observer?.name ?? '',
        instituteName: instituteName,
        instituteId: observer?.instituteList?.isNotEmpty ?? false
            ? observer?.instituteList?.first.instituteId ?? ''
            : '',
        instituteLogo: instituteLogo,
        role: 'Observer',
      ));
      AuthPendoRepo.trackNewUserRegisterEvent(
          context: context, userEmail: widget.email, role: role);

      await Helper.setupPendoSDK();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ObserverDashboardWithNavbar(observer: observer),
          settings: RouteSettings(
            name: 'DashboardNavBar',
          ),),
        (Route<dynamic> route) => false,
      );
    } else if (role == "Advisor" || role.toLowerCase() == "faculty/staff") {
      final advisor = _baseProfileUserModel as AdvisorProfileUserModel?;

      if (advisor != null) {
        prefs.setString(instituteNameKey, advisor.instituteName ?? '');
        prefs.setString(sfidConstant, advisor.id);
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
      AuthPendoRepo.trackNewUserRegisterEvent(
          context: context, userEmail: widget.email, role: role);

      await Helper.setupPendoSDK();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => AdvisorDashboardWithNavbar(advisor: advisor),
          settings: RouteSettings(
            name: 'DashboardNavBar',
          ),),
        (Route<dynamic> route) => false,
      );
    } else if (role == "Admin") {
      final admin = _baseProfileUserModel as AdminProfileUserModel?;

      if (admin != null) {
        prefs.setString(sfidConstant, admin.id);
        prefs.setString(instituteNameKey, admin.instituteName ?? '');
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

      AuthPendoRepo.trackNewUserRegisterEvent(
          context: context, userEmail: widget.email, role: role);

      await Helper.setupPendoSDK();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => AdminDashboardWithNavbar(admin: admin),
          settings: RouteSettings(
            name: 'DashboardNavBar',
          ),),
        (Route<dynamic> route) => false,
      );
    } else {
      final parent = _baseProfileUserModel as ParentProfileUserModel?;

      if (parent != null) {
        prefs.setString(sfidConstant, parent.id);
        prefs.setString(instituteNameKey, parent.instituteName ?? '');
        prefs.setString(instituteLogoKey, parent.instituteLogo ?? '');
        prefs.setString(instituteIdKey, parent.instituteId );
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

      AuthPendoRepo.trackNewUserRegisterEvent(
          context: context, userEmail: widget.email, role: role);

      await Helper.setupPendoSDK();

      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (context) => ParentDashboardWithNavbar(parent: parent),
          settings: RouteSettings(
            name: 'DashboardNavBar',
          ),),
        (Route<dynamic> route) => false,
      );
    }
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
}
