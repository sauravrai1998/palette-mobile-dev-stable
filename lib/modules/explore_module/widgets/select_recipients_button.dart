import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/searchbar_recipients.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/explore_module/widgets/multiSelectItemForOpp.dart';
import 'package:palette/modules/explore_module/widgets/sendToProgramButton.dart';
import 'package:palette/utils/konstants.dart';

import '../../../main.dart';

// ignore: must_be_immutable
class SelectRecipientButton extends StatelessWidget {
  final List<ContactsData> recipientsList;
  final Function(List<ContactsData>) onRecipientSelected;
  final String selectedRecipientsTitle;
  List<ContactsData> selectedRecipients;
  final bool errorFlag;
  final bool isLoading;
  Function(bool) sendToProgramSelected;
  bool isSendToProgramSelectedFlag;
  String? instituteName;
  String? instituteImage;
  SelectRecipientButton({
    required this.recipientsList,
    required this.onRecipientSelected,
    required this.selectedRecipientsTitle,
    required this.selectedRecipients,
    required this.errorFlag,
    required this.isLoading,
    required this.sendToProgramSelected,
    required this.isSendToProgramSelectedFlag,
    this.instituteName,
    this.instituteImage,
  });

  TextEditingController searchController = TextEditingController();
  List<ContactsData> mainRecipientsList = [];

  @override
  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    mainRecipientsList = recipientsList;
    instituteImage = pendoState.instituteLogo;
    instituteName = pendoState.instituteName;
    return GestureDetector(
      onTap: () {
        _showAssigneeBottomSheet(context);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        width: MediaQuery.of(context).size.width * 0.8,
        height: 40,
        child: Row(
          children: [
            SvgPicture.asset(
              'images/people_outline.svg',
              color: selectedRecipients.isEmpty && selectedRecipientsTitle == ''
                  ? selectedRecipients.isEmpty &&
                          selectedRecipientsTitle == '' &&
                          errorFlag
                      ? todoListActiveTab
                      : defaultDark.withOpacity(0.6)
                  : defaultDark,
            ),
            Visibility(
              visible: selectedRecipients.isNotEmpty,
              child: Row(
                children: [
                  SizedBox(width: 4),
                  Text('${selectedRecipients.length}',
                      style: roboto700.copyWith(
                        color: defaultDark,
                        fontSize: 16,
                      )),
                  SizedBox(width: 5),
                  Container(
                      width: 2,
                      height: 20,
                      color: defaultDark.withOpacity(0.4)),
                ],
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: Text(
                isLoading
                    ? 'Loading...'
                    : isSendToProgramSelectedFlag
                        ? 'Global Opportunity'
                        : selectedRecipients.isEmpty &&
                                selectedRecipientsTitle == ''
                            ? 'select recipient (s)'
                            : '$selectedRecipientsTitle',
                style: TextStyle(
                    color: selectedRecipients.isEmpty &&
                            selectedRecipientsTitle == ''
                        ? selectedRecipients.isEmpty &&
                                selectedRecipientsTitle == '' &&
                                errorFlag
                            ? todoListActiveTab
                            : defaultDark.withOpacity(0.6)
                        : defaultDark,
                    fontSize: 16,
                    fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
              ),
            ),
            Icon(
              Icons.keyboard_arrow_down,
              color: selectedRecipients.isEmpty && selectedRecipientsTitle == ''
                  ? selectedRecipients.isEmpty &&
                          selectedRecipientsTitle == '' &&
                          errorFlag
                      ? todoListActiveTab
                      : defaultDark.withOpacity(0.6)
                  : defaultDark,
            ),
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: selectedRecipients.isEmpty &&
                      selectedRecipientsTitle == '' &&
                      errorFlag
                  ? todoListActiveTab
                  : Colors.transparent,
              width: 2.0,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.15),
                blurRadius: 5,
                offset: Offset(0, 1),
              ),
            ]),
      ),
    );
  }

  void _showAssigneeBottomSheet(BuildContext context) {
    showModalBottomSheet(
        backgroundColor: Colors.transparent,
        context: context,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        isScrollControlled: true,
        builder: (context) {
          return StatefulBuilder(builder: (context, bottomSheetState) {
            return DraggableScrollableSheet(
                initialChildSize: 0.6,
                maxChildSize: 0.95, // full screen on scroll
                minChildSize: 0.5,
                builder: (context, scrollController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                    ),
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.only(
                                  left: 120, right: 120, top: 5),
                              color: defaultDark,
                              height: 3,
                              width: 100,
                            ),
                            SizedBox(height: 10),
                            Text(
                              'Select Recipients',
                              style: roboto700.copyWith(
                                color: defaultDark,
                                fontSize: 18,
                              ),
                            ),
                            SizedBox(height: 10),
                            SendToProgramButton(
                                isSelected: isSendToProgramSelectedFlag,
                                instituteName: instituteName != null
                                    ? instituteName!
                                    : "TAWS - Tranzed Academy For Working Students",
                                instituteImage: instituteImage != null
                                    ? instituteImage!
                                    : 'images/TAWS.png',
                                onTap: () {
                                  isSendToProgramSelectedFlag =
                                      !isSendToProgramSelectedFlag;
                                  selectedRecipients = [];
                                  mainRecipientsList.forEach((element) {
                                    element.isSelected = false;
                                  });
                                  bottomSheetState(() {});
                                }),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              child: SearchBarForRecipients(
                                  searchController: searchController,
                                  onChanged: (String text) {
                                    if (text.trim().isNotEmpty) {
                                      mainRecipientsList = recipientsList
                                          .where((element) => element.name
                                              .toLowerCase()
                                              .contains(text.toLowerCase()))
                                          .toList();
                                    }
                                    if (text.trim().isEmpty) {
                                      mainRecipientsList = recipientsList;
                                    }
                                    bottomSheetState(() {});
                                  }),
                            ),
                            SizedBox(height: 10),
                            // List of Recipients
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
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
                                  itemCount: mainRecipientsList.length,
                                  controller: scrollController,
                                  itemBuilder: (ctx, ind) {
                                    return MultiSelectItemOpportunity(
                                        image: mainRecipientsList[ind]
                                            .profilePicture,
                                        name: mainRecipientsList[ind].name,
                                        select:
                                            mainRecipientsList[ind].isSelected,
                                        isSelected: (bool value) {
                                          if (isSendToProgramSelectedFlag) {
                                            isSendToProgramSelectedFlag = false;
                                            bottomSheetState(() {});
                                          }
                                          mainRecipientsList[ind].isSelected =
                                              value;
                                          if (value) {
                                            selectedRecipients
                                                .add(mainRecipientsList[ind]);
                                          } else {
                                            selectedRecipients.remove(
                                                mainRecipientsList[ind]);
                                          }
                                        });
                                  },
                                ),
                              ),
                            )
                          ],
                        ),
                        Positioned(
                          bottom: 20,
                          right: 20,
                          child: InkWell(
                            onTap: () {
                              Navigator.pop(context);
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
        }).whenComplete(() {
      sendToProgramSelected(isSendToProgramSelectedFlag);
      onRecipientSelected(selectedRecipients);
      searchController.clear();
    });
  }
}
