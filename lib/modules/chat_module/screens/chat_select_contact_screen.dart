import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_chat_types/flutter_chat_types.dart';
import 'package:flutter_firebase_chat_core/flutter_firebase_chat_core.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/next_icon_button.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_bloc.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_events.dart';
import 'package:palette/modules/chat_module/bloc/chat_bloc.dart';
import 'package:palette/modules/chat_module/bloc/chat_events.dart';
import 'package:palette/modules/chat_module/screens/chat_create_group_screen.dart';
import 'package:palette/modules/chat_module/screens/chat_message_screen.dart';
import 'package:palette/modules/chat_module/services/chat_pendo_repo.dart';
import 'package:palette/modules/chat_module/services/chat_repository.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';
import '../../../utils/konstants.dart';

class ChatSelectContactScreen extends StatefulWidget {
  ChatSelectContactScreen({
    Key? key,
    required this.isGroupChat,
    this.usersInAlreadyMadeGroup = const [],
    this.roomId = '',
  }) : super(key: key);

  final bool isGroupChat;
  final List<User> usersInAlreadyMadeGroup;
  final String roomId;

  @override
  _ChatSelectContactScreenState createState() => _ChatSelectContactScreenState(
      fromAlreadyMadeGroup: usersInAlreadyMadeGroup.isNotEmpty);
}

class _ChatSelectContactScreenState extends State<ChatSelectContactScreen> {
  _ChatSelectContactScreenState({required this.fromAlreadyMadeGroup});
  List<ContactsData> contacts = [];
  bool fromAlreadyMadeGroup;
  bool ignoring = false;
  var alreadyClicked = false;
  String? role;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getSfidAndRole();
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    role = prefs.getString('role').toString();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(create: (BuildContext context) {
      return ChatBloc(chatRepo: ChatRepository.instance)
        ..add(FetchChatContactsEvent());
    }, child: TextScaleFactorClamper(
      child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        return SafeArea(
          child: Scaffold(
            backgroundColor: white,
            appBar: AppBar(
              leading: IconButton(
                icon: RotatedBox(
                    quarterTurns: 1,
                    child: SvgPicture.asset(
                      'images/dropdown.svg',
                      color: defaultDark,
                      semanticsLabel:
                          "Button to navigate back to the dashboard",
                    )),
                onPressed: () {
                  Navigator.pop(context);
                  contacts.forEach((element) {
                    // clear the list of contacts
                    element.isSelected = false;
                  });
                },
              ),
              elevation: 0,
              backgroundColor: white,
              iconTheme: IconThemeData(color: defaultDark),
              title: Text(
                'Select Contact',
                style: roboto700.copyWith(
                    fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            body: BlocBuilder<GetContactsBloc, GetContactsState>(
              builder: (context, state) {
                if (state is GetContactsSuccessState) {
                  if (widget.usersInAlreadyMadeGroup.isNotEmpty) {
                    // Came from already made group
                    final List<ContactsData> filteredList = [];
                    List<ContactsData> tempList = state
                        .contactsResponse.contacts
                        .where((element) => element.canChat)
                        .toList();
                    tempList.forEach((contact) {
                      bool isFound = false;
                      widget.usersInAlreadyMadeGroup.forEach((firebaseUser) {
                        if (firebaseUser.id == contact.firebaseUuid) {
                          isFound = true;
                        }
                      });
                      if (!isFound) filteredList.add(contact);
                    });

                    contacts = filteredList;
                  } else {
                    /// New Chat
                    contacts = state.contactsResponse.contacts
                        .where((element) => element.canChat)
                        .toList();
                  }
                  return contacts.length == 0
                      ? Container(
                          child: Center(child: Text('No User to Add')),
                        )
                      : _getListView(state);
                } else if (state is GetContactsLoadingState) {
                  return CustomPaletteLoader();
                } else if (state is GetContactsFailureState) {
                  return Container(
                    child: Center(child: Text(state.errorMessage)),
                  );
                }
                return Container();
              },
            ),
            floatingActionButton: _atLeastOneItemSelected()
                ? Container(
                    height: 60,
                    width: 60,
                    child: NextButton(
                      clickFunction: () async {
                        if (alreadyClicked) {
                          return;
                        }
                        alreadyClicked = true;
                        List<ContactsData> selectedContacts = [];
                        contacts.forEach((contact) {
                          if (contact.isSelected) {
                            selectedContacts.add(contact);
                          }
                        });
                        if (fromAlreadyMadeGroup) {
                          /// Add participants to group
                          print('add participants to group');
                          final userIdsToAdd =
                              selectedContacts.map((selectedContact) {
                            return selectedContact.firebaseUuid;
                          }).toList();
                          final json = await FirebaseFirestore.instance
                              .collection('rooms')
                              .doc(widget.roomId)
                              .get();

                          final jsonData = json.data();
                          if (jsonData == null) return;
                          print(jsonData);
                          print(userIdsToAdd);
                          final userIds = jsonData['userIds'] as List;
                          userIds.addAll(userIdsToAdd);
                          print(userIds);
                          jsonData.update('userIds', (value) => userIds);
                          await FirebaseFirestore.instance
                              .collection('rooms')
                              .doc(widget.roomId)
                              .set(jsonData, SetOptions(merge: false));

                          ChatPendoRepo.trackAddingParticipantGroupChat(
                            pendoState: pendoState,
                            userIdsToAdd: userIdsToAdd,
                          );

                          final bloc = context.read<BottomNavbarBloc>();
                          bloc.add(GetBottomNavbarIndexValue(
                            indexValue: role == 'Observer' ? 1 : 2,
                          ));
                          Navigator.of(context).popUntil((route) {
                            return route.settings.name == 'DashboardNavBar';
                          });
                        } else {
                          /// Creating a new group
                          ChatPendoRepo.trackCreatingGroupChat(
                            chatContacts: selectedContacts,
                            pendoState: pendoState,
                          );
                          final route = MaterialPageRoute(
                            builder: (context) => ChatCreateGroupScreen(
                              selectedContacts: selectedContacts,
                            ),
                          );
                          Navigator.pushReplacement(context, route);
                          alreadyClicked = false;
                        }
                      },
                    ),
                  )
                : null,
          ),
        );
      }),
    ));
  }

  bool _atLeastOneItemSelected() {
    if (fromAlreadyMadeGroup) {
      final c = contacts.where((element) => element.isSelected);
      return c.isNotEmpty;
    } else {
      final c = contacts.where((element) => element.isSelected);
      return c.length >= 2;
    }
  }

  Widget _getListView(GetContactsSuccessState contactsState) {
    return IgnorePointer(
      ignoring: ignoring,
      child: ListView.builder(
        itemCount: contacts.length,
        itemBuilder: (context, index) {
          print('contacts.length, ${contacts.length}');
          return Container(
            margin: index != 0
                ? EdgeInsets.fromLTRB(0, 4, 0, 4)
                : EdgeInsets.fromLTRB(0, 12, 0, 4),
            child: Center(
              child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                  builder: (context, pendoState) {
                return ListTile(
                  contentPadding: EdgeInsets.fromLTRB(
                    16,
                    0,
                    16,
                    8,
                  ),
                  tileColor: contacts[index].isSelected == true
                      ? selectContactTileColor
                      : Colors.transparent,
                  leading: Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: ExcludeSemantics(
                      child: CircleAvatar(
                          backgroundColor: defaultPurple,
                          radius: 26,
                          child: FutureBuilder(
                            builder: (context, snapshot) {
                              if (snapshot.data == null ||
                                  snapshot.hasData == false) {
                                return CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Center(
                                        child: Text(
                                      Helper.getInitials(
                                        contacts[index].name,
                                      ),
                                      style: robotoTextStyle.copyWith(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    )));
                              } else if (snapshot.hasData) {
                                return CachedNetworkImage(
                                    imageUrl: snapshot.data!.toString(),
                                    imageBuilder: (context, imageProvider) =>
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            shape: BoxShape.circle,
                                            image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover),
                                          ),
                                        ));
                              } else {
                                return CircleAvatar(
                                    backgroundColor: Colors.transparent,
                                    child: Center(
                                        child: Text(
                                      Helper.getInitials(
                                        contacts[index].name,
                                      ),
                                      style: robotoTextStyle.copyWith(
                                        color: Colors.black,
                                        fontSize: 18,
                                      ),
                                    )));
                              }
                            },
                            future: ChatRepository.instance
                                .getUserProfileImageFromUserCollectionFirestore(
                                    contacts[index].firebaseUuid),
                          )),
                    ),
                  ),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            contacts[index].name,
                            style: montserratSemiBoldTextStyle.copyWith(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: contacts[index].isSelected
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          SizedBox(height: 4),
                          (contacts[index].isRegistered == true &&
                                  contacts[index].firebaseUuid != 'null' &&
                                  contacts[index].firebaseUuid != null)
                              ? Text(
                                  contacts[index].relationship ?? '',
                                  style: montserratNormal.copyWith(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w400,
                                    color: contacts[index].isSelected
                                        ? Colors.white
                                        : Colors.black,
                                  ),
                                )
                              : Row(
                                  children: [
                                    Text(
                                      contacts[index].relationship ?? '',
                                      style: montserratNormal.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: contacts[index].isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                    if (contacts[index].relationship != null &&
                                        contacts[index].relationship != "null")
                                      Text(
                                        ' • ',
                                        style: montserratNormal.copyWith(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w400,
                                          color: contacts[index].isSelected
                                              ? Colors.white
                                              : Colors.black,
                                        ),
                                      ),
                                    Text(
                                      contacts[index].firebaseUuid != 'null' &&
                                          contacts[index].firebaseUuid != null?'Awaiting Registration':'Can\'t Chat',
                                      style: montserratNormal.copyWith(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w400,
                                        color: contacts[index].isSelected
                                            ? Colors.white
                                            : Colors.black,
                                      ),
                                    ),
                                  ],
                                ),
                        ],
                      ),
                    ],
                  ),
                  onTap: ignoring
                      ? () {}
                      : () async {
                          print(contacts[index].firebaseUuid);
                          if ((contacts[index].isRegistered == null ||
                                  contacts[index].isRegistered == false) ||
                              contacts[index].firebaseUuid == null) {
                            Helper.showToast(
                                'Can\'t chat with unregistered user');
                            return;
                          }

                          if (widget.isGroupChat) {
                            setState(() {
                              if ((contacts[index].isRegistered != false))
                                contacts[index].isSelected =
                                    !contacts[index].isSelected;
                            });
                          } else {
                            if ((contacts[index].isRegistered == null &&
                                    contacts[index].isRegistered == false) &&
                                contacts[index].firebaseUuid == null) {
                              return;
                            }
                            setState(() {
                              ignoring = true;
                            });
                            final room = await FirebaseChatCore.instance
                                .createRoom(
                                    User(id: contacts[index].firebaseUuid));

                            ChatPendoRepo.trackCreatingDirectChat(
                              otherUserSfid: contacts[index].sfid,
                              pendoState: pendoState,
                            );
                            setState(() {
                              ignoring = false;
                            });
                            final route = MaterialPageRoute(
                              builder: (_) => ChatMessageScreen(
                                room: room,
                              ),
                            );
                            Navigator.pushReplacement(context, route);
                          }
                        },
                );
              }),
            ),
          );
        },
      ),
    );
  }
}
