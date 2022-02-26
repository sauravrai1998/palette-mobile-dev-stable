import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/modules/share_drawer_module/model/sharing_content_model.dart';
import 'package:palette/modules/share_drawer_module/widgets/sharing_card_item.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'share_create_opportunity_screens/share_create_opportunity_form.dart';
import 'share_create_todo/share_create_todo.dart';
import 'share_send_chat/share_send_chat.dart';

class ShareScreenView extends StatefulWidget {
  final String urlLink;
  const ShareScreenView({Key? key, required this.urlLink}) : super(key: key);

  @override
  State<ShareScreenView> createState() => _ShareScreenViewState();
}

class _ShareScreenViewState extends State<ShareScreenView> {
  String role = "";

  String oppDesc = "";
  String todoDesc = "";
  String chatDesc = "";

  bool isObserever = false;

  @override
  void initState() {
    super.initState();
    getRole();
  }

  getRole() async {
    role = (await SharedPreferences.getInstance()).getString('role').toString();

    if (role == "Student") {
      oppDesc =
          "Create an opportunity for yourself, for those in your network or your program.";
      todoDesc = "Create a To-Do for yourself, for those in your network.";
      chatDesc = "Chat with people in your network.";
    } else {
      oppDesc = "Create an opportunity for your students or program.";
      todoDesc = "Create a to-do for your students.";
      chatDesc = "Chat with your students and those in their networks.";
    }
    isObserever = role == "Observer";
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned(child: Image.asset("images/logo_with_opacity.png")),
          Scaffold(
            body: Container(
              padding: EdgeInsets.only(top: 20),
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(20)),
              child: Container(
                child: Column(
                  children: [
                    AppBar(
                      elevation: 0,
                      centerTitle: true,
                      title: Text(
                        "Share",
                        style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 26,
                            color: Colors.black),
                      ),
                      backgroundColor: Colors.transparent,
                      leading: IconButton(
                          onPressed: () {
                            exit(0);
                          },
                          icon: SvgPicture.asset("images/back_button.svg")),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 30),
                        child: SingleChildScrollView(
                          physics: BouncingScrollPhysics(),
                          child: Column(
                            children: [
                              if (!isObserever)
                                SharingCardItem(
                                    model: SharingContentModel(
                                        title: "Opportunity",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShareCreateOpportunityForm(
                                                        urlLink: widget.urlLink,
                                                      )));
                                        },
                                        description: oppDesc,
                                        leadingSvg: "images/explore_black.svg",
                                        trailingIconColor: Color(0xFFB62931))),
                              if (!isObserever)
                                SharingCardItem(
                                    model: SharingContentModel(
                                        title: "To-do",
                                        onTap: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ShareCreateTodoForm(
                                                        urlLink: widget.urlLink,
                                                      )));
                                        },
                                        description: todoDesc,
                                        leadingSvg: "images/todo_black.svg",
                                        trailingIconColor: Color(0xFF6C67F2))),
                              SharingCardItem(
                                  iconSize: 20,
                                  model: SharingContentModel(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ShareSendChatPage(
                                                      urlLink: widget.urlLink,
                                                    )));
                                      },
                                      title: "Chat",
                                      description: chatDesc,
                                      leadingSvg:
                                          "images/chat_icon_nav_bar.svg",
                                      trailingIconColor: Color(0xFF44A13B))),
                            ],
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            mainAxisSize: MainAxisSize.max,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            backgroundColor: Colors.transparent,
          )
        ],
      ),
    );
  }
}
