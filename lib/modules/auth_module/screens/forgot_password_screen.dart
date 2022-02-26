import 'package:flutter/material.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_circular_indicator.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/auth_module/bloc/auth_events.dart';
import 'package:palette/modules/auth_module/bloc/auth_states.dart';
import 'package:palette/modules/auth_module/screens/login_screen.dart';
import 'package:palette/modules/auth_module/services/auth_pendo_repo.dart';
import 'package:palette/utils/konstants.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/auth_module/bloc/auth_bloc.dart';
import 'package:palette/utils/helpers.dart';

class ForgotPassword extends StatefulWidget {
  @override
  State<ForgotPassword> createState() => _ForgotPassword();
}

class _ForgotPassword extends State<ForgotPassword> {
  TextEditingController inputController = TextEditingController();
  FocusNode inputFocus = FocusNode();

  @override
  Widget build(BuildContext context) {
    var devWidth = MediaQuery.of(context).size.width;
    var devHeight = MediaQuery.of(context).size.height;
    return TextScaleFactorClamper(
      child: SafeArea(
        child: Semantics(
          label:
              "We understand that you need to reset your password. Please enter your registered email address below and a link to reset your password will be sent to that email address upon clicking the reset password button at the bottom of the screen.",
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: Container(
              height: devHeight - MediaQuery.of(context).padding.top,
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: pureblack,
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    Container(
                      width: devWidth * 0.6,
                      padding: EdgeInsets.only(
                          top: devHeight * 0.07, bottom: devHeight * .1),
                      child: Image.asset(
                        'images/palettelogonobg.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                    Container(
                        margin: EdgeInsets.fromLTRB(
                            devWidth * 0.075, 0, devWidth * 0.075, 0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                      child: Text(
                                          "Please enter your registered email address",
                                          style: montserratSemiBoldTextStyle
                                              .copyWith(fontSize: 22))),
                                  Padding(
                                      padding: EdgeInsets.fromLTRB(
                                        devWidth * 0.06,
                                        20,
                                        devWidth * 0.06,
                                        0,
                                      ),
                                      child: Center(
                                          child: Text(
                                              "A password reset link will be sent to your email address",
                                              style: montserratSemiBoldTextStyle
                                                  .copyWith(
                                                      color:
                                                          colorForPlaceholders)))),
                                  Padding(
                                    padding: EdgeInsets.fromLTRB(
                                      devWidth * 0.0,
                                      20,
                                      devWidth * 0.0,
                                      0,
                                    ),
                                    child: BlockSemantics(
                                      child: CommonTextField(
                                        height: 60,
                                        hintText: 'Enter Email Address',
                                        inputController: inputController,
                                        inputFocus: inputFocus,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: devHeight * 0.2),
                              Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                        padding: EdgeInsets.fromLTRB(
                                          devWidth * 0.0,
                                          20,
                                          devWidth * 0.0,
                                          40,
                                        ),
                                        child: resetPasswordButton(onTap: () {
                                          AuthPendoRepo
                                              .trackForgotPasswordEvent(
                                                  context: context,
                                                  userEmail: inputController
                                                      .text
                                                      .toLowerCase());
                                          final bloc = context.read<AuthBloc>();
                                          bloc.add(
                                            ForgotPasswordEvent(
                                                email: inputController.text
                                                    .toLowerCase()),
                                          );
                                        }))
                                  ])
                            ])),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget resetPasswordButton({required Function() onTap}) {
    return BlocListener(
      bloc: context.read<AuthBloc>(),
      listener: (context, state) async {
        if (state is ForgotPasswordSuccessState) {
          String forgotPasswordMessage =
              'An email has been successfully sent to reset your password. After you reset the password , come back to the app and login';
          Helper.showGenericDialog(
              body: forgotPasswordMessage,
              context: context,
              okAction: () {
                Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => LoginScreen()),
                    (Route<dynamic> route) => false);
              });

          print('success');
        } else if (state is ForgotPasswordFailedState) {
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
        child: Material(
          color: pureblack,
          elevation: 0,
          borderRadius: BorderRadius.circular(10),
          child: InkWell(
              onTap: onTap,
              child: Container(
                  padding: EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: Colors.transparent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: 5,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Center(child: BlocBuilder<AuthBloc, AuthState>(
                    builder: (context, state) {
                      if (state is ForgotPasswordLoadingState) {
                        return Container(
                          width: 30,
                          height: 17,
                          child: CustomCircularIndicator(),
                        );
                      } else {
                        return Text("RESET PASSWORD",
                            style:
                                montserratBoldTextStyle.copyWith(color: white));
                      }
                    },
                  )))),
        ),
      ),
    );
  }
}
