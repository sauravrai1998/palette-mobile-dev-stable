import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/chat_module/screens/updated_group_details_holder.dart';
import 'package:palette/modules/chat_module/services/chat_pendo_repo.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';

import '../../../utils/helpers.dart';
import '../../../utils/konstants.dart';
import 'chat_select_contact_screen.dart';

class GroupDetailsScreen extends StatefulWidget {
  final Room room;
  final String roomName;
  final String roomImage;

  GroupDetailsScreen(
      {Key? key,
      required this.room,
      required this.roomName,
      required this.roomImage})
      : super(key: key);

  @override
  _GroupDetailsScreenState createState() =>
      _GroupDetailsScreenState(roomName: roomName, roomImage: roomImage);
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  _GroupDetailsScreenState({required this.roomName, required this.roomImage});

  final _textFieldController = TextEditingController();
  String roomName;
  String roomImage;
  UpdatedGroupRoomDetailsHolder? updatedRoomDetailsHolder;
  File? _image;
  var isGroupNameValid = true;

  String? groupAdminId;
  bool currentUserIsAdmin = false;
  bool isGroupHasNoAdmin = false;

  bool _isAttachmentUploading = false;
  bool isRemove = false;

  @override
  void initState() {
    super.initState();
    _textFieldController.text = widget.room.name ?? '';
    print(widget.room.imageUrl);
    print(this.roomImage);
    print(widget.roomName);
    _getGroupAdminId();
  }

  void _getGroupAdminId() async {
    
     List<String>? _groupadminIds = await ChatRepository.instance.getGroupAdmin(roomId: widget.room.id);
     final String? _groupAdminId = _groupadminIds?.first;
    this.groupAdminId = _groupAdminId;
    if (_groupAdminId == null) {
      isGroupHasNoAdmin = true;
    } else {
      isGroupHasNoAdmin = false;
    }
    if (groupAdminId == FirebaseChatCore.instance.firebaseUser!.uid) {
      currentUserIsAdmin = true;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: WillPopScope(
        onWillPop: () {
          Navigator.pop(context, updatedRoomDetailsHolder);
          return Future.value(false);
        },
        child: Scaffold(
          body: _body(context),
        ),
      ),
    );
  }

  Widget _body(BuildContext context) {
    final devWidth = MediaQuery.of(context).size.width;
    return TextScaleFactorClamper(
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 12),
                        child: IconButton(
                          icon: RotatedBox(
                              quarterTurns: 1,
                              child: SvgPicture.asset(
                                'images/dropdown.svg',
                                color: defaultDark,
                                semanticsLabel:
                                    "Button to navigate back to the dashboard",
                              )),
                          onPressed: () {
                            Navigator.pop(context, updatedRoomDetailsHolder);
                          },
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 20, top: 12),
                        width: devWidth * 0.5,
                        child: Text(
                          roomName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: roboto700.copyWith(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit,
                      color: chatDarkPurple,
                      semanticLabel: "Tap to edit group name",
                    ),
                    onPressed: () {
                      _showDialog();
                    },
                  ),
                ],
              ),
              Semantics(
                label: "Group image",
                child: GestureDetector(
                  onTap: () {
                    _onTap();
                  },
                  child: detailGroupImage(),
                ),
              ),
              SizedBox(height: 30),
              _separator(devWidth),
              SizedBox(height: 16),
              Flexible(
                child: ListView.builder(
                    shrinkWrap: true,
                    itemCount: widget.room.users.length,
                    itemBuilder: (_, index) {
                      return _listTile(index);
                    }),
              ),
            ],
          ),
        ],
      ),
    );
  }

  CircleAvatar detailGroupImage() {
    return CircleAvatar(
      backgroundColor: Colors.transparent,
      radius: 90,
      child: _image != null
          ? _isAttachmentUploading
              ? CustomChasingDotsLoader(
                  color: defaultDark,
                )
              : selectedImage()
          : widget.room.imageUrl != 'null' || widget.room.imageUrl != ''
              ? isRemove
                  ? groupIconPlaceholder()
                  : groupImageOnDetailsScreen()
              : groupIconPlaceholder(),
    );
  }

  CachedNetworkImage groupImageOnDetailsScreen() {
    return CachedNetworkImage(
        imageUrl: roomImage == '' ? widget.room.imageUrl ?? '' : roomImage,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
        placeholder: (context, url) => CircleAvatar(
            backgroundColor: Colors.white,
            child: CustomChasingDotsLoader(
              color: defaultDark,
            )),
        errorWidget: (context, url, error) => groupIconPlaceholder()
        // Icon(Icons.error),
        );
  }

  Container groupIconPlaceholder() {
    return Container(
      decoration: BoxDecoration(
          color: greyBorder, borderRadius: BorderRadius.circular(100)),
      width: 180,
      height: 180,
      child: Icon(
        Icons.group,
        color: Colors.white,
        size: 60,
      ),
    );
  }

  ClipRRect selectedImage() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(100),
      child: Image.file(
        _image!,
        width: 180,
        height: 180,
        fit: BoxFit.cover,
      ),
    );
  }

  void _showImagePicker() async {
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
                  detailsGroupImageOnPopup(context),
                  SizedBox(
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent),
                          onPressed: () async {
                            bool isdelete = await ChatRepository.instance
                                .deleteImage(
                                    widget.room, widget.room.imageUrl!);
                            print(isdelete);
                            updatedRoomDetailsHolder =
                                UpdatedGroupRoomDetailsHolder(roomName, 'null');
                            setState(() {
                              _image = null;
                              isRemove = true;
                            });

                            Navigator.pop(context);

                            // _onTap();
                          },
                          child: removeButton()),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                              primary: Colors.transparent),
                          onPressed: () async {
                            Navigator.pop(context);
                            _setAttachmentUploading(true);
                            final file = File(_image!.path);
                            String uri = await ChatRepository.instance
                                .updateFirebaseStorage(widget.room, _image!);
                            bool result = await ChatRepository.instance
                                .updateFirestore(widget.room, uri);
                            updatedRoomDetailsHolder =
                                UpdatedGroupRoomDetailsHolder(roomName, uri);
                            if (result) {
                              setState(() {
                                _image = file;
                                _setAttachmentUploading(false);
                              });
                            }
                          },
                          child: doneButton()),
                    ],
                  )
                ],
              ),
            )),
      ),
    );
  }

  Container doneButton() {
    return Container(
      width: 120,
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
    );
  }

  Container removeButton() {
    return Container(
      width: 120,
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
    );
  }

  Stack detailsGroupImageOnPopup(BuildContext context) {
    return Stack(children: [
      CircleAvatar(
        backgroundColor: Colors.transparent,
        radius: 90,
        child: _image != null
            ? selectedImage()
            : widget.room.imageUrl != 'null' || widget.room.imageUrl != ''
                ? isRemove
                    ? groupIconPlaceholder()
                    : groupImageOnPopup()
                : groupIconPlaceholder(),
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
    ]);
  }

  CachedNetworkImage groupImageOnPopup() {
    return CachedNetworkImage(
        imageUrl: roomImage == '' ? widget.room.imageUrl ?? '' : roomImage,
        imageBuilder: (context, imageProvider) => Container(
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
              ),
            ),
        placeholder: (context, url) => CircleAvatar(
            radius: 90,
            backgroundColor: Colors.white,
            child: CustomChasingDotsLoader(
              color: defaultDark,
            )),
        errorWidget: (context, url, error) => groupIconPlaceholder());
  }

  _showDialog() {
    showDialog(
        context: context,
        builder: (context) {
          final border = UnderlineInputBorder(
            borderSide: BorderSide(color: darkPurple),
          );
          return StatefulBuilder(builder: (context, stateSetter) {
            return TextScaleFactorClamper(
              child: AlertDialog(
                title: Text(
                  'Enter group name...',
                  style: robotoTextStyle.copyWith(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _textFieldController,
                      decoration: InputDecoration(focusedBorder: border),
                    ),
                    isGroupNameValid
                        ? Container()
                        : Text(
                            'Please enter more than 3 chatacters',
                            style: montserratNormal.copyWith(
                                color: pinkRed, fontSize: 12),
                          ),
                  ],
                ),
                actions: <Widget>[
                  TextButton(
                    child: Text(
                      'Cancel',
                      style: TextStyle(color: chatDarkPurple, fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                  BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                      builder: (context, pendoState) {
                    return TextButton(
                      child: Text(
                        'Save',
                        style: TextStyle(color: chatDarkPurple, fontSize: 16),
                      ),
                      onPressed: () async {
                        ///
                        if (_textFieldController.text.length < 3) {
                          stateSetter(() {
                            isGroupNameValid = false;
                          });
                          return;
                        } else {
                          stateSetter(() {
                            isGroupNameValid = true;
                          });
                        }
                        var text = _textFieldController.text;
                        if (_textFieldController.text.startsWith(' ')) {
                          text = _textFieldController.text.trimLeft();
                        }
                        if (text.isEmpty || text == '') return;

                        final json = await FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(widget.room.id)
                            .get();
                        final jsonData = json.data();
                        if (jsonData == null) return;
                        jsonData.update('name', (value) => text);

                        await FirebaseFirestore.instance
                            .collection('rooms')
                            .doc(widget.room.id)
                            .set(jsonData, SetOptions(merge: false));

                        ChatPendoRepo.trackEditingGroupName(
                          oldGroupName: widget.room.name ?? '',
                          newGroupName: text,
                          pendoState: pendoState,
                        );

                        updatedRoomDetailsHolder =
                            UpdatedGroupRoomDetailsHolder(text, roomImage);
                        setState(() {
                          roomName = text;
                        });
                        Navigator.pop(context);
                      },
                    );
                  }),
                ],
              ),
            );
          });
        });
  }

  Widget _separator(double devWidth) {
    return Container(
      width: devWidth,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _getAddParticipantButton(width: devWidth * 0.7),
          SizedBox(height: 20),
          Container(
            width: devWidth * 0.3,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.all(Radius.circular(2)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _listTile(int index) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    final name;
    if (widget.room.users[index].id ==
        FirebaseChatCore.instance.firebaseUser!.uid) {
      name = 'You';
    } else {
      name = widget.room.users[index].firstName! +
          ' ' +
          widget.room.users[index].lastName!;
    }
    return ListTile(
      contentPadding: EdgeInsets.fromLTRB(
        24,
        0,
        2,
        8,
      ),
      dense: false,
      leading: ExcludeSemantics(
        child: CircleAvatar(
          backgroundColor: defaultPurple,
          radius: 26,
          child: widget.room.users[index].avatarUrl != null
              ? CachedNetworkImage(
                  imageUrl: widget.room.users[index].avatarUrl ?? '',
                  imageBuilder: (context, imageProvider) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                          image: imageProvider, fit: BoxFit.cover),
                    ),
                  ),
                  placeholder: (context, url) => CircleAvatar(
                      backgroundColor: Colors.transparent,
                      child: Container() //CircularProgressIndicator()
                      ),
                  errorWidget: (context, url, error) => Center(
                    child: Text(
                      Helper.getInitials(
                        widget.room.users[index].firstName! +
                            ' ' +
                            widget.room.users[index].lastName!,
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
                      widget.room.users[index].firstName! +
                          ' ' +
                          widget.room.users[index].lastName!,
                    ),
                    style: robotoTextStyle.copyWith(
                      color: Colors.black,
                      fontSize: 18,
                    ),
                  ),
                ),
        ),
      ),
      trailing: Icon(
        Icons.check_circle_outline,
        color: Colors.white,
      ),
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: robotoTextStyle.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.normal,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 2,
                ),
                if (widget.room.users[index].id == groupAdminId) 
                Text(
                  'Group Admin',
                  style: robotoTextStyle.copyWith(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.black,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
              ],
            ),
          ),
          if (currentUserIsAdmin && !isGroupHasNoAdmin)
          if (widget.room.users[index].id != groupAdminId)    
           IconButton(
                  icon: Icon(
                    Icons.cancel_rounded,
                    color: Colors.red[400],
                    semanticLabel: "Remove $name",
                  ),
                  onPressed: () async {
                    final userToRemove = widget.room.users[index];
                    final json = await FirebaseFirestore.instance
                        .collection('rooms')
                        .doc(widget.room.id)
                        .get();
                    final jsonData = json.data();
                    if (jsonData == null) return;
                    print(jsonData['userIds']);
                    final userIds = jsonData['userIds'] as List;
                    userIds.remove(userToRemove.id);

                    jsonData.update('userIds', (value) {
                      return userIds;
                    });

                    await FirebaseFirestore.instance
                        .collection('rooms')
                        .doc(widget.room.id)
                        .set(jsonData, SetOptions(merge: false));

                    ChatPendoRepo.trackRemovingParticipantGroupChat(
                      uid: userToRemove.id,
                      pendoState: pendoState,
                    );
                    setState(() {
                      widget.room.users.remove(userToRemove);
                    });
                  },
                ),
        ],
      ),
      onTap: () async {
        ///
      },
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
  }

  _getAddParticipantButton({required double width}) {
    return GestureDetector(
      onTap: () {
        final usersInAlreadyMadeGroup = widget.room.users;
        final route = MaterialPageRoute(
          builder: (_) => ChatSelectContactScreen(
            isGroupChat: true,
            usersInAlreadyMadeGroup: usersInAlreadyMadeGroup,
            roomId: widget.room.id,
          ),
        );
        Navigator.push(context, route);
      },
      child: Container(
        height: 44,
        padding: EdgeInsets.symmetric(horizontal: 8),
        //width: width,
        decoration: BoxDecoration(
          color: darkPurple,
          borderRadius: BorderRadius.all(Radius.circular(22)),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.25),
              blurRadius: 4,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 20),
            Icon(Icons.group_add, color: Colors.white),
            SizedBox(width: 16),
            Text(
              'Add Participant',
              style: robotoTextStyle.copyWith(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
