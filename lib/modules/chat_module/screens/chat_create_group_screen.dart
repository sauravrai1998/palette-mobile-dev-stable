import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/common_components/next_icon_button_group.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/chat_module/screens/chat_message_screen.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/utils/helpers.dart';

class ChatCreateGroupScreen extends StatefulWidget {
  final List<ContactsData> selectedContacts;

  ChatCreateGroupScreen({
    Key? key,
    required this.selectedContacts,
  }) : super(key: key);

  @override
  _ChatCreateGroupScreenState createState() => _ChatCreateGroupScreenState();
}

class _ChatCreateGroupScreenState extends State<ChatCreateGroupScreen> {
  final controller = TextEditingController();
  bool isDisabled = false;
  File? _image;

  @override
  Widget build(BuildContext context) {
    final devWidth = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: RotatedBox(
                quarterTurns: 1,
                child: SvgPicture.asset(
                  'images/dropdown.svg',
                  color: defaultDark,
                  semanticsLabel: "Button to navigate back to the dashboard",
                )),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: TextScaleFactorClamper(
          child: SingleChildScrollView(
            physics: RangeMaintainingScrollPhysics(),
            child: Container(
              // height: MediaQuery.of(context).size.height*.90,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    padding: EdgeInsets.only(top: 40, left: 26, right: 26),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // SizedBox(height: 30),
                        GestureDetector(
                          onTap: () {
                            _onTap();
                          },
                          child: CircleAvatar(
                            backgroundColor: Colors.transparent,
                            radius: 90,
                            child: _image != null
                                ? ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: Image.file(
                                      _image!,
                                      width: 180,
                                      height: 180,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color: greyBorder,
                                        borderRadius:
                                            BorderRadius.circular(100)),
                                    width: 180,
                                    height: 180,
                                    child: Icon(
                                      Icons.group,
                                      color: Colors.white,
                                      size: 60,
                                    ),
                                  ),
                          ),
                        ),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Icon(
                              Icons.create_rounded,
                              color: defaultDark,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Group Name',
                                  style: roboto700.copyWith(
                                    fontSize: 14,
                                    color: Colors.black,
                                    fontWeight: FontWeight.w300,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Container(
                                  width: devWidth * 0.75,
                                  //height: 38,
                                  child: TextFormField(
                                    cursorColor: Colors.black,
                                    controller: controller,
                                    style: roboto700.copyWith(
                                      fontSize: 22,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    onChanged: (val) {
                                      if (val.trim().length >= 3) {
                                        floatingButtonController.sink.add(true);
                                      } else {
                                        floatingButtonController.sink
                                            .add(false);
                                      }
                                    },
                                    decoration: new InputDecoration(
                                      border: InputBorder.none,
                                      focusedBorder: InputBorder.none,
                                      enabledBorder: InputBorder.none,
                                      errorBorder: InputBorder.none,
                                      disabledBorder: InputBorder.none,
                                      contentPadding: EdgeInsets.only(
                                        left: 8,
                                        bottom: 0,
                                        top: 1,
                                        right: 4,
                                      ),
                                      hintText: 'Enter group name...',
                                      hintStyle: roboto700.copyWith(
                                        fontSize: 22,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.280,
                  ),
                  Align(
                    alignment: Alignment.bottomLeft,
                    child: Row(
                      children: [
                        Container(
                          padding: EdgeInsets.only(left: 10, bottom: 0),
                          height: 80,
                          width: devWidth * 0.8,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: widget.selectedContacts.length,
                            itemBuilder: (_, index) {
                              return Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6),
                                child: CircleAvatar(
                                  backgroundColor: defaultPurple,
                                  child: widget.selectedContacts[index]
                                              .profilePicture !=
                                          null
                                      ? CachedNetworkImage(
                                          imageUrl: widget
                                                  .selectedContacts[index]
                                                  .profilePicture ??
                                              '',
                                          imageBuilder:
                                              (context, imageProvider) =>
                                                  Container(
                                            decoration: BoxDecoration(
                                              color: Colors.white,
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: Center(
                                                    child: Text(
                                                      Helper.getInitials(
                                                        widget
                                                            .selectedContacts[
                                                                index]
                                                            .name,
                                                      ),
                                                      style: robotoTextStyle
                                                          .copyWith(
                                                        color: Colors.black,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ) //CircularProgressIndicator()
                                                  ),
                                          errorWidget: (context, url, error) =>
                                              Center(
                                            child: Text(
                                              Helper.getInitials(
                                                widget.selectedContacts[index]
                                                    .name,
                                              ),
                                              style: robotoTextStyle.copyWith(
                                                color: Colors.black,
                                                fontSize: 18,
                                              ),
                                            ),
                                          ),
                                        )
                                      : Center(
                                          child: Text(
                                            Helper.getInitials(
                                              widget
                                                  .selectedContacts[index].name,
                                            ),
                                            style: robotoTextStyle.copyWith(
                                              color: Colors.black,
                                              fontSize: 18,
                                            ),
                                          ),
                                        ),
                                ),
                              );
                            },
                          ),
                        ),
                        floatingButton()
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

  StreamController<bool> floatingButtonController =
      StreamController<bool>.broadcast();

  StreamController<bool> buttonController = StreamController<bool>.broadcast();
  Widget goAheadButton() {
    return StreamBuilder<bool>(
      stream: buttonController.stream,
      builder: (context, snapshot) {
        if (snapshot.data == true &&
            snapshot.connectionState == ConnectionState.active) {
          return Center(
            child: Container(
              padding: EdgeInsets.only(left: 10),
              child: CustomChasingDotsLoader(color: defaultDark),
            ),
          );
        } else {
          return Center(
              child: NextButtonGroup(
            isEnable: true,
            clickFunction: () async {
              buttonController.sink.add(true);
              final users =
                  widget.selectedContacts.map<User>((selectedContact) {
                final names = selectedContact.name.split(' ');
                final firstName = names[0];
                final lastName = names.length > 1 ? names[1] : '';
                // final
                return User(
                  id: selectedContact.firebaseUuid,
                  firstName: firstName,
                  lastName: lastName,
                );
              }).toList();
              // final file = File(_image!.path);
              // final reference =
              // FirebaseStorage.instance.ref().child('group_chat_pictures/');
              // await reference.putFile(file);
              // final uri = await reference.getDownloadURL();
              // print(uri);
              final _room = await FirebaseChatCore.instance.createGroupRoom(
                imageUrl: current_uri,
                name: controller.text.trimRight().trimLeft(),
                users: users,
              );

              if (FirebaseChatCore.instance.firebaseUser != null) {
                log('group admin roomId: ${_room.id} admin uid${FirebaseChatCore.instance.firebaseUser!.uid}');
                ChatRepository.instance.assignGroupAdmin(
                    roomId: _room.id,
                    selfSfid: FirebaseChatCore.instance.firebaseUser!.uid);
              }
              ChatRepository.instance
                  .updateLatestTimeStampOnFirebase(roomId: _room.id);

              String? getUrl;
              if (_image != null)
                getUrl = await ChatRepository.instance
                    .uploadToFirebase(_room, _image!);
              print('Image Url');
              final route = MaterialPageRoute(
                builder: (_) => ChatMessageScreen(
                  room: _room,
                  roomImage: getUrl,
                ),
              );
              buttonController.sink.add(false);
              Navigator.pushReplacement(context, route);
            },
          ));
        }
      },
    );
  }
  // Future <void> uploadToFirebase(types.Room room) async {
  //
  //   final jsonId = await FirebaseFirestore.instance
  //       .collection('rooms')
  //       .doc(room.id).id;
  //   final jsonDataId = jsonId;
  //   print(jsonDataId);
  //
  //   final file = File(_image!.path);
  //   final reference =
  //   FirebaseStorage.instance.ref().child('group_chat_pictures/$jsonDataId');
  //   await reference.putFile(file);
  //   final uri = await reference.getDownloadURL();
  //   print(uri);
  //
  //   final json = await FirebaseFirestore.instance
  //       .collection('rooms')
  //       .doc(room.id)
  //       .get();
  //   final jsonData = json.data();
  //   if (jsonData == null) return;
  //   jsonData.update('imageUrl', (value) => uri);
  //
  //   await FirebaseFirestore.instance
  //       .collection('rooms')
  //       .doc(room.id)
  //       .set(jsonData, SetOptions(merge: false));
  // }
  // Future <void> uploadToFirebase() async {
  //   final file = File(_image!.path);
  //   final reference =
  //   FirebaseStorage.instance.ref().child('group_chat_pictures/$widget.');
  //   await reference.putFile(file);
  //   final uri = await reference.getDownloadURL();
  //   print(uri);
  // }

  Widget floatingButton() {
    return StreamBuilder<bool>(
        stream: floatingButtonController.stream,
        builder: (context, snapshot) {
          if (snapshot.data == true) {
            return Container(
              height: 70,
              width: 60,
              child: goAheadButton(),
            );
          } else
            return NextButtonGroup(isEnable: false);
        });
  }

  bool _atLeastThreeCharactersEntered() {
    return controller.text.length >= 3;
  }

  @override
  void dispose() {
    floatingButtonController.close();
    buttonController.close();
    super.dispose();
  }

  Future<void> _onTap() async {
    showGeneralDialog(
      context: context,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => SafeArea(
        child: Scaffold(
            backgroundColor: Colors.black12.withOpacity(0.6),
            body: Center(
              child: Column(
                // mainAxisAlignment : MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  SizedBox(
                    height: 150,
                  ),
                  Stack(children: [
                    CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 90,
                      child: _image != null
                          ? ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: Image.file(
                                _image!,
                                width: 180,
                                height: 180,
                                fit: BoxFit.fill,
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                  color: greyBorder,
                                  borderRadius: BorderRadius.circular(100)),
                              width: 180,
                              height: 180,
                              child: Icon(
                                Icons.group,
                                color: Colors.white,
                                size: 60,
                              ),
                            ),
                    ),
                    Positioned(
                        bottom: 10,
                        right: 0,
                        child: Semantics(
                          label: "Tap to select an image",
                          child: GestureDetector(
                            onTap: () {
                              _showImagePicker();
                              Navigator.pop(context);
                            },
                            child: CircleAvatar(
                              child: Icon(Icons.camera_alt_outlined),
                              backgroundColor: uploadIconButtonColor,
                            ),
                          ),
                        ))
                  ]),
                  SizedBox(
                    height: 50,
                  ),
                  TextScaleFactorClamper(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent),
                            onPressed: () {
                              setState(() {
                                _image = null;
                              });
                              Navigator.pop(context);
                              _onTap();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Text(
                                "REMOVE",
                                style: montserratBoldTextStyle.copyWith(
                                  color: Colors.redAccent,
                                ),
                              )),
                            )),
                        ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                primary: Colors.transparent),
                            onPressed: () {
                              Navigator.pop(context);
                              // _upload();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 5),
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.redAccent,
                                  ),
                                ],
                              ),
                              child: Center(
                                  child: Text(
                                "DONE",
                                style: montserratBoldTextStyle.copyWith(
                                  color: white,
                                ),
                              )),
                            )),
                      ],
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void _showImagePicker() async {
    // ProfileRepository? profileRepo;
    final result = await ImagePicker().getImage(
      imageQuality: 70,
      maxWidth: 1440,
      source: ImageSource.gallery,
    );
    setState(() {
      _image = File(result!.path);
    });
    await _onTap();
  }
}
