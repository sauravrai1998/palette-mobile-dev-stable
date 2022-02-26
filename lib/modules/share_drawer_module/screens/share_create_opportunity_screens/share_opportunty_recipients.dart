import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/searchbar_recipients.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/explore_module/widgets/multiSelectItemForOpp.dart';
import 'package:palette/modules/explore_module/widgets/sendToProgramButton.dart';
import 'package:palette/modules/share_drawer_module/model/share_detail_view_model.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../main.dart';
import '../share_detail_view.dart';

class ShareSelectRecipientsForOpp extends StatefulWidget {
  final ShareDetailViewForOppModel shareDetailViewModel;
  final bool isFromCreateOpp;
  ShareSelectRecipientsForOpp(
      {Key? key,
      required this.shareDetailViewModel,
      required this.isFromCreateOpp})
      : super(key: key);

  @override
  _ShareSelectRecipientsForOppState createState() =>
      _ShareSelectRecipientsForOppState();
}

class _ShareSelectRecipientsForOppState
    extends State<ShareSelectRecipientsForOpp> {
  List<ContactsData> recipientsList = [];
  List<ContactsData> mainRecipientsList = [];
  List<ContactsData> selectedRecipients = [];
  bool isSendToProgramSelectedFlag = false;
  String instituteLogo = '';
  String instituteName = '';
  TextEditingController searchController = TextEditingController();
  FocusNode _searchFocusNode = FocusNode();
  bool isRecipientsListFetched = false;

  @override
  void initState() {
    super.initState();
    setInsituteNameLogo();
  }

  void setInsituteNameLogo() async {
    var prefs = await SharedPreferences.getInstance();
    instituteLogo = prefs.getString(instituteLogoKey).toString();
    instituteName = prefs.getString(instituteNameKey) ?? 'in the function';
    setState(() {});
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
              if (!isRecipientsListFetched){
                recipientsList = state.contactsResponse.contacts
                    .where((element) => element.canCreateOpportunity)
                    .toList();
                selectedRecipients = recipientsList
                    .where((element) => element.isSelected)
                    .toList();
                mainRecipientsList = recipientsList;
                isRecipientsListFetched = true;
              }
              _searchFocusNode.addListener(() {
                if (_searchFocusNode.hasFocus) {
                  setState(() {});
                } else {
                  setState(() {});
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
                  ListView(
                    controller: scrollController,
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
                      Text(
                        'Select Recipients',
                        style: roboto700.copyWith(
                          color: defaultDark,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 14,
                      ),
                     if (!_searchFocusNode.hasFocus)
                      SendToProgramButton(
                          instituteImage: instituteLogo,
                          instituteName: instituteName,
                          isSelected: isSendToProgramSelectedFlag,
                          onTap: () {
                            isSendToProgramSelectedFlag =
                                !isSendToProgramSelectedFlag;
                            selectedRecipients = [];
                            recipientsList.forEach((element) {
                              element.isSelected = false;
                            });
                            setState(() {});
                          }),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                          child: SearchBarForRecipients(
                            searchFocusNode: _searchFocusNode,
                              searchController: searchController,
                              onChanged: _onChanged)),
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
                      //if (state is GetContactsSuccessState)
                      TextScaleFactorClamper(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: ListView.builder(
                            controller: scrollController,
                            itemCount: recipientsList.length,
                            itemBuilder: (ctx, ind) {
                              return MultiSelectItemOpportunity(
                                  image: recipientsList[ind].profilePicture,
                                  name: recipientsList[ind].name,
                                  select: recipientsList[ind].isSelected,
                                  isSelected: (bool value) {
                                    if (isSendToProgramSelectedFlag) {
                                      isSendToProgramSelectedFlag = false;
                                    }
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
                      ),
                      // if (state is GetContactsLoadingState)
                      //   Center(
                      //     child: CircularProgressIndicator(),
                      //   ),
                    ],
                  ),
                  if (selectedRecipients.length != 0 ||
                      isSendToProgramSelectedFlag)
                    Positioned(
                      bottom: 20,
                      right: 20,
                      child: InkWell(
                        onTap: () {
                          if (widget.isFromCreateOpp) {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShareDetailView(
                                          shareDetailViewModel:
                                              widget.shareDetailViewModel,
                                          selectedRecipientsList:
                                              selectedRecipients,
                                          isSendToProgramSelected:
                                              isSendToProgramSelectedFlag,
                                        )));
                          } else {
                            Navigator.pop(context);
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShareDetailView(
                                          shareDetailViewModel:
                                              widget.shareDetailViewModel,
                                          selectedRecipientsList:
                                              selectedRecipients,
                                          isSendToProgramSelected:
                                              isSendToProgramSelectedFlag,
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

  void _onChanged(String value) {
    if (value.isEmpty) {
      setState(() {
        recipientsList = mainRecipientsList;
      });
    } else {
      setState(() {
        recipientsList = mainRecipientsList
            .where((element) =>
                element.name.toLowerCase().contains(value.toLowerCase()))
            .toList();
      });
    }
  }
}
