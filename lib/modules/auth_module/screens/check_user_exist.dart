import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/auth_module/bloc/auth_bloc.dart';
import 'package:palette/modules/auth_module/bloc/auth_events.dart';
import 'package:palette/modules/auth_module/bloc/auth_states.dart';
import 'package:palette/modules/auth_module/screens/register_screen.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class CheckUserExistScreen extends StatefulWidget {
  @override
  State<CheckUserExistScreen> createState() => _CheckUserExist();
}

class _CheckUserExist extends State<CheckUserExistScreen> {
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
              "Welcome to your registration for Palette. Please enter your email address below and hit the continue button at the bottom of the screen to continue.",
          child: Scaffold(
            backgroundColor: Colors.white,
            resizeToAvoidBottomInset: true,
            body: Container(
              height: devHeight - MediaQuery.of(context).padding.top,
              child: SingleChildScrollView(
                physics: RangeMaintainingScrollPhysics(),
                child: Column(children: <Widget>[
                  Semantics(
                    onTapHint: "Navigated back",
                    button: true,
                    child: Align(
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: Icon(Icons.arrow_back),
                        color: pureblack,
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                  Container(
                    width: devWidth * .6,
                    padding: EdgeInsets.only(top: devHeight * 0.07,bottom: devHeight * .1),
                    child: Image.asset('images/palettelogonobg.png'),
                  ),
                  Container(
                      margin: EdgeInsets.fromLTRB(
                          devWidth * 0.075, 0, devWidth * 0.075, 0),
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    child: Text("Welcome to Palette!",
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
                                            "Please enter the email address that your institute has used",
                                            style: montserratSemiBoldTextStyle
                                                .copyWith(
                                                    color:
                                                        colorForPlaceholders)))),
                                Padding(
                                  padding: EdgeInsets.fromLTRB(
                                    devWidth * 0.0,
                                    40,
                                    devWidth * 0.0,
                                    0,
                                  ),
                                  child: CommonTextField(
                                    height: 60,
                                    hintText: 'Enter Email Address',
                                    inputController: inputController,
                                    inputFocus: inputFocus,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: devHeight * .2,),
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
                                        if (inputController.text.isEmpty) {
                                          return;
                                        }
                                        final bloc = context.read<AuthBloc>();
                                        bloc.add(
                                          CheckUserExistsEvent(
                                              email: inputController.text
                                                  .toLowerCase()),
                                        );
                                      }))
                                ])
                          ])),
                  
                ]),
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
      listener: (context, state) {
        if (state is CheckUserExistSuccessState) {
          final route = MaterialPageRoute(
              builder: (_) => RegisterScreen(
                    email: inputController.text.toLowerCase(),
                  ));
          Navigator.push(context, route);
        } else if (state is CheckUserExistFailedState) {
          Helper.showGenericDialog(
              title: 'Oops...',
              body: state.err,
              context: context,
              okAction: () {
                Navigator.pop(context);
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
          child: Semantics(
            button: true,
            label: "Continue",
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
                        if (state is CheckUserExistLoadingState) {
                          return Builder(
                            builder: (_) {
                              if (MediaQuery.of(context).accessibleNavigation) {
                                return Container(
                                  width: 30,
                                  height: 17,
                                  child: CustomChasingDotsLoader(
                                    color: white,
                                  ),
                                );
                              } else {
                                return Container(
                                  width: 30,
                                  height: 17,
                                  child: CustomChasingDotsLoader(
                                    color: white,
                                  ),
                                );
                              }
                            },
                          );
                        } else {
                          return Text("CONTINUE",
                              style: montserratBoldTextStyle.copyWith(
                                  color: white));
                        }
                      },
                    )))),
          ),
        ),
      ),
    );
  }
}
