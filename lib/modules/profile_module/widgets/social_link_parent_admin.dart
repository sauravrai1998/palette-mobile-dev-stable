import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/get_contact.dart';
import 'package:palette/common_components/phone_number.dart';
import 'package:palette/common_components/swipe_up.dart';
import 'package:palette/icons/imported_icons.dart';

// ignore: must_be_immutable
class SocialLinkForParent extends StatefulWidget {
  var userModel;
  final double width;
  String sfuuid;
  bool thirdPerson;
  SocialLinkForParent({required this.userModel, required this.width, required this.sfuuid, this.thirdPerson = false});

  @override
  _SocialLinkForParentState createState() =>
      _SocialLinkForParentState(userModel: this.userModel);
}

class _SocialLinkForParentState extends State<SocialLinkForParent> {
  var userModel;
  _SocialLinkForParentState({required this.userModel});

  String? indexSelected;

  List<String> data = ['hey', 'how', 'are'];
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

    socialLinkList.add(
      BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
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
                            width: socialLinkList.length < 6
                                ? MediaQuery.of(context).size.width * 6 / 7
                                : MediaQuery.of(context).size.width * 5 / 7,
                            child: socialLinkList.length < 6
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
                          // Visibility(
                          //     visible: widget.thirdPerson,
                          //     child: SizedBox(width: MediaQuery.of(context).size.width * 1 / 15,)),
                          socialLinkList.length < 6
                              ? Container()
                              : Visibility(
                            visible: !widget.thirdPerson,
                                child: GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        showLinkPopUp = !showLinkPopUp;
                                      });
                                    },
                                    child: Container(
                                        width: MediaQuery.of(context).size.width *
                                            1 /
                                            7,
                                        color: defaultDark,
                                        child: Icon(
                                          Imported.add_circle_black_18dp_1,
                                          color: defaultLight,
                                          size: 36,
                                          semanticLabel: "Add links",
                                        )),
                                  ),
                              ),
                          SwipeUpButton(
                            width: width,
                            sfid: widget.userModel.id,
                            role: 'Gaurdian',
                            sfuuid: widget.sfuuid,
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
        ],
      ),
    );
  }
}
