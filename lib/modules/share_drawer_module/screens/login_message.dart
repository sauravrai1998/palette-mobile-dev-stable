import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/modules/auth_module/screens/login_screen.dart';

class LoginMessage extends StatelessWidget {
  final String urlLink;
  const LoginMessage({Key? key, required this.urlLink}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(child: Image.asset("images/logo_with_opacity.png")),
          Scaffold(
            body: Column(
              children: [
                Expanded(
                    flex: 2,
                    child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 60),
                        child: Image.asset("images/palettelogonobg.png"))),
                Expanded(
                  child: SvgPicture.asset("images/login_info.svg"),
                  flex: 4,
                ),
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 45),
                        child: Text(
                          "You need to be logged in to share an opportunity on the application.",
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF89949C)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 15),
                        padding: EdgeInsets.symmetric(horizontal: 42),
                        child: MaterialButton(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            final page = LoginScreen(
                              urlLink: urlLink,
                            );

                            Navigator.of(context).pushAndRemoveUntil(
                                MaterialPageRoute(builder: (_) => page),
                                ModalRoute.withName('/login'));
                          },
                          color: Color(0xFF2B2A29),
                          child: Center(
                            child: Text(
                              "Log in".toUpperCase(),
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
              crossAxisAlignment: CrossAxisAlignment.center,
            ),
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: Colors.transparent,
              leading: IconButton(
                  onPressed: () {
                   exit(0);
                  },
                  icon: SvgPicture.asset("images/back_button.svg")),
            ),
          )
        ],
      ),
    );
  }
}
