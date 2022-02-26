import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:palette/utils/konstants.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactRowObserver extends StatelessWidget {
  final ObserverProfileUserModel userModel;
  // final bool thirdPerson;
  final double width;
  final String sfid;
  final String sfuuid;
  final String role;
  ContactRowObserver(
      {
        // required this.thirdPerson,
        required this.userModel,
        required this.width,
        required this.sfid,
        required this.sfuuid,
        required this.role});

  scrollToIndex(index) async {
    await Future.delayed(Duration(milliseconds: 200));
    print("called");

    await listViewController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.end);
  }

  AutoScrollController listViewController = new AutoScrollController();

  void launchURL(String url) async =>
      await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

  // List<Widget> socialLinkList = [];
  // setData() {
  //   socialLinkList = [];
  //
  //   socialLinkList.add(GestureDetector(
  //     onTap: () {
  //       launchURL('tel:${userModel.phone}');
  //     },
  //     child: Container(
  //         width: width * 1 / 7,
  //         color: defaultDark,
  //         child: Icon(
  //           Icons.call,
  //           color: defaultLight,
  //           size: 34,
  //           semanticLabel: "Phone Number",
  //         )),
  //   ));
  //
  //   socialLinkList.add(GestureDetector(
  //     onTap: () {
  //       launchURL('mailto:${userModel.email}?subject=""&body=""');
  //     },
  //     child: Container(
  //         width: width * 1 / 7,
  //         color: defaultDark,
  //         child: Icon(
  //           Imported.mail_black_18dp_1,
  //           color: defaultLight,
  //           size: 34,
  //           semanticLabel: "Email",
  //         )),
  //   ));
  //
  //   String webLink = userModel.websiteLink.toString();
  //   String instaLink = userModel.instagramLink.toString();
  //   String githubLink = userModel.githubLink.toString();
  //   String facebookLink = userModel.facebookLink.toString();
  //   String address = userModel.mailingStreet.toString();
  //   String linkedInLink = userModel.linkedInlink.toString();
  //
  //   if (webLink.isNotEmpty && webLink != 'null') {
  //     socialLinkList.add(GestureDetector(
  //       onTap: () {
  //         launchURL('http:$webLink');
  //       },
  //       child: Container(
  //           width: width * 1 / 7,
  //           color: defaultDark,
  //           child: Icon(
  //             Imported.language_black_18dp_1,
  //             color: defaultLight,
  //             size: 34,
  //             semanticLabel: "Website link",
  //           )),
  //     ));
  //   }
  //   if (instaLink.isNotEmpty && instaLink != 'null') {
  //     socialLinkList.add(GestureDetector(
  //       onTap: () {
  //         launchURL('http:$instaLink');
  //       },
  //       child: Container(
  //           width: width * 1 / 7,
  //           color: defaultDark,
  //           child: Icon(
  //             Imported.instagram,
  //             color: defaultLight,
  //             size: 34,
  //             semanticLabel: "Instagram",
  //           )),
  //     ));
  //   }
  //
  //   if (githubLink.isNotEmpty && githubLink != 'null') {
  //     socialLinkList.add(GestureDetector(
  //       onTap: () {
  //         launchURL('http:$githubLink');
  //       },
  //       child: Container(
  //           width: width * 1 / 7,
  //           color: defaultDark,
  //           child: Icon(
  //             Imported.github_squared,
  //             color: defaultLight,
  //             size: 34,
  //             semanticLabel: "Github link",
  //           )),
  //     ));
  //   }
  //   if (facebookLink.isNotEmpty && facebookLink != 'null') {
  //     socialLinkList.add(GestureDetector(
  //       onTap: () {
  //         launchURL('http:$facebookLink');
  //       },
  //       child: Container(
  //           width: width * 1 / 7,
  //           color: defaultDark,
  //           child: Icon(
  //             Imported.facebook_squared,
  //             color: defaultLight,
  //             size: 34,
  //             semanticLabel: "Facebook",
  //           )),
  //     ));
  //   }
  //   if (linkedInLink.isNotEmpty && linkedInLink != 'null') {
  //     socialLinkList.add(GestureDetector(
  //       onTap: () {
  //         launchURL('http:$linkedInLink');
  //       },
  //       child: Container(
  //           width: width * 1 / 7,
  //           color: defaultDark,
  //           child: Icon(
  //             Imported.linkedin_icon,
  //             color: defaultLight,
  //             size: 34,
  //             semanticLabel: "Linkedin",
  //           )),
  //     ));
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    var width = this.width;
    String webLink = userModel.websiteLink.toString();
    String instaLink = userModel.instagramLink.toString();
    String githubLink = userModel.githubLink.toString();
    String facebookLink = userModel.facebookLink.toString();
    String address = userModel.mailingStreet.toString();
    String linkedInLink = userModel.linkedInlink.toString();
    // return Semantics(
    //   child: Stack(
    //     children: [
    //       Positioned(
    //           bottom: 0,
    //           child: Container(
    //             height: 60,
    //             width: MediaQuery.of(context).size.width,
    //             color: defaultDark,
    //             child: Column(
    //               children: [
    //                 Expanded(
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    //                     children: [
    //                       Container(
    //                         height: 60,
    //                         color: Colors.transparent,
    //                         width: MediaQuery.of(context).size.width * 5 / 7,
    //                         child: socialLinkList.length <= 5
    //                             ? Row(
    //                                 mainAxisAlignment:
    //                                     MainAxisAlignment.spaceEvenly,
    //                                 children: socialLinkList,
    //                               )
    //                             : ListView(
    //                                 controller: listViewController,
    //                                 scrollDirection: Axis.horizontal,
    //                                 children: List.generate(
    //                                     socialLinkList.length, (index) {
    //                                   return socialLinkList[index];
    //                                 })),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           )),
    //     ],
    //   ),
    // );

    return Container(
      height: 50.0,
      width: width,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: width,
          ),
          child: BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
              builder: (context, pendoState) {
                return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (userModel.phone != null)
                      IconButton(
                          color: defaultDark,
                          icon: Icon(
                            Icons.call,
                            color: defaultLight,
                            size: 34,
                            semanticLabel: "Phone Number",
                          ),
                          onPressed: () {
                            ProfilePendoRepo.trackOpenSocialPopupThirdPerson(pendoState: pendoState, socialType: 'Phone No', studentId: userModel.id);
                            launchURL('tel:${userModel.phone}');
                          }),
                    if (userModel.email != null)
                      IconButton(
                          color: defaultDark,
                          icon: Icon(
                            Imported.mail_black_18dp_1,
                            color: defaultLight,
                            size: 34,
                            semanticLabel: "Email",
                          ),
                          onPressed: () {
                            ProfilePendoRepo.trackOpenSocialPopupThirdPerson(pendoState: pendoState, socialType: 'Email', studentId: userModel.id);
                            launchURL('mailto:${userModel.email}');
                          }),
                    if (userModel.websiteLink != null)
                      IconButton(
                          color: defaultDark,
                          icon: Icon(
                            Imported.language_black_18dp_1,
                            color: defaultLight,
                            size: 34,
                            semanticLabel: "Website link",
                          ),
                          onPressed: () {
                            ProfilePendoRepo.trackOpenSocialPopupThirdPerson(pendoState: pendoState, socialType: 'Website', studentId: userModel.id);
                            launchURL('$webLink');
                          }),
                    if (userModel.linkedInlink != null)
                      IconButton(
                          color: defaultDark,
                          icon: Icon(
                            Imported.linkedin_icon,
                            color: defaultLight,
                            size: 34,
                            semanticLabel: "Instagram",
                          ),
                          onPressed: () {
                            ProfilePendoRepo.trackOpenSocialPopupThirdPerson(pendoState: pendoState, socialType: 'LinkedIn', studentId: userModel.id);
                            launchURL('$linkedInLink');
                          }),
                    if (userModel.githubLink != null)
                      IconButton(
                          color: defaultDark,
                          icon: Icon(
                            Imported.github_squared,
                            color: defaultLight,
                            size: 34,
                            semanticLabel: "Github link",
                          ),
                          onPressed: () {
                            ProfilePendoRepo.trackOpenSocialPopupThirdPerson(pendoState: pendoState, socialType: 'Github', studentId: userModel.id);
                            launchURL('$githubLink');
                          }),
                    if (userModel.instagramLink != null)
                      IconButton(
                          color: defaultDark,
                          icon: Icon(
                            Imported.instagram,
                            color: defaultLight,
                            size: 34,
                            semanticLabel: "Instagram",
                          ),
                          onPressed: () {
                            ProfilePendoRepo.trackOpenSocialPopupThirdPerson(pendoState: pendoState, socialType: 'Instagram', studentId: userModel.id);
                            launchURL('$instaLink');
                          }),
                    if (userModel.facebookLink != null)
                      IconButton(
                          color: defaultDark,
                          icon: Icon(
                            Imported.facebook_squared,
                            color: defaultLight,
                            size: 34,
                            semanticLabel: "Facebook",
                          ),
                          onPressed: () {
                            ProfilePendoRepo.trackOpenSocialPopupThirdPerson(pendoState: pendoState, socialType: 'Facebook', studentId: userModel.id);
                            launchURL('$facebookLink');
                          }),
                  ],
                );
              }
          ),
        ),
      ),
    );
  }
}
