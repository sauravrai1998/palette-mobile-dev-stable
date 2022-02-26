import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/common_components/student_view_components/textfield_for_links.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_events.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_states.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:palette/utils/helpers.dart';

class AddLinkButtonProfilePage extends StatefulWidget {
  final Function? callBack;
  final Function? upDate;
  final List<String> alreadyAddedLinks;
  final String sfid;
  final String role;
  final String sfuuid;

  AddLinkButtonProfilePage(
      {required this.callBack,
      required this.upDate,
      required this.alreadyAddedLinks,
      required this.sfid,
      required this.role,
      required this.sfuuid});
  @override
  _AddLinkButtonProfilePageState createState() =>
      _AddLinkButtonProfilePageState();
}

class _AddLinkButtonProfilePageState extends State<AddLinkButtonProfilePage> {
  String? indexSelected;
  List<String> data = [
    linkedInTitle,
    websiteTitle,
    instagramTitle,
    gitHubTitle,
    facebookTitle
  ];
  TextEditingController linkController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();

  FocusNode nodeForLink = FocusNode();
  FocusNode nodeForTitle = FocusNode();
  var isKeyboard = false;
  var showLinkPopUp = false;
  var isLoading = false;
  var dropdownKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    data =
        data.where((item) => !widget.alreadyAddedLinks.contains(item)).toList();
  }

  @override
  Widget build(BuildContext context) {
    var _height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    bool isvaildLink = false;
    return BlocListener(
      listener: (_, state) {
        if (state is LinkDataSuccessState) {
          BlocProvider.of<RefreshProfileBloc>(context)
              .add(RefreshUserProfileDetails());
        }
      },
      bloc: context.read<ProfileBloc>(),
      child: TextScaleFactorClamper(
        child: Positioned(
          child: Column(
            children: [
              Expanded(child: GestureDetector(
                onTap: () {
                  setState(() {
                    FocusManager.instance.primaryFocus?.unfocus();
                    widget.callBack!(showLinkPopUp);
                  });
                },
              )),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Container(
                  width: 4.5 * width / 7,
                  decoration: BoxDecoration(
                      color: defaultLight,
                      borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: StatefulBuilder(
                      builder: (context, setState) {
                        return Column(
                          children: [
                            Semantics(
                              label:
                                  "Use the dropdown to select the type of link, paste it in the text field below and press the add button to submit.",
                              child: data.isEmpty
                                  ? Center(
                                      child: Text(
                                      'All link types have been used.\nPlease edit or delete existing ones.',
                                      style: robotoTextStyle,
                                    ))
                                  : Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        SizedBox(
                                          height: 10,
                                        ),
                                        _iconWithDropDown(width, _height),
                                        SizedBox(
                                          height: 10,
                                        ),
                                        indexSelected == "Website"
                                            ? Container(
                                                height: 35,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0,
                                                          bottom: 4,
                                                          left: 0,
                                                          right: 0),
                                                  child: DarkTextFieldForLinks(
                                                    isTitle: true,
                                                    hasPadding: false,
                                                    inputController:
                                                        titleController,
                                                    inputFocus: nodeForTitle,
                                                    hintText: "Website Title",
                                                  ),
                                                ),
                                              )
                                            : Container(),
                                        indexSelected == "Website"
                                            ? SizedBox(
                                                height: 10,
                                              )
                                            : Container(),
                                        Container(
                                          height: 35,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                top: 0,
                                                bottom: 4,
                                                left: 0,
                                                right: 0),
                                            child: BlocBuilder<
                                                    PendoMetaDataBloc,
                                                    PendoMetaDataState>(
                                                builder: (context, pendoState) {
                                              return DarkTextFieldForLinks(
                                                onFieldSubmitted: () {
                                                  // Navigator.pop(dropdownKey
                                                  //     .currentContext!);
                                                  nodeForLink.unfocus();
                                                  _addLinkOnTap(pendoState);
                                                },
                                                // customOnChanged: () {
                                                //   setState(() => isvaildLink = false);
                                                // },
                                                isTitle: false,
                                                hasPadding: false,
                                                inputController: linkController,
                                                inputFocus: nodeForLink,
                                                hintText: "Paste Link Here",
                                              );
                                            }),
                                          ),
                                        ),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        BlocBuilder<PendoMetaDataBloc,
                                                PendoMetaDataState>(
                                            builder: (context, pendoState) {
                                          return BlocBuilder<ProfileBloc,
                                              ProfileState>(
                                            builder: (context, state) {
                                              return InkWell(
                                                onTap: () async {
                                                  _addLinkOnTap(pendoState);
                                                },
                                                child: Row(
                                                  children: [
                                                    Spacer(),
                                                    (state is LinkDataLoadingState)
                                                        ? CustomChasingDotsLoader(
                                                            color: defaultDark,
                                                          )
                                                        : SizedBox(
                                                            width: 36,
                                                            height: 36,
                                                            child: Container(
                                                                decoration: BoxDecoration(
                                                                    color:
                                                                        defaultDark,
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            100)),
                                                                child: Center(
                                                                    child: Icon(
                                                                  Icons.add,
                                                                  color: Colors
                                                                      .white,
                                                                  size: 26,
                                                                  semanticLabel:
                                                                      "Add link",
                                                                ))),
                                                          ),
                                                  ],
                                                ),
                                              );
                                            },
                                          );
                                        })
                                      ],
                                    ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      showLinkPopUp = !showLinkPopUp;
                      widget.callBack!(showLinkPopUp);
                    });
                  },
                  child: SizedBox(
                    width: width * 1.3 / 7,
                  )),
            ],
          ),
        ),
      ),
    );
  }

  _iconWithDropDown(width, _height) {
    return Row(
      children: [
        indexSelected == linkedInTitle
            ? Container(
                height: 30,
                child: Padding(
                  padding: const EdgeInsets.only(
                      top: 0.0, bottom: 0, left: 8, right: 8),
                  child: Icon(
                    Imported.linkedin_icon,
                    color: defaultDark,
                    size: 32,
                    semanticLabel: "Linkedin",
                  ),
                ))
            : indexSelected == facebookTitle
                ? Container(
                    height: 30,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          top: 0.0, bottom: 0, left: 8, right: 8),
                      child: Icon(
                        Imported.facebook_squared,
                        color: defaultDark,
                        size: 32,
                        semanticLabel: "Facebook",
                      ),
                    ))
                : indexSelected == instagramTitle
                    ? Container(
                        height: 30,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0.0, bottom: 0, left: 8, right: 8),
                          child: Icon(
                            Imported.instagram,
                            size: 32,
                            color: defaultDark,
                            semanticLabel: "Instagram",
                          ),
                        ))
                    : indexSelected == whatsappTitle
                        ? Container(
                            height: 30,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0.0, bottom: 0, left: 8, right: 8),
                              child: Icon(
                                Imported.whatsapp,
                                color: defaultDark,
                                size: 32,
                                semanticLabel: "Whatsapp",
                              ),
                            ))
                        : indexSelected == gitHubTitle
                            ? Container(
                                height: 30,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      top: 0.0, bottom: 0, left: 8, right: 8),
                                  child: Icon(
                                    Imported.github_squared,
                                    color: defaultDark,
                                    size: 32,
                                    semanticLabel: "Github",
                                  ),
                                ))
                            : indexSelected == websiteTitle
                                ? Container(
                                    height: 30,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          top: 4.0,
                                          bottom: 4,
                                          left: 8,
                                          right: 8),
                                      child: Icon(
                                        Imported.language_black_18dp_1,
                                        color: defaultDark,
                                        semanticLabel: "Website",
                                      ),
                                    ))
                                : Container(),
        indexSelected != null
            ? SizedBox(
                width: 5,
              )
            : Container(),
        Container(
          width: 3 * width / 7,
          height: 30,
          child: Container(
            decoration: BoxDecoration(
              color: darkBackgroundColor,
              borderRadius: BorderRadius.all(Radius.circular(6.0)),
            ),
            child: Padding(
                padding: const EdgeInsets.only(left: 17.0),
                child: DropdownButton<String>(
                  key: dropdownKey,
                  underline: Container(),
                  isExpanded: true,
                  icon: Icon(
                    Icons.arrow_drop_down_outlined,
                    color: Colors.white,
                    semanticLabel: "Dropdown",
                  ),
                  dropdownColor: defaultLight,
                  elevation: 30,
                  hint: Align(
                    alignment: Alignment.centerLeft,
                    child: Semantics(
                      child: Text(
                        "Select link type",
                        style: robotoTextStyle.copyWith(
                            color: defaultLight,
                            fontSize: 14,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return data.map<Widget>((String item) {
                      return Align(
                        alignment: Alignment.centerLeft,
                        child: Semantics(
                          child: Text(
                            item,
                            style: darkTextFieldStyle.copyWith(
                                fontWeight: FontWeight.w700,
                                color: defaultLight),
                          ),
                        ),
                      );
                    }).toList();
                  },
                  items: data.map((String value) {
                    nodeForLink = FocusNode();
                    return DropdownMenuItem<String>(
                        value: value,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Semantics(
                              child: Text(
                                value,
                                style: darkTextFieldStyle.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: defaultDark),
                              ),
                            ),
                          ],
                        ));
                  }).toList(),
                  onChanged: (newVal) async {
                    setState(() {
                      indexSelected = newVal;
                    });
                  },
                  value:
                      indexSelected == null ? null : indexSelected.toString(),
                )),
          ),
        ),
      ],
    );
  }

  _addLinkOnTap(PendoMetaDataState pendoState) async {
    if (nodeForLink.hasFocus) {
      nodeForTitle.unfocus();
    } else if (nodeForTitle.hasFocus) {
      nodeForLink.unfocus();
    }
    final titleNeeded =
        indexSelected == websiteTitle && titleController.text.isEmpty;
    //r'^((?:.|\n)*?)((http:\/\/www\.|https:\/\/www\.|http:\/\/|https:\/\/)?[a-z0-9]+([\-\.]{1}[a-z0-9]+)([-A-Z0-9.]+)(/[-A-Z0-9+&@#/%=~_|!:,.;]*)?(\?[A-Z0-9+&@#/%=~_|!:‌​,.;]*)?)'
    var link = linkController.text;
    if (link.contains(checkHttp) || link.contains(checkHttps))
      link = link;
    else
      link = "https://${linkController.text}";
    var reg = RegExp(
                                            r"^((((H|h)(T|t)|(F|f))(T|t)(P|p)((S|s)?))\://)?(www.|[a-zA-Z0-9].)[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,6}(\:[0-9]{1,5})*(/($|[a-zA-Z0-9\.\,\;\?\'\\\+&amp;%\$#\=~_\-@]+))*$");
                                        final match = reg.hasMatch(link);
    print(link);
    if (match == false) {
      Helper.showCustomSnackBar(
        'Please enter valid link',
        context,
      );
      return;
    }
    if (titleNeeded) {
      Helper.showCustomSnackBar(
        'Please enter a title',
        context,
      );
      return;
    }
    if (linkController.text.isEmpty) {
      Helper.showCustomSnackBar(
        'Please enter a link',
        context,
      );
      return;
    }
    if (indexSelected != null) {
      nodeForLink.unfocus();
      nodeForTitle.unfocus();
      ProfilePendoRepo.trackUploadSocialLink(
          pendoState: pendoState,
          socialType: indexSelected.toString(),
          socialLink: link);
      BlocProvider.of<ProfileBloc>(context).add(
        LinkDataEvent(
          webTitle: titleController.text.toString(),
          value: link,
          title: indexSelected.toString(),
        ),
      );

      widget.upDate!();
    }
  }

  Widget _addLinkButton() {
    return SizedBox(
      width: 36,
      height: 36,
      child: Container(
        decoration: BoxDecoration(
          color: defaultDark,
          borderRadius: BorderRadius.circular(
            100,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.add,
            color: Colors.white,
            size: 26,
          ),
        ),
      ),
    );
  }
}
