import 'package:flutter/material.dart';
import 'package:palette/modules/share_drawer_module/model/sharing_content_model.dart';
import 'package:palette/modules/share_drawer_module/screens/share_create_opportunity_screens/share_create_opportunity_form.dart'
    as oppurtunity;
import 'package:palette/modules/share_drawer_module/screens/share_create_todo/share_create_todo.dart';
import 'package:palette/modules/share_drawer_module/screens/share_send_chat/share_send_chat.dart';
import 'package:palette/modules/share_drawer_module/widgets/sharing_card_item.dart';

Widget sharedBottomSheet(BuildContext context,
        {bool isLink = true, String text = ""}) =>
    !isLink
        ? Container(
            height: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle),
                  child: Icon(
                    Icons.warning_outlined,
                    size: 50,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 40),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.centerRight,
                        child: Icon(
                          Icons.link,
                          size: 30,
                        ),
                        margin: EdgeInsets.only(right: 15),
                      ),
                      Text(
                        "Only links can be shared.",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 20),
                      ),
                    ],
                  ),
                )
              ],
            ),
          )
        : Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20)),
            child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                image: AssetImage(
                  "images/logo_with_opacity.png",
                ),
                alignment: Alignment.topLeft,
              )),
              padding: EdgeInsets.symmetric(horizontal: 30),
              child: SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(children: [
                  Center(
                    child: Container(
                      width: 100,
                      padding: EdgeInsets.only(top: 12, bottom: 24),
                      child: Divider(
                        thickness: 4,
                        color: Color(0xFF7A7A7A),
                      ),
                    ),
                  ),
                  Text(
                    "Share",
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 26),
                  ),
                  SharingCardItem(
                      model: SharingContentModel(
                          title: "Opportunity",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        oppurtunity.ShareCreateOpportunityForm(
                                          urlLink: text,
                                        )));
                          },
                          description:
                              "Create an opportunity for your students or program.",
                          leadingSvg: "images/explore_black.svg",
                          trailingIconColor: Color(0xFFB62931))),
                  SharingCardItem(
                      model: SharingContentModel(
                          title: "To-do",
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShareCreateTodoForm(
                                          urlLink: text,
                                        )));
                          },
                          description:
                              "Create a to-do for your students or program.",
                          leadingSvg: "images/todo_black.svg",
                          trailingIconColor: Color(0xFF6C67F2))),
                  SharingCardItem(
                      iconSize: 20,
                      model: SharingContentModel(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShareSendChatPage(
                                          urlLink: text,
                                        )));
                          },
                          title: "Chat",
                          description:
                              "Chat with your students and those in their networks.",
                          leadingSvg: "images/chat_icon_nav_bar.svg",
                          trailingIconColor: Color(0xFF44A13B))),
                  SizedBox(
                    height: 20,
                  ),
                ], crossAxisAlignment: CrossAxisAlignment.center),
              ),
            ),
          );
