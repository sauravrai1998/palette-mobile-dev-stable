import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/modules/profile_module/bloc/postimage_bloc/postImage_bloc.dart';
import 'package:palette/modules/profile_module/bloc/postimage_bloc/postImage_events.dart';
import 'package:palette/modules/profile_module/bloc/profile_image_bloc/profile_image_bloc.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:palette/modules/profile_module/services/profile_repository.dart';
import 'package:palette/utils/konstants.dart';
import 'package:path/path.dart' as Path;
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePageTopWidget extends StatefulWidget {
  final double screenHeight;
  final double screenWidth;
  final String title;
  final String role;
  final String? subtitle;
  final bool thirdPerson;
  final String? sfid;
  final String? profilePicture;

  ProfilePageTopWidget(
      {required this.screenHeight,
      required this.screenWidth,
      required this.title,
      required this.role,
      this.subtitle,
      this.thirdPerson = false,
      this.sfid,
      required this.profilePicture});

  @override
  _ProfilePageTopWidgetState createState() => _ProfilePageTopWidgetState();
}

class _ProfilePageTopWidgetState extends State<ProfilePageTopWidget> {
  bool _isAttachmentUploading = false;
  File? _image;
  String sfuuid = '';

  @override
  void initState() {
    super.initState();
    setSfid();
  }

  setSfid() async {
    var prefs = await SharedPreferences.getInstance();
    sfuuid = prefs.getString(saleforceUUIDConstant) ?? '';
  }

  static Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  String? profileImageUrl;

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return widget.thirdPerson == false
            ? Row(
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  buildInkWell(),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: widget.screenHeight * 0.08,
                      ),
                      child: Transform.translate(
                        // offset: Offset(-(screenWidth * 0.115), 76),
                        offset: Offset(0, 66),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Semantics(
                                  child: Text(
                                    widget.title,
                                    style: kalamLight.copyWith(
                                      height: 1,
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 22,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                // if (subtitle != null)
                                Builder(
                                  builder: (_) {
                                    if (widget.subtitle != null) {
                                      return Semantics(
                                        child: Text(
                                          widget.subtitle!,
                                          style: kalamLight.copyWith(
                                            color:
                                                Colors.white.withOpacity(0.85),
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                        ),
                                      );
                                    } else
                                      return Container();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  SizedBox(
                    width: 12,
                  ),
                  Flexible(
                    child: Padding(
                      padding: EdgeInsets.only(
                        bottom: widget.screenHeight * 0.08,
                      ),
                      child: Transform.translate(
                        // offset: Offset(-(screenWidth * 0.115), 76),
                        offset: Offset(0, 66),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Semantics(
                                  child: Text(
                                    widget.title,
                                    style: kalamLight.copyWith(
                                      height: 1,
                                      color: Colors.white.withOpacity(0.85),
                                      fontSize: 22,
                                    ),
                                    maxLines: 2,
                                  ),
                                ),
                                // if (subtitle != null)
                                Builder(
                                  builder: (_) {
                                    if (widget.subtitle != null) {
                                      return Semantics(
                                        child: Text(
                                          widget.subtitle!,
                                          style: kalamLight.copyWith(
                                            color:
                                                Colors.white.withOpacity(0.85),
                                            fontSize: 16,
                                          ),
                                          maxLines: 2,
                                        ),
                                      );
                                    } else
                                      return Container();
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Stack(children: [
                    SvgPicture.asset(
                      'images/${widget.role}_splash_ph.svg',
                      height: 183.220,
                      width: 245.538,
                      semanticsLabel: "Profile picture",
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 25, top: 52),
                      child: _isAttachmentUploading
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 35,
                              child: CircularProgressIndicator(
                                backgroundColor: defaultBlueDark,
                              ),
                            )
                          : BlocBuilder<ProfileImageBloc, ProfileImageState>(
                              builder: (context, state) {
                                print(
                                    'state profile image in screen${state.runtimeType}');
                                if (state is ProfileImageSuccessState) {
                                  profileImageUrl = state.url;
                                } else if (state is ProfileImageDeleteState) {
                                  return Container();
                                } else if (state is ProfileImageInitialState) {
                                  profileImageUrl = widget.profilePicture;
                                }

                                if (widget.thirdPerson)
                                  profileImageUrl = widget.profilePicture;

                                return profileImageUrl == 'null'
                                    ? Container()
                                    : CachedNetworkImage(
                                        imageUrl: profileImageUrl ?? '',
                                        imageBuilder: (context,
                                                imageProvider) =>
                                            Container(
                                              width: 70.0,
                                              height: 70.0,
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle,
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                        placeholder: (context, url) =>
                                            CircleAvatar(
                                                radius: 35,
                                                backgroundColor: Colors.white,
                                                child: CustomChasingDotsLoader(
                                                    color: defaultDark)),
                                        errorWidget: (context, url, error) =>
                                            Container());
                              },
                            ),
                    ),
                  ]),
                ],
              );
      },
    );
  }

  Widget buildInkWell() {
    return BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
      builder: (context, pendostate) {
        return InkWell(
            onTap: () {
              _onTap(profileImageUrl);
              ProfilePendoRepo.trackOpenImageUploadPopup(pendoState: pendostate);
    
            },
            child: Stack(
              children: [
                SvgPicture.asset(
                  'images/${widget.role}_splash_ph.svg',
                  height: 183.220,
                  width: 245.538,
                  semanticsLabel: "Profile picture",
                ),
                Padding(
                  padding: EdgeInsets.only(top: 52, left: 25),
                  // widget.screenHeight <= 736
                  //     ? EdgeInsets.only(left: 25, top: 52)
                  //     : EdgeInsets.only(left: 33, top: 66),
                  child:
                      // urlImage == '' ||
                      //         urlImage == null ||
                      _isAttachmentUploading
                          ? CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 35,
                              child: CustomChasingDotsLoader(color: defaultDark),
                              // CircularProgressIndicator(
                              //   backgroundColor: defaultBlueDark,
                              // ),
                            )
                          : BlocBuilder<ProfileImageBloc, ProfileImageState>(
                              builder: (context, state) {
                                print(
                                    'state profile image in screen${state.runtimeType}');
                                if (state is ProfileImageSuccessState) {
                                  profileImageUrl = state.url;
                                } else if (state is ProfileImageDeleteState) {
                                  return Container();
                                } else if (state is ProfileImageInitialState) {
                                  profileImageUrl = widget.profilePicture;
                                }
    
                                return profileImageUrl == 'null'
                                    ? Container()
                                    : CachedNetworkImage(
                                        imageUrl: profileImageUrl ?? '',
                                        imageBuilder: (context, imageProvider) =>
                                            Container(
                                          width: 70.0,
                                          height: 70.0,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ),
                                        placeholder: (context, url) => CircleAvatar(
                                            radius: 35,
                                            backgroundColor: Colors.white,
                                            child: CustomChasingDotsLoader(
                                                color: defaultDark)),
                                        errorWidget: (context, url, error) =>
                                            Container(),
                                      );
                              },
                            ),
                ),
              ],
            ));
      }
    );
  }

  Future<void> _onTap(String? profileImageUrl) async {
    showGeneralDialog(
      context: context,
      transitionDuration: Duration(milliseconds: 400),
      pageBuilder: (context, animation, secondaryAnimation) => SafeArea(
        child: StatefulBuilder(builder: (context, stateSetter) {
          return Scaffold(
              backgroundColor: Colors.black12.withOpacity(0.6),
              body: Center(
                child: Column(
                  // mainAxisAlignment : MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(
                      height: widget.screenHeight * .24,
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
                                  fit: BoxFit.cover,
                                ),
                              )
                            : BlocBuilder<ProfileImageBloc, ProfileImageState>(
                                builder: (context, state) {
                                  String? profileImageUrl;
                                  print(
                                      'state profile image in screen${state.runtimeType}');
                                  if (state is ProfileImageSuccessState) {
                                    profileImageUrl = state.url;
                                  } else if (state is ProfileImageDeleteState) {
                                    return Container(
                                      decoration: BoxDecoration(
                                          color: greyBorder,
                                          borderRadius:
                                              BorderRadius.circular(100)),
                                      width: 180,
                                      height: 180,
                                      child: Icon(
                                        Icons.person,
                                        color: Colors.white,
                                        size: 60,
                                      ),
                                    );
                                  } else if (state
                                      is ProfileImageInitialState) {
                                    profileImageUrl = widget.profilePicture;
                                  }
                                  return profileImageUrl != 'null'
                                      ? CachedNetworkImage(
                                          imageUrl: profileImageUrl ?? '',
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
                                                  radius:
                                                      widget.screenHeight <= 736
                                                          ? 35
                                                          : 40,
                                                  backgroundColor: Colors.white,
                                                  child:
                                                      CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Container(
                                            decoration: BoxDecoration(
                                                color: greyBorder,
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            width: 180,
                                            height: 180,
                                            child: Icon(
                                              Icons.person,
                                              color: Colors.white,
                                              size: 60,
                                            ),
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
                                            Icons.person,
                                            color: Colors.white,
                                            size: 60,
                                          ),
                                        );
                                },
                              ),
                      ),
                      Positioned(
                          bottom: 10,
                          right: 0,
                          child: Semantics(
                            label: "Tap to select an image",
                            child: BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                              builder: (context, pendoState) {
                                return GestureDetector(
                                  onTap: () {
                                    _showImagePicker();
                                    ProfilePendoRepo.trackSelectProfileImageFromGallery(pendoState: pendoState);
                                    Navigator.pop(context);
                                  },
                                  child: CircleAvatar(
                                    child: Icon(Icons.camera_alt_outlined),
                                    backgroundColor: uploadIconButtonColor,
                                  ),
                                );
                              }
                            ),
                          ))
                    ]),
                    SizedBox(height: widget.screenHeight * .3),
                    TextScaleFactorClamper(
                      child: BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                            builder: (context, pendoState) {
                              return Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                           ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent),
                                  onPressed: () async {
                                    print(profileImageUrl);
                                    if (_isAttachmentUploading) {
                                      return;
                                    }
                                    if (profileImageUrl == null) return;
                                    bool isDeleted =
                                        await deleteImage(profileImageUrl);
                                    if (isDeleted) {
                                      setState(() {
                                        _image = null;
                                      });
                                      ProfilePendoRepo.trackRemoveProfilePicture(
                                          pendoState: pendoState);
                                    }
                                    Navigator.pop(context);
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
                              onPressed: () async {
                                if (_isAttachmentUploading) {
                                  print('attachement uploading');
                                  return;
                                }
                                print('attachement uploaded');

                                await _upload(callBack: () {
                                  stateSetter(() {});
                                }, pendoState: pendoState);
                                Navigator.pop(context);
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
                                child: Stack(
                                  children: [
                                    Center(
                                      child: Text(
                                        "DONE",
                                        style: montserratBoldTextStyle.copyWith(
                                          color: _isAttachmentUploading
                                              ? Colors.redAccent
                                              : white,
                                        ),
                                      ),
                                    ),
                                    _isAttachmentUploading
                                        ? Positioned(
                                            top: 2,
                                            left: 2,
                                            right: 2,
                                            bottom: 2,
                                            child: SpinKitChasingDots(
                                              color: white,
                                              size: 16,
                                            ),
                                          )
                                        : SizedBox(height: 0, width: 0),
                                  ],
                                ),
                              )),
                        ],
                      );})
                    )
                  ],
                ),
              ));
        }),
      ),
    );
  }

  void _setAttachmentUploading(bool uploading) {
    setState(() {
      _isAttachmentUploading = uploading;
    });
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
    
    await _onTap(profileImageUrl);
  }

  Future<void> _upload({required Function callBack,required PendoMetaDataState pendoState}) async {
    print(_image);
    if (_image != null) {
      callBack();
      _setAttachmentUploading(true);
      print('Image Picked');
      final file = File(_image!.path);

      try {
        final username = widget.title.replaceAll(new RegExp(r"\s+"), "");
        final userSfid = username + '_' + widget.sfid!;
        final reference =
            FirebaseStorage.instance.ref().child('profile_pictures/$userSfid');
        await reference.putFile(file);
        final uri = await reference.getDownloadURL();

        /// Send image url to dashboard
        await ProfileRepository.instance
            .addImageUrlToUsersCollectionFirestore(uri);
        callBack();
        _setAttachmentUploading(false);
        BlocProvider.of<ProfileImageBloc>(context)
            .add(AddProfileImageEvent(url: uri));

        final bloc = BlocProvider.of<PostImageBloc>(context);
        bloc.add(PostImageUrlEvent(url: uri));
        ProfilePendoRepo.trackUploadProfilePicture(
            url: uri, pendoState: pendoState);
      } on FirebaseException catch (e) {
        callBack();
        _setAttachmentUploading(false);
        print(e);
      }
    } else {
      print('User canceled the picker');
    }
  }

  Future<bool> deleteImage(String imageFileUrl) async {
    try {
      var fileUrl = Uri.decodeFull(Path.basename(imageFileUrl))
          .replaceAll(new RegExp(r'(\?alt).*'), '');
      print(fileUrl);
      final firebaseStorageRef = FirebaseStorage.instance.ref().child(fileUrl);
      await firebaseStorageRef.delete();
      final firebaseUser = FirebaseChatCore.instance.firebaseUser;
      if (firebaseUser != null) {
        ChatRepository.instance
            .removeUserProfileImageFromUserCollectionFirestore(
                FirebaseChatCore.instance.firebaseUser!.uid);
      }
      final bloc = BlocProvider.of<PostImageBloc>(context);
      BlocProvider.of<ProfileImageBloc>(context).add(DeleteProfileImageEvent());
      bloc.add(PostImageUrlEvent(url: 'null'));
      return true;
    } on FirebaseException catch (e) {
      print(e);
      return false;
    }
  }

  // Future<void> getUrlFromPreferences() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   final String url = prefs.getString('profile_image').toString();
  //   if (url != null || url != '')
  //     setState(() {
  //       urlImage = url;
  //       gettingPreferences = true;
  //     });
  //   else
  //     urlImage == null;
  //   print('Getting from preferences');
  //   print(urlImage);
  // }
}
