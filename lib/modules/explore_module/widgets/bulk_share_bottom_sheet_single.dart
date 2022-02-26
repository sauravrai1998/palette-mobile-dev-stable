import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/explore_module/blocs/explore_detail_bloc.dart';
import 'package:palette/modules/explore_module/models/explore_status.dart';
import 'package:palette/modules/explore_module/models/student_list_response.dart';
import 'package:palette/modules/explore_module/services/explore_repository.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

import '../../../common_components/searchbar_recipients.dart';
import '../../../main.dart';

class BulkShareBottomSheetForSingle extends StatefulWidget {
  final String eventId;
  final Function(List<String>) onPressed;
  const BulkShareBottomSheetForSingle({
    Key? key,
    required this.eventId,
    required this.onPressed,
  }) : super(key: key);

  @override
  _BulkShareBottomSheetForSingleState createState() =>
      _BulkShareBottomSheetForSingleState();
}

class _BulkShareBottomSheetForSingleState
    extends State<BulkShareBottomSheetForSingle> {
  ExploreDetailBloc _bloc =
      ExploreDetailBloc(exploreRepo: ExploreRepository.instance);

  @override
  void dispose() {
    _bloc.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _bloc.getUsersListShareOpp(eventId: widget.eventId);
  }

  bool isStudentsFeatched = false;
  var searchController = TextEditingController();
  List<StudentByInstitute> mainRecipientsList = [];
  List<StudentByInstitute> filteredRecipientsList = [];
  
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

  @override
  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    return StreamBuilder<List<StudentByInstitute>>(
        stream: _bloc.studentListObserver.stream,
        builder: (context, snapshot) {
          if (snapshot.data != null &&
              snapshot.connectionState == ConnectionState.active) {
            if (!isStudentsFeatched) {
              _bloc.studentListObserver.sink.add(_bloc.studentList);
              mainRecipientsList = snapshot.data ?? [];
              filteredRecipientsList = mainRecipientsList;
              isStudentsFeatched = true;
            }
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
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 10),
                              height: 70,
                              width: 200,
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: white,
                                    radius: 30,
                                    backgroundImage:
                                        NetworkImage(pendoState.instituteLogo),
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
                            ),
                            Container(
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: SearchBarForRecipients(
                                    searchController: searchController,
                                    onChanged: (String text) {
                                      if (text.trim().isNotEmpty) {
                                        filteredRecipientsList =
                                            mainRecipientsList
                                                .where((element) => element
                                                    .name!
                                                    .toLowerCase()
                                                    .contains(
                                                        text.toLowerCase()))
                                                .toList();
                                      }
                                      if (text.trim().isEmpty) {
                                        filteredRecipientsList =
                                            mainRecipientsList;
                                      }
                                      setState(() {});
                                    })),
                            SizedBox(height: 10),
                            userListView(
                                scrollController, filteredRecipientsList,
                                stateChanged: () {
                              setState(() {});
                            }),
                          ],
                        ),
                        atLeastOneItemInShareableListSelected(
                                snapshot.data ?? [])
                            ? Positioned(
                                bottom: 30,
                                right: 30,
                                child: floatingShareActionButtons(
                                    image: 'share.svg',
                                    onPressed: () {
                                      var selectedContacts = mainRecipientsList
                                              .where((element) =>
                                                  element.isSelected! == true);
                                      var ids = selectedContacts
                                          .map((e) => e.id ?? '')
                                          .toList();
                                      widget.onPressed(ids);
                                    }))
                            : Container()
                      ],
                    ),
                  );
                });
          } else if (snapshot.connectionState == ConnectionState.waiting) {
            return DraggableScrollableSheet(
                initialChildSize: 0.7,
                maxChildSize: 0.95, // full screen on scroll
                minChildSize: 0.5,
                builder: (context, scrollController) {
                  return Container(
                    child: floatingLoader(),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.vertical(
                        top: Radius.circular(25.0),
                      ),
                    ),
                  );
                });
          } else {
            return Container();
          }
        });
  }

  bool atLeastOneItemInShareableListSelected(
      List<StudentByInstitute> contacts) {
    final c = contacts.where((element) => element.isSelected ?? false).toList();
    return c.isNotEmpty;
  }

  Widget userListView(
      ScrollController scrollController, List<StudentByInstitute> contactList,
      {required Function stateChanged}) {
    if (contactList.length > 0) {
      return StatefulBuilder(builder: (context, stateSetter) {
        return Stack(
          children: [
            TextScaleFactorClamper(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.89,
                padding: EdgeInsets.only(bottom: contactList.length < 5 ? 0 : 100),
                child: ListView.builder(
                    itemCount: contactList.length,
                    controller: scrollController,
                    itemBuilder: (context, index) {
                      final contact = contactList[index];

                      return InkWell(
                        onTap: contact.status == ExploreStatus.Enrolled.value ||
                                contact.status ==
                                    ExploreStatus.Recommended.value ||
                                contact.status == ExploreStatus.CantShare.value
                            ? null
                            : () {
                                contact.isSelected = !contact.isSelected!;
                                mainRecipientsList[index].isSelected =
                                    contact.isSelected;
                                stateSetter(() {});
                                stateChanged();
                              },
                        child: _userListItem(
                          stu: contact,
                          index: index,
                          studentList: contactList,
                          context: context,
                        ),
                      );
                    }),
              ),
            ),
          ],
        );
      });
    } else
      return Container();
  }

  Widget _userListItem({
    required StudentByInstitute stu,
    required int index,
    required List<StudentByInstitute> studentList,
    required BuildContext context,
  }) {
    return Stack(
      children: [
        Container(
          padding: EdgeInsets.all(8),
          margin: EdgeInsets.only(left: 22, right: 22, bottom: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(10)),
            color: studentList[index].isSelected == true
                ? defaultDark
                : Colors.white,
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
                child: stu.profilePicture != null
                    ? CachedNetworkImage(
                        imageUrl: stu.profilePicture ?? '',
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
                        errorWidget: (context, url, error) {
                          if (stu.name == null) return Container();
                          return Center(
                              child: Text(Helper.getInitials(stu.name!)));
                        })
                    : Center(
                        child: Text(Helper.getInitials(stu.name ?? ''),
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
                  if (stu.name != null)
                    Text(
                      stu.name!,
                      style: roboto700.copyWith(
                          color: studentList[index].isSelected == true
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
        ),
        Positioned(
          right: 20,
          bottom: 14,
          child: Container(
              child: Text(
                  stu.status == ExploreStatus.Disinterest.value
                      ? ExploreStatus.Disinterest.name
                      : stu.status! == 'Open'
                          ? ''
                          : stu.status!,
                  style: roboto700.copyWith(
                      color: _bloc.studentList[index].isSelected == true
                          ? Colors.white
                          : defaultDark,
                      fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1)),
        )
      ],
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
}
