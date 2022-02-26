import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart' as types;
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/chat_module/screens/chat_message_screen.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';

class PocChatHistoryScreen extends StatefulWidget {
  const PocChatHistoryScreen({Key? key}) : super(key: key);

  @override
  _PocChatHistoryScreenState createState() => _PocChatHistoryScreenState();
}

class _PocChatHistoryScreenState extends State<PocChatHistoryScreen> {
  List<types.User> users = [];

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: defaultDark,
          centerTitle: false,
          title: Text('Messages'),
          // leading: IconButton(
          //   icon: Icon(Icons.group_add),
          //   onPressed: () {
          //     _showDialog();
          //   },
          // ),
          bottom: TabBar(
            onTap: (index) {
              // Tab index when user select it, it start from zero
            },
            tabs: [
              Tab(text: 'Users'),
              Tab(text: 'Chats'),
            ],
          ),
        ),
        body: _getBody(),
      ),
    );
  }

  _showDialog() async {
    await showDialog<String>(
      context: context,
      builder: (_) {
        final controller = TextEditingController();
        return _SystemPadding(
          child: AlertDialog(
            contentPadding: const EdgeInsets.all(16.0),
            content: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    autofocus: true,
                    controller: controller,
                    decoration: InputDecoration(
                      labelText: 'Name',
                    ),
                  ),
                )
              ],
            ),
            actions: <Widget>[
              TextButton(
                  child: const Text('CANCEL'),
                  onPressed: () {
                    Navigator.pop(context);
                  }),
              TextButton(
                  child: const Text('CREATE'),
                  onPressed: () async {
                    final halfLength = (users.length / 2).ceil();
                    final room =
                        await FirebaseChatCore.instance.createGroupRoom(
                      imageUrl: '',
                      name: controller.text,
                      users: users,
                    );
                    final route = MaterialPageRoute(
                      builder: (_) => ChatMessageScreen(
                        room: room,
                      ),
                    );
                    Navigator.pop(context);
                    Navigator.push(context, route);
                  })
            ],
          ),
        );
      },
    );
  }

  Widget _getBody() {
    return TabBarView(
      children: [
        _getUserListWidget(),
        _getChatListWidget(),
      ],
    );
  }

  Widget _getUserListWidget() {
    return StreamBuilder<List<types.User>>(
      stream: FirebaseChatCore.instance.users(),
      initialData: [],
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error occurred'));
        }

        this.users = snapshot.data as List<types.User>;
        final selfUid = FirebaseAuth.instance.currentUser!.uid;
        users = users.where((u) => selfUid != u.id).toList();

        ChatRepository.saveUsersMappingToSharedPrefs(users);

        return ListView.builder(
          itemCount: users.length,
          itemBuilder: (_, index) {
            final user = users[index];
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black26),
              ),
              padding: EdgeInsets.all(10),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Colors.indigoAccent,
                ),
                title: Text(user.firstName! + ' ' + user.lastName!),
                onTap: () async {
                  final room =
                      await FirebaseChatCore.instance.createRoom(users[index]);
                  final route = MaterialPageRoute(
                    builder: (_) => ChatMessageScreen(
                      room: room,
                    ),
                  );
                  Navigator.push(context, route);
                },
              ),
            );
          },
        );
      },
    );
  }

  Widget _getChatListWidget() {
    return StreamBuilder<List<Room>>(
      stream: FirebaseChatCore.instance.rooms(),
      initialData: const [],
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        } else if (snapshot.hasError) {
          return Center(child: Text('Error occurred'));
        }

        final data = snapshot.data as List<Room>;

        return ListView.builder(
            itemCount: data.length,
            itemBuilder: (_, index) {
              final room = data[index];
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black26),
                ),
                padding: EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Colors.indigoAccent,
                  ),
                  title: Text(room.name ?? 'no name'),
                  onTap: () async {
                    final route = MaterialPageRoute(
                      builder: (_) => ChatMessageScreen(
                        room: room,
                      ),
                    );
                    Navigator.push(context, route);
                  },
                ),
              );
            });
      },
    );
  }
}

class _SystemPadding extends StatelessWidget {
  final Widget child;

  _SystemPadding({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var mediaQuery = MediaQuery.of(context);
    return new AnimatedContainer(
        padding: mediaQuery.viewInsets,
        duration: const Duration(milliseconds: 300),
        child: child);
  }
}
