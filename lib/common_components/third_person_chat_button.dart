import 'package:flutter/material.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/modules/chat_module/screens/chat_message_screen.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
class ThirdPersonChat extends StatefulWidget {
  final String? firebaseUuid;
  const ThirdPersonChat({
    Key? key,
    required this.firebaseUuid,
  }) : super(key: key);

  @override
  State<ThirdPersonChat> createState() => _ThirdPersonChatState();
}

class _ThirdPersonChatState extends State<ThirdPersonChat> {
  bool ignoring = false;
  String tempUuid = 'nZdqsaJ0lPTJDf3pjpE1eiaRkRD2';
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ignoring
          ? () {}
          : () async{
        print('tapp');
        setState(() {
          ignoring = true;
        });
        final room = await FirebaseChatCore.instance
            .createRoom(
            User(id: widget.firebaseUuid!));

        setState(() {
          ignoring = false;
        });
        final route = MaterialPageRoute(
          builder: (_) => ChatMessageScreen(
            room: room,
          ),
        );
        Navigator.push(context, route);
      },
      child: Container(
        height: 80,
        width: 80,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [
                Color(0xFF3A4A56).withOpacity(0),
                Color(0xFF3A4A56).withOpacity(1),
              ],
            )
        ),
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Container(
              height: 20,
              width: 20,
              child: SvgPicture.asset('images/chat_third_person.svg',height: 5,width: 5,)),
        ),
      ),
    );
  }
}