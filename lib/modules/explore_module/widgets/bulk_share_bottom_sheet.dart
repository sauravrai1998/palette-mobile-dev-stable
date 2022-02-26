import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/searchbar_recipients.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

import '../../../main.dart';

class BulkShareBottomSheetView extends StatefulWidget {
  final Function(List<String>) onPressed;

  const BulkShareBottomSheetView({
    Key? key,
    required this.onPressed,
  }) : super(key: key);

  @override
  _BulkShareBottomSheetViewState createState() =>
      _BulkShareBottomSheetViewState();
}

class _BulkShareBottomSheetViewState extends State<BulkShareBottomSheetView> {
  List<ContactsData> contacts = [];
  bool isContactFetched = false;

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(builder: (context, stateSetter) {
      return BlocBuilder<GetContactsBloc, GetContactsState>(
          builder: (context, state) {
        if (state is GetContactsSuccessState){
          if (!isContactFetched){
            contacts = state.contactsResponse.contacts.where((element) {
              element.isSelected = false;
              return element.canShareOpportuity;
            }).toList();
            isContactFetched = true;
          }

          }
        return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
            builder: (context, pendoState) {
          return DraggableScrollableSheet(
              initialChildSize: 0.7,
              maxChildSize: 0.95, // full screen on scroll
              minChildSize: 0.5,
              builder: (context, scrollController) {
                return Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(25.0),
                    ),
                  ),
                  child: Stack(
                    children: [
                      ListView(
                        controller: scrollController,
                        children: [
                          Center(
                            child: Container(
                              margin: EdgeInsets.only(top: 5, bottom: 15),
                              height: 4,
                              width: 42,
                              color: defaultDark,
                            ),
                          ),
                          BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                              builder: (context, pendoState) {
                            return Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              height: 70,
                              width: 200,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                      backgroundColor: white,
                                      radius: 30,
                                      backgroundImage: NetworkImage(pendoState.instituteLogo),
                                  ),
                                  SizedBox(width: 10),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * .7,
                                    child: Text(
                                      pendoState.instituteName,
                                      style: roboto700.copyWith(
                                          fontSize: 16,
                                          color: defaultDark.withOpacity(0.5)),
                                      maxLines: 2,
                                      overflow: TextOverflow.clip,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }),
                          if (state is GetContactsSuccessState)
                            userListView(scrollController, contacts,
                                stateChanged: () {
                              stateSetter(() {});
                            }),
                        ],
                      ),
                      atLeastOneItemInShareableListSelected(contacts)
                          ? Positioned(
                              bottom: 30,
                              right: 30,
                              child: floatingShareActionButtons(
                                  image: 'share.svg',
                                  onPressed: () {
                                    final selectedContacts = contacts
                                        .where((element) => element.isSelected)
                                        .toList();
                                    final ids = selectedContacts
                                        .map((e) => e.sfid)
                                        .toList();
                                    widget.onPressed(ids);
                                  }))
                          : Container()
                    ],
                  ),
                );
              });
        });
      });
    });
  }

  bool atLeastOneItemInShareableListSelected(List<ContactsData> contacts) {
    final c = contacts.where((element) => element.isSelected).toList();
    return c.isNotEmpty;
  }

  Widget userListView(
      ScrollController scrollController, List<ContactsData> list,
      {required Function stateChanged}) {
    var contactList =
        list.where((element) {
          return element.canShareOpportuity;
        }).toList();
    final copycontactList = contactList;
    var searchController =   TextEditingController();
    if (contactList.length > 0) {
      return StatefulBuilder(builder: (context, stateSetter) {
        return Stack(
          children: [
            TextScaleFactorClamper(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Column(
                  children: [
                    SearchBarForRecipients(searchController: searchController, onChanged: (value) {
                        contactList = copycontactList
                            .where((element) =>
                                element.name.toLowerCase().contains(value.toLowerCase()))
                            .toList();
                      stateSetter(() {});
                    },),
                    Flexible(
                      child: ListView.builder(
                          itemCount: contactList.length,
                          controller: scrollController,
                          itemBuilder: (context, index) {
                            final contact = contactList[index];
                    
                            return InkWell(
                              onTap: () {
                                contact.isSelected = !contact.isSelected;
                                stateSetter(() {});
                                stateChanged();
                              },
                              child: _userListItem(
                                contact: contact,
                                index: index,
                                contactList: contactList,
                                context: context,
                              ),
                            );
                          }),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      });
    } else
      return Container();
  }

  Widget _userListItem({
    required ContactsData contact,
    required int index,
    required List<ContactsData> contactList,
    required BuildContext context,
  }) {
    return Container(
      padding: EdgeInsets.all(8),
      margin: EdgeInsets.only(left: 22, right: 22, bottom: 5),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(Radius.circular(10)),
        color:
            contactList[index].isSelected == true ? defaultDark : Colors.white,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            width: 9,
          ),
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(width: 2, color: defaultDark)),
            child: contact.profilePicture != null
                ? CachedNetworkImage(
                    imageUrl: contact.profilePicture ?? '',
                    imageBuilder: (context, imageProvider) => Container(
                      width: 59,
                      height: 59,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        image: DecorationImage(
                            image: imageProvider, fit: BoxFit.cover),
                      ),
                    ),
                    placeholder: (context, url) => CircleAvatar(
                        radius:
                            // widget.screenHeight <= 736 ? 35 :
                            29,
                        backgroundColor: Colors.white,
                        child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        Center(child: Text(Helper.getInitials(contact.name))),
                  )
                : Center(
                    child: Text(Helper.getInitials(contact.name),
                        style: kalamLight.copyWith(
                          color: defaultDark,
                        ))),
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contact.name,
                style: roboto700.copyWith(
                    color: contactList[index].isSelected == true
                        ? Colors.white
                        : defaultDark,
                    fontSize: 14),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
              SizedBox(
                height: 5,
              ),
              // Container(
              //     width: MediaQuery.of(context).size.width * 0.6,
              //     child: Text(contact.instituteName ?? '',
              //         style: roboto700.copyWith(
              //             color: contactList[index].isSelected == true
              //                 ? Colors.white
              //                 : defaultDark,
              //             fontSize: 14),
              //         overflow: TextOverflow.ellipsis,
              //         maxLines: 1)),
              SizedBox(
                height: 2,
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    SizedBox(
                      width: 4,
                    ),
                  ],
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget floatingShareActionButtons(
      {String? image, String? text, required Function onPressed}) {
    return Builder(builder: (context) {
      return InkWell(
        onTap: () {
          onPressed();
        },
        child: Container(
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: purpleBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: SvgPicture.asset('images/$image'),
              ),
            )),
      );
    });
  }

  Widget floatingLoader() {
    return Center(
        child: Container(
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: purpleBlue,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  spreadRadius: 0,
                  blurRadius: 8,
                  offset: Offset(0, 2), // changes position of shadow
                ),
              ],
            ),
            child: SizedBox(
              width: 40,
              height: 40,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircularProgressIndicator(
                  valueColor: new AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            )));
  }
}
