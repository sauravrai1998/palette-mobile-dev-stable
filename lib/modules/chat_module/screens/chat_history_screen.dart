import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:ntp/ntp.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_repos/common_pendo_repo.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/modules/chat_module/widgets/direct_chat_list_view.dart';
import 'package:palette/modules/chat_module/widgets/group_chat_list_view.dart';

import 'chat_select_contact_screen.dart';

class ChatHistoryScreen extends StatefulWidget {
  const ChatHistoryScreen({Key? key}) : super(key: key);

  @override
  _ChatHistoryScreenState createState() => _ChatHistoryScreenState();
}

class _ChatHistoryScreenState extends State<ChatHistoryScreen> {
  @override
  void initState() {
    super.initState();
    _calculateNTPOffset();
  }

  _calculateNTPOffset() async {
    final offset = await NTP.getNtpOffset(localTime: DateTime.now());
    deviceTimeOffset = offset;
  }

  var trackChatHistoryScreen = false;
  @override
  Widget build(BuildContext context) {
    if (trackChatHistoryScreen == false) {
      CommonPendoRepo.trackChatSectionVisit(context: context);
      trackChatHistoryScreen = true;
    }
    return StreamBuilder<List<types.User>>(
        stream: FirebaseChatCore.instance.users(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error occurred'));
          }

          List<types.User> users = snapshot.data as List<types.User>;
          final selfUid = FirebaseAuth.instance.currentUser!.uid;
          users = users.where((u) => selfUid != u.id).toList();

          ChatRepository.saveUsersMappingToSharedPrefs(users);
          return DefaultTabController(
            length: 2,
            child: SafeArea(
              child: TextScaleFactorClamper(
                child: Scaffold(
                  backgroundColor: Colors.white,
                  appBar: AppBar(
                    elevation: 0,
                    backgroundColor: Colors.white,
                    automaticallyImplyLeading: false,
                    title: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // IconButton(
                            //   icon: RotatedBox(
                            //       quarterTurns: 1,
                            //       child: SvgPicture.asset(
                            //         'images/dropdown.svg',
                            //         color: defaultDark,
                            //         semanticsLabel:
                            //             "Button to navigate back to the dashboard",
                            //       )),
                            //   onPressed: () {
                            //     Navigator.pop(context);
                            //   },
                            // ),
                            SizedBox(width: 10),
                            Text(
                              'Messages',
                              style: kalamTextStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        // IconButton(
                        //   icon: Icon(
                        //     Icons.more_vert,
                        //     color: defaultDark,
                        //     semanticLabel: "More",
                        //   ),
                        //   onPressed: () {},
                        // ),
                      ],
                    ),
                    centerTitle: false,
                    bottom: TabBar(
                      indicatorColor: chatDarkPurple,
                      indicatorSize: TabBarIndicatorSize.label,
                      onTap: (index) {
                        // Tab index when user select it, it start from zero
                      },
                      tabs: [
                        Tab(
                          child: Semantics(
                            label: "List of chat history",
                            child: ExcludeSemantics(
                              child: Text(
                                'Chat',
                                style: roboto700.copyWith(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Semantics(
                            label: "List of group chats",
                            child: ExcludeSemantics(
                              child: Text(
                                'Groups',
                                style: roboto700.copyWith(
                                  fontSize: 20,
                                  color: Colors.black,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  body: TabBarView(
                    children: [
                      DirectChatListView(),
                      GroupChatListView(),
                    ],
                  ),
                  floatingActionButton: Container(
                    height: 38,
                    width: 38,
                    margin: EdgeInsets.only(bottom: 10),
                    child: PopupMenuButton(
                      onSelected: (value) {
                        print(value);
                        if (value == 0) {
                          _newChatTapped(context);
                        } else {
                          _newGroupChatTapped(context);
                        }
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(15.0)),
                      ),
                      child: CircleAvatar(
                        child: Icon(Icons.add, color: white),
                        backgroundColor: defaultOrange,
                      ),
                      itemBuilder: (ctx) {
                        return List.generate(2, (index) {
                          final style = robotoTextStyle.copyWith(
                            fontWeight: FontWeight.bold,
                            color: defaultOrange,
                          );
                          if (index == 0) {
                            return PopupMenuItem(
                              value: 0,
                              child: TextScaleFactorClamper(
                                child: Text(
                                  'New Chat',
                                  style: style,
                                ),
                              ),
                            );
                          } else {
                            return PopupMenuItem(
                              value: 1,
                              child: TextScaleFactorClamper(
                                child: Text(
                                  'New Group Chat',
                                  style: style,
                                ),
                              ),
                            );
                          }
                        }
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        });
  }

  _newChatTapped(BuildContext context) {
    final route = MaterialPageRoute(
      builder: (_) => ChatSelectContactScreen(
        isGroupChat: false,
      ),
    );
    Navigator.push(context, route);
  }

  _newGroupChatTapped(BuildContext context) {
    final route = MaterialPageRoute(
      builder: (_) => ChatSelectContactScreen(
        isGroupChat: true,
      ),
    );
    Navigator.push(context, route);
  }
}
