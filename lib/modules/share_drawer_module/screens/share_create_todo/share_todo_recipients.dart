import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/searchbar_recipients.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/share_drawer_module/model/share_detail_view_model.dart';
import 'package:palette/modules/share_drawer_module/screens/share_create_todo/share_todo_detail_view.dart';
import 'package:palette/modules/share_drawer_module/widgets/multiselect_recipients_item.dart';
import 'package:palette/utils/konstants.dart';

import '../../../../main.dart';

class ShareSelectRecipientsForTodo extends StatefulWidget {
  final ShareDetailForTodoViewModel shareDetailViewModel;
  final bool isFromCreateTodo;
  ShareSelectRecipientsForTodo(
      {Key? key,
      required this.shareDetailViewModel,
      required this.isFromCreateTodo})
      : super(key: key);

  @override
  _ShareSelectRecipientsForTodoState createState() =>
      _ShareSelectRecipientsForTodoState();
}

class _ShareSelectRecipientsForTodoState
    extends State<ShareSelectRecipientsForTodo> {
  List<ContactsData> recipientsList = [];
  List<ContactsData> recipientsListCopy = [];
  List<ContactsData> selectedRecipients = [];

  FocusNode _searchFocusNode = FocusNode();
  bool isRecipientsListFetched = false;
  bool isSearching = false;

  var searchController = TextEditingController();
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
                    .where((element) => element.canCreateTodo)
                    .toList();
                recipientsListCopy = recipientsList;
                selectedRecipients = recipientsList
                    .where((element) => element.isSelected)
                    .toList();
                isRecipientsListFetched = true;
              }
              _searchFocusNode.addListener(() {
                if (_searchFocusNode.hasFocus) {
                  setState(() {
                    isSearching = true;
                  });
                } else {
                  setState(() {
                    isSearching = false;
                  });
                }
              });
            }
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(8))))),
                      SizedBox(height: 14),
                      if(!isSearching)
                      Container(
                        height: 50,
                        child: Text(
                          'Who do you want to create \nthis To-Do for?',
                          style: roboto700.copyWith(
                            color: defaultDark,
                            fontSize: 20,
                          ),
                          textWidthBasis: TextWidthBasis.parent,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                        ),
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
                      TextScaleFactorClamper(
                        child: Expanded(
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: recipientsList.length,
                            itemBuilder: (ctx, ind) {
                              return MultiSelectRecipientsItem(
                                  image: recipientsList[ind].profilePicture,
                                  name: recipientsList[ind].name,
                                  select: recipientsList[ind].isSelected,
                                  relationship:
                                      recipientsList[ind].relationship,
                                  forChat: false,
                                  isSelected: (bool value) {
                                    recipientsList[ind].isSelected = value;
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
                      )
                    ],
                  ),
                  if (selectedRecipients.length != 0)
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: InkWell(
                        onTap: () {
                          if (widget.isFromCreateTodo) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShareDetailForTodoView(
                                          shareDetailViewModel:
                                              widget.shareDetailViewModel,
                                          selectedRecipientsList:
                                              selectedRecipients,
                                        )));
                          } else {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ShareDetailForTodoView(
                                          shareDetailViewModel:
                                              widget.shareDetailViewModel,
                                          selectedRecipientsList:
                                              selectedRecipients,
                                        )));
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
                      ),
                    )
                ],
              ),
            );
          });
        });
  }

  void onSearchTextChanged(String text) {
    if (text.trim().isEmpty) {
      setState(() {
        recipientsList = recipientsListCopy;
      });
    } else {
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
        searchFocusNode: _searchFocusNode,
          searchController: searchController, onChanged: onSearchTextChanged),
    );
  }
}
