import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/searchbar_recipients.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/share_drawer_module/services/sharedrawer_navigation_repo.dart';
import 'package:palette/modules/share_drawer_module/services/sharedrawer_pendo_repo.dart';
import 'package:palette/modules/share_drawer_module/share_drawer_bloc/send_chat_message_bloc.dart';
import 'package:palette/modules/share_drawer_module/widgets/multiselect_recipients_item.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

import '../../../../main.dart';

class ShareSelectContactSheet extends StatefulWidget {
  final String message;
  ShareSelectContactSheet({Key? key, required this.message}) : super(key: key);

  @override
  _ShareSelectContactSheetState createState() =>
      _ShareSelectContactSheetState();
}

class _ShareSelectContactSheetState extends State<ShareSelectContactSheet> {
  List<ContactsData> recipientsList = [];
  List<ContactsData> recipientsListCopy = [];
  List<ContactsData> selectedRecipients = [];

  var searchController = TextEditingController();
  bool isRecipientsListFetched = false;
  UserInfoModelForPendo? userInfoModelForPendo;
  @override
  void initState() {
    super.initState();
    fetchuserInfoModelForPendo();
  }

  fetchuserInfoModelForPendo() async {
    userInfoModelForPendo = await ShareDrawerPendoRepo.fetchUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95, // full screen on scroll
        minChildSize: 0.8,
        builder: (context, scrollController) {
          return BlocBuilder<GetContactsBloc, GetContactsState>(
              builder: (context, state) {
            if (state is GetContactsSuccessState) {
              if (!isRecipientsListFetched) {
                recipientsList = state.contactsResponse.contacts
                    .where((element) => element.canChat)
                    .toList();
                selectedRecipients = recipientsList
                    .where((element) => element.isSelected)
                    .toList();
                recipientsListCopy = recipientsList;
                isRecipientsListFetched = true;
              }
            }
            return BlocListener(
              bloc: BlocProvider.of<SendChatMessageBloc>(context),
              listener: (context, state) {
                if (state is SendChatMessageSuccessState) {
                  Navigator.pop(context);
                  ShareDrawerNavigationRepo.instance
                      .shareDrawerNavigationAfterSuccess(context: context);
                }
                if (state is SendChatMessageErrorState) {
                  Navigator.pop(context);
                  Helper.showToast(state.error);
                }
              },
              child: BlocBuilder<SendChatMessageBloc, SendChatMessageState>(
                  builder: (context, messagestate) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      topRight: Radius.circular(20),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Column(
                        children: [
                          SizedBox(height: 10),
                          Center(
                              child: Container(
                                  height: 4,
                                  width: 120,
                                  decoration: BoxDecoration(
                                      color: Color(0xFF787878),
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(8))))),
                          SizedBox(height: 14),
                          Text(
                            'Select Contacts',
                            style: roboto700.copyWith(
                              color: defaultDark,
                              fontSize: 20,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(
                            height: 14,
                          ),
                          searchBar(),
                          Container(
                            alignment: Alignment.centerLeft,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 20, vertical: 10),
                            child: Text(
                              'All Users',
                              style: roboto700.copyWith(
                                color: defaultDark,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          if (state is GetContactsSuccessState)
                            TextScaleFactorClamper(
                              child: Expanded(
                                child: ListView.builder(
                                  controller: scrollController,
                                  itemCount: recipientsList.length,
                                  itemBuilder: (ctx, ind) {
                                    return MultiSelectRecipientsItem(
                                        image:
                                            recipientsList[ind].profilePicture,
                                        name: recipientsList[ind].name,
                                        select: recipientsList[ind].isSelected,
                                        isRegistered:
                                            recipientsList[ind].isRegistered,
                                        relationship:
                                            recipientsList[ind].relationship,
                                        forChat: false,
                                        isSelected: (bool value) {
                                          recipientsList[ind].isSelected =
                                              value;
                                          if (value) {
                                            log(recipientsList[ind].name);
                                            selectedRecipients
                                                .add(recipientsList[ind]);
                                          } else {
                                            selectedRecipients
                                                .remove(recipientsList[ind]);
                                          }
                                          setState(() {});
                                        });
                                  },
                                ),
                              ),
                            ),
                          if (state is GetContactsLoadingState)
                            Center(
                              child: CustomPaletteLoader(),
                            ),
                        ],
                      ),
                      if (selectedRecipients.length != 0)
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: (messagestate is SendChatMessageSuccessState ||
                                  messagestate is SendChatMessageErrorState ||
                                  messagestate is SendChatMessageInitialState)
                              ? InkWell(
                                  onTap: () {
                                    //TODO: sent chat message
                                    BlocProvider.of<SendChatMessageBloc>(
                                            context)
                                        .add(SendChatMessageFromShareDrawer(
                                            message: widget.message,
                                            userIds: selectedRecipients));
                                    if (userInfoModelForPendo != null) {
                                      ShareDrawerPendoRepo.trackSendMessage(
                                          pendoState: userInfoModelForPendo!);
                                    }
                                  },
                                  child: Container(
                                    height: 38,
                                    width: 38,
                                    padding: EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: purpleBlue,
                                    ),
                                    child: SvgPicture.asset(
                                      "images/sendIcon.svg",
                                      height: 14,
                                      width: 14,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : Container(
                                  height: 38,
                                  width: 38,
                                  padding: EdgeInsets.all(10),
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: purpleBlue,
                                  ),
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation(
                                      Colors.white,
                                    ),
                                  ),
                                ),
                        )
                    ],
                  ),
                );
              }),
            );
          });
        });
  }

  void onSearchTextChanged(String text) {
    if (text.trim().isEmpty) {
      setState(() {
        recipientsList = recipientsListCopy;
      });
    }
    if (text.trim().isNotEmpty) {
      setState(() {
        recipientsList = recipientsListCopy
            .where((element) =>
                element.name.toLowerCase().contains(text.toLowerCase()))
            .toList();
      });
    }
  }

  Widget searchBar() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SearchBarForRecipients(
            searchController: searchController,
            onChanged: onSearchTextChanged));
  }
}
