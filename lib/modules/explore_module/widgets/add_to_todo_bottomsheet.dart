import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/searchbar_recipients.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/explore_module/blocs/explore_bloc.dart';
import 'package:palette/modules/explore_module/blocs/opportunity_bloc/add_opportunities_consideration_bloc.dart';
import 'package:palette/modules/explore_module/services/explore_pendo_repo.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';
import 'package:palette/modules/explore_module/widgets/sendToProgramButton.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../main.dart';

class AddTodoBottomSheet extends StatefulWidget {
  final List<String> oppurtunityIds;
  AddTodoBottomSheet({required this.oppurtunityIds});

  @override
  _AddTodoBottomSheetState createState() => _AddTodoBottomSheetState();
}

class _AddTodoBottomSheetState extends State<AddTodoBottomSheet> {
  List<ContactsData> contacts = [];
  List<ContactsData> copyContacts = [];

  List<String> selectedContactsId = [];

  bool isSharePressed = false;
  bool _isSendToProgramSelected = false;
  bool _isCurrrentUserSelected = false;
  String? _userImageurl;
  String _currentuserId = '';
  var searchController = TextEditingController();
  bool isAdmin = false;
  bool isContactsFetched = false;

  @override
  void initState() {
    super.initState();
    _setUserProfile();
  }

  _setUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _currentuserId = prefs.getString(sfidConstant) ?? '';
    _userImageurl = prefs.getString(profilePictureConstant);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AddOpportunitiesToTodoBloc,
            AddOpportunitiesToTodoState>(
        listener: (context, state) {
          if (state is AddOpportunitiesToTodoSuccessState) {
            Navigator.pop(context);
            var _bloc =
                ExploreListBloc(exploreRepo: ExploreRepository.instance);
            _bloc.getExploreList();
          }
          if (state is AddOpportunitiesToTodoFailureState) {
            Helper.showToast(state.error);
          }
        },
        child: showBottomSheet(context));
  }

  Widget showBottomSheet(BuildContext context) {

    return BlocBuilder<GetContactsBloc, GetContactsState>(
        builder: (context, state) {
      if (state is GetContactsSuccessState) {
        if (!isContactsFetched) {
          isContactsFetched = true;
          contacts = state.contactsResponse.contacts
              .where((element) {
                element.isSelected = false;
                return element.canShareOpportuity;
              })
              .toList();
          copyContacts = contacts;
        }
      }
      return BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
          builder: (context, pendoState) {
        isAdmin = pendoState.role.toLowerCase() == 'admin';
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
                            margin: EdgeInsets.only(top: 5, bottom: 10),
                            height: 4,
                            width: 62,
                            color: defaultDark
                          )
                        ),
                        _currentUserItem(
                            isSelected: _isCurrrentUserSelected,
                            onTap: () {
                              _isCurrrentUserSelected =
                                  !_isCurrrentUserSelected;
                              if (_isCurrrentUserSelected) {
                                _isSendToProgramSelected = false;
                                if (_currentuserId != '') {
                                  selectedContactsId.add(_currentuserId);
                                }
                              } else {
                                selectedContactsId.remove(_currentuserId);
                              }

                              setState(() {});
                            }),
                        SizedBox(height: 5),
                        searchBar(),
                        SizedBox(height: 5),
                        if (isAdmin)
                          Column(
                            children: [
                              SizedBox(height: 5),
                              SendToProgramButton(
                                  isSelected: _isSendToProgramSelected,
                                  instituteName: pendoState.instituteName,
                                  instituteImage: pendoState.instituteLogo,
                                  onTap: () {
                                    setState(() {
                                      _isSendToProgramSelected =
                                          !_isSendToProgramSelected;
                                      _isCurrrentUserSelected = false;
                                      contacts.forEach((element) {
                                        element.isSelected = false;
                                      });
                                      selectedContactsId = [];
                                    });
                                  }),
                              SizedBox(height: 15),
                            ],
                          ),
                        if (state is GetContactsSuccessState)
                          userListView(scrollController, contacts,
                              stateChanged: () {
                            //stateSetter(() {});
                            setState(() {});
                          }),
                      ],
                    ),
                    isFABVisible(contacts)
                        ? Positioned(
                            bottom: 30,
                            right: 30,
                            child: BlocBuilder<AddOpportunitiesToTodoBloc,
                                    AddOpportunitiesToTodoState>(
                                builder: (context, state) {
                              if (state is AddOpportunitiesToTodoLoadingState) {
                                return floatingLoader();
                              } else
                                return floatingShareActionButtons(
                                    image: 'share.svg',
                                    onPressed: () {
                                      {
                                        final pendoState =
                                            BlocProvider.of<PendoMetaDataBloc>(
                                                    context)
                                                .state;
                                        ExplorePendoRepo.trackBulkAddOppToTodo(
                                          eventIds: widget.oppurtunityIds,
                                          assigneesIds: selectedContactsId,
                                          isSendToProgramSelected:
                                              _isSendToProgramSelected,
                                          pendoState: pendoState,
                                        );
                                        BlocProvider.of<AddOpportunitiesToTodoBloc>(
                                                context)
                                            .add(AddOppToTodoEvent(
                                                opportunitiesIds:
                                                    widget.oppurtunityIds,
                                                assigneesIds: selectedContactsId,
                                        instituteId: _isSendToProgramSelected,context: context));
                                      }
                                      isSharePressed = true;
                                      //After
                                      contacts.forEach((element) {
                                        element.isSelected = false;
                                      });
                                      // Navigator.pop(context);

                                      log('share $selectedContactsId');
                                    });
                            }))
                        : Container()
                  ],
                ),
              );
            });
      });
    });
  }

  bool isFABVisible(List<ContactsData> contacts) {
    final c = contacts.where((element) => element.isSelected).toList();
    if (c.length > 0 || _isCurrrentUserSelected || _isSendToProgramSelected) {
      return true;
    } else {
      return false;
    }
  }

  Widget userListView(
      ScrollController scrollController, List<ContactsData> list,
      {required Function stateChanged}) {
        final deviceHeight = MediaQuery.of(context).size.height;
    final contactList =
        list.where((element) => element.canShareOpportuity).toList();
    if (contactList.length > 0) {
      return Stack(
        children: [
          TextScaleFactorClamper(
            child: Container(
              height: isAdmin ? deviceHeight * 0.63 : deviceHeight * 0.74,
            //  padding: EdgeInsets.only(bottom: contactList.length < 5 ? 0 : isAdmin ? deviceHeight * 0.29 : 80),
              child: Expanded(
                child: ListView.builder(
                    itemCount: contactList.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      final contact = contactList[index];
              
                      return InkWell(
                        onTap: () {
                          _isSendToProgramSelected = false;
                          contact.isSelected = !contact.isSelected;
                          stateChanged();
                          if (contact.isSelected) {
                            selectedContactsId.add(contact.sfid);
                          } else {
                            selectedContactsId.remove(contact.sfid);
                          }
                          setState(() {});
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
            ),
          ),
        ],
      );
    } else
      return Container(
        height: MediaQuery.of(context).size.height * 0.8,
        child: Center(
          child: Text(
            'No contacts to share oppurtunity with',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      );
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
                        radius: 29,
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
      {String? image, String? text, Function? onPressed}) {
    if (isSharePressed == false) {
      return InkWell(
        onTap: () {
          onPressed!();
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
    } else {
      return floatingLoader();
    }
  }

  Widget floatingLoader() {
    return Column(
      children: [
        Container(
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
            ))
      ],
    );
  }

  Widget _currentUserItem(
      {required bool isSelected, required Function()? onTap}) {
    String name = BlocProvider.of<PendoMetaDataBloc>(context).state.name;
    String role = BlocProvider.of<PendoMetaDataBloc>(context).state.role;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.only(left: 22, right: 22, bottom: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(10)),
          color: isSelected ? defaultDark : Colors.white,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(width: 9),
            Container(
              width: 58,
              height: 58,
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  border: Border.all(width: 2, color: defaultDark)),
              child: _userImageurl != null
                  ? CachedNetworkImage(
                      imageUrl: _userImageurl ?? '',
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
                          radius: 29,
                          backgroundColor: Colors.white,
                          child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) => Center(
                          child: Text(Helper.getInitials(name),
                              style: kalamLight.copyWith(color: defaultDark))),
                    )
                  : Center(
                      child: Text(Helper.getInitials(name),
                          style: kalamLight.copyWith(color: defaultDark))),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: roboto700.copyWith(
                      color: isSelected == true ? Colors.white : defaultDark,
                      fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(
                  height: 5,
                ),
                Text('You',
                    style: roboto700.copyWith(
                        color: isSelected == true
                            ? Colors.white.withOpacity(0.5)
                            : defaultDark.withOpacity(0.5),
                        fontSize: 14)),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget searchBar() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: SearchBarForRecipients(
          onChanged: onSearchTextChanged,
          searchController: searchController,
        ));
  }

  void onSearchTextChanged(String text) async {
    if (text.trim().isNotEmpty) {
      setState(() {
        contacts = copyContacts
            .where((contact) =>
                contact.name.toLowerCase().contains(text.toLowerCase()))
            .toList();
      });
    } else {
      setState(() {
        contacts = copyContacts;
      });
    }
  }

  Widget placeholderUserImage(String role) {
    return SvgPicture.asset(
      'images/${role.toLowerCase()}_splash_ph.svg',
      width: 59,
      height: 59,
      semanticsLabel: "Profile picture",
    );
  }
}
