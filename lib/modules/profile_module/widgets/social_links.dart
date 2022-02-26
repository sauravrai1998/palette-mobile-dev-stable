import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:palette/common_components/add_link.dart';
import 'package:palette/common_components/reusable_social_link.dart';
import 'package:palette/common_components/address_popup.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/get_contact.dart';
import 'package:palette/common_components/phone_number.dart';
import 'package:palette/common_components/swipe_up.dart';
import 'package:palette/common_components/web_links.dart';
import 'package:palette/icons/imported_icons.dart';

// ignore: must_be_immutable
class SocialLinks extends StatefulWidget {
  var userModel;
  final double width;
  final String sfid;
  final String role;
  final String sfuuid;
  bool thirdPerson;
  SocialLinks(
      {required this.userModel,
      required this.width,
      required this.sfid,
      required this.role,
      required this.sfuuid,
      this.thirdPerson = false});

  @override
  _SocialLinksState createState() =>
      _SocialLinksState(userModel: this.userModel);
}

class _SocialLinksState extends State<SocialLinks> {
  var userModel;
  _SocialLinksState({required this.userModel});

  String? webLink;
  String? instaLink;
  String? whatsappLink;
  String? githubLink;
  String? facebookLink;
  String? address;
  String? linkedInLink;
  final List<String> linksAlreadyAdded = [];

  String? indexSelected;
  TextEditingController controller = new TextEditingController();
  FocusNode node = new FocusNode();
  bool showLinkPopUp = false;
  bool websiteLinkPopUp = false;
  bool instagramPopUp = false;
  bool whatsappLinkPopUp = false;
  bool githubLinkPopUp = false;
  bool facebookLinkPopUp = false;
  bool linkedInPopUp = false;
  bool phoneNumberPopUp = false;
  bool emailPopUp = false;
  bool addressPopUp = false;

  String? linkSelected;
  List<String> dataForLink = ['LinkedIn', 'Website'];
  TextEditingController linkController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();
  FocusNode nodeForLink = FocusNode();

  callBackForReUsableLink({required bool popUp}) {
    facebookLinkPopUp = false;
    whatsappLinkPopUp = false;
    instagramPopUp = false;
    githubLinkPopUp = false;
    linkedInPopUp = false;
    websiteLinkPopUp = false;
    showLinkPopUp = false;
    addressPopUp = false;
    phoneNumberPopUp = false;
    emailPopUp = false;

    setState(() {});
  }

  callBackToAddLinkPopUp(popUp) {
    setState(() {
      showLinkPopUp = popUp;
    });
  }

  showWebsitePopUp(popUp) {
    setState(() {
      websiteLinkPopUp = popUp;
    });
  }

  scrollToIndex(index) async {
    await Future.delayed(Duration(milliseconds: 200));
    print("called");

    await listViewController.scrollToIndex(index,
        preferPosition: AutoScrollPosition.end);
  }

  AutoScrollController listViewController = new AutoScrollController();

  List<bool>? tappedList;

  int expandHeight = 20;

  changeTappedList({index}) {
    print("called");
    tappedList = [
      true,
      true,
      true,
      true,
      true,
      true,
      true,
    ];

    tappedList![index] = false;
    print(tappedList);
    setState(() {});
  }

  List<Widget> socialLinkList = [];
  setData() {
    socialLinkList = [];

    socialLinkList.add(
      BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
            ProfilePendoRepo.trackOpenSocialPopup(
                pendoState: pendoState, socialType: 'Phone No');
            setState(() {
              phoneNumberPopUp = true;
            });
          },
          child: userModel.phone != null
              ? Container(
                  width: widget.width * 1 / 7,
                  color: defaultDark,
                  child: Icon(
                    Icons.call,
                    color: defaultLight,
                    size: 34,
                    semanticLabel: "Phone Number",
                  ))
              : Container(),
        );
      }
    ));

    socialLinkList.add(BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
            ProfilePendoRepo.trackOpenSocialPopup(
                pendoState: pendoState, socialType: 'Email');
            setState(() {
              emailPopUp = true;
            });
          },
          child: Container(
              width: widget.width * 1 / 7,
              color: defaultDark,
              child: Icon(
                Imported.mail_black_18dp_1,
                color: defaultLight,
                size: 34,
                semanticLabel: "Email",
              )),
        );
      }
    ));

    String webLink = widget.userModel.websiteLink.toString();
    String instaLink = widget.userModel.instagramLink.toString();
    String githubLink = widget.userModel.githubLink.toString();
    String facebookLink = widget.userModel.facebookLink.toString();
    String address = widget.userModel.mailingStreet.toString();
    String linkedInLink = widget.userModel.linkedInlink.toString();

    if (address.isNotEmpty && address != 'null') {
      socialLinkList.add(BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
            ProfilePendoRepo.trackOpenSocialPopup(
                pendoState: pendoState, socialType: 'Address');
              setState(() {
                addressPopUp = true;
              });
            },
            child: Container(
                width: widget.width * 1 / 7,
                color: defaultDark,
                child: Icon(
                  Icons.home,
                  color: defaultLight,
                  size: 34,
                  semanticLabel: "Address",
                )),
          );
        }
      ));
    }
    if (webLink.isNotEmpty && webLink != 'null') {
      socialLinkList.add(BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
            ProfilePendoRepo.trackOpenSocialPopup(
                pendoState: pendoState, socialType:'Website');
              setState(() {
                websiteLinkPopUp = true;
                print(websiteLinkPopUp);
              });
            },
            child: Container(
                width: widget.width * 1 / 7,
                color: defaultDark,
                child: Icon(
                  Imported.language_black_18dp_1,
                  color: defaultLight,
                  size: 34,
                  semanticLabel: "Website link",
                )),
          );
        }
      ));
      linksAlreadyAdded.add(websiteTitle);
    }
    if (instaLink.isNotEmpty && instaLink != 'null') {
      socialLinkList.add(BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
            ProfilePendoRepo.trackOpenSocialPopup(
                pendoState: pendoState, socialType:'Instagram');
              setState(() {
                instagramPopUp = true;
              });
            },
            child: Container(
                width: widget.width * 1 / 7,
                color: defaultDark,
                child: Icon(
                  Imported.instagram,
                  color: defaultLight,
                  size: 34,
                  semanticLabel: "Instagram",
                )),
          );
        }
      ));
      linksAlreadyAdded.add(instagramTitle);
    }

    if (githubLink.isNotEmpty && githubLink != 'null') {
      socialLinkList.add(BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
            ProfilePendoRepo.trackOpenSocialPopup(
                pendoState: pendoState, socialType:'Github');
              setState(() {
                githubLinkPopUp = true;
              });
            },
            child: Container(
                width: widget.width * 1 / 7,
                color: defaultDark,
                child: Icon(
                  Imported.github_squared,
                  color: defaultLight,
                  size: 34,
                  semanticLabel: "Github link",
                )),
          );
        }
      ));
      linksAlreadyAdded.add(gitHubTitle);
    }
    if (facebookLink.isNotEmpty && facebookLink != 'null') {
      socialLinkList.add(BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
            ProfilePendoRepo.trackOpenSocialPopup(
                pendoState: pendoState, socialType:'Facebook');
              setState(() {
                facebookLinkPopUp = true;
              });
            },
            child: Container(
                width: widget.width * 1 / 7,
                color: defaultDark,
                child: Icon(
                  Imported.facebook_squared,
                  color: defaultLight,
                  size: 34,
                  semanticLabel: "Facebook",
                )),
          );
        }
      ));
      linksAlreadyAdded.add(facebookTitle);
    }
    if (linkedInLink.isNotEmpty && linkedInLink != 'null') {
      socialLinkList.add(BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
            ProfilePendoRepo.trackOpenSocialPopup(
                pendoState: pendoState, socialType: 'LinkedIn');
              setState(() {
                linkedInPopUp = true;
              });
            },
            child: Container(
                width: widget.width * 1 / 7,
                color: defaultDark,
                child: Icon(
                  Imported.linkedin_icon,
                  color: defaultLight,
                  size: 34,
                  semanticLabel: "Linkedin",
                )),
          );
        }
      ));
      linksAlreadyAdded.add(linkedInTitle);
    }

    setState(() {});
  }

  callBackToUpdate() {
    setData();
  }

  @override
  void initState() {
    super.initState();
    setData();
    tappedList = [
      true,
      true,
      true,
      true,
      true,
      true,
      true,
    ];
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Semantics(
      child: Stack(
        children: [
          Positioned(
              bottom: 0,
              child: Container(
                height: 60,
                width: MediaQuery.of(context).size.width,
                color: defaultDark,
                child: Column(
                  children: [
                    Expanded(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Container(
                            height: 60,
                            color: Colors.transparent,
                            width: MediaQuery.of(context).size.width * 5 / 7,
                            child: socialLinkList.length <= 5
                                ? Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: socialLinkList,
                                  )
                                : ListView(
                                    controller: listViewController,
                                    scrollDirection: Axis.horizontal,
                                    children: List.generate(
                                        socialLinkList.length, (index) {
                                      return socialLinkList[index];
                                    })),
                          ),
                          Visibility(
                              visible: widget.thirdPerson,
                              child: SizedBox(width: MediaQuery.of(context).size.width * 1 / 8,)),
                          Visibility(
                            visible: !widget.thirdPerson,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  showLinkPopUp = !showLinkPopUp;
                                });
                              },
                              child: Container(
                                  width:
                                      MediaQuery.of(context).size.width * 1 / 7,
                                  color: defaultDark,
                                  child: Icon(
                                    Imported.add_circle_black_18dp_1,
                                    color: defaultLight,
                                    size: 36,
                                    semanticLabel: "Add link",
                                  )),
                            ),
                          ),
                          SwipeUpButton(
                            width: width, sfid: widget.sfid, role: widget.role, sfuuid: widget.sfuuid,
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              )),
          phoneNumberPopUp
              ? PhoneNumber(
                  userModel: widget.userModel,
                  upDateCallBack: callBackForReUsableLink,
                )
              : Container(),
          emailPopUp
              ? ContactNumber(
                  userModel: widget.userModel,
                  upDateCallBack: callBackForReUsableLink,
                )
              : Container(),
          addressPopUp
              ? AddressPopUp(
                  address: widget.userModel.mailingStreet +
                      ', ' +
                      widget.userModel.mailingState +
                      ", " +
                      widget.userModel.mailingCountry,
                  upDateCallBack: callBackForReUsableLink,
                )
              : Container(),
          showLinkPopUp
              ? AddLinkButtonProfilePage(
                  callBack: callBackToAddLinkPopUp,
                  upDate: callBackToUpdate,
                  alreadyAddedLinks: linksAlreadyAdded, sfid: widget.sfid, role: widget.role, sfuuid: widget.sfuuid,

                )
              : Container(),
          websiteLinkPopUp
              ? WebLinks(
                  title: widget.userModel.websiteTitle.toString(),
                  link: widget.userModel.websiteLink.toString(),
                  callBack: showWebsitePopUp,
                  upDateData: callBackToUpdate,
                  sfid: widget.sfid,
                  role: widget.role,
                  sfuuid: widget.sfuuid,
                )
              : Container(),
          instagramPopUp
              ? ReusableSocialLink(
                  icon: Icon(
                    Imported.instagram,
                    color: defaultDark,
                    size: 34,
                    semanticLabel: "Instagram",
                  ),
                  link: widget.userModel.instagramLink.toString(),
                  title: instagramTitle,
                  callBack: callBackForReUsableLink,
                  upDateData: callBackToUpdate,
                  role: widget.role,
                  sfid: widget.sfid,
                  sfuuid: widget.sfuuid,
                )
              : Container(),
          githubLinkPopUp
              ? ReusableSocialLink(
                  icon: Icon(
                    Imported.github_squared,
                    color: defaultDark,
                    size: 34,
                    semanticLabel: "Github",
                  ),
                  link: widget.userModel.githubLink.toString(),
                  title: gitHubTitle,
                  callBack: callBackForReUsableLink,
                  upDateData: callBackToUpdate,
                  role: widget.role,
                  sfid: widget.sfid,
                  sfuuid: widget.sfuuid,
                )
              : Container(),
          facebookLinkPopUp
              ? ReusableSocialLink(
                  icon: Icon(
                    Imported.facebook_squared,
                    color: defaultDark,
                    size: 34,
                    semanticLabel: "Facebook",
                  ),
                  link: widget.userModel.facebookLink.toString(),
                  title: facebookTitle,
                  upDateData: callBackToUpdate,
                  callBack: callBackForReUsableLink,
                  role: widget.role,
                  sfid: widget.sfid,
                  sfuuid: widget.sfuuid,
                )
              : Container(),
          linkedInPopUp
              ? ReusableSocialLink(
                  icon: Icon(
                    Imported.linkedin_icon,
                    color: defaultDark,
                    size: 34,
                    semanticLabel: "Linkedin",
                  ),
                  link: widget.userModel.linkedInlink.toString(),
                  title: linkedInTitle,
                  upDateData: callBackToUpdate,
                  callBack: callBackForReUsableLink,
                  role: widget.role,
                  sfid: widget.sfid,
                  sfuuid: widget.sfuuid,
                )
              : Container(),
        ],
      ),
    );
  }
}
