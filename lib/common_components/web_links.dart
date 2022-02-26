import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_events.dart';
import 'package:palette/modules/profile_module/bloc/profile_bloc/profile_states.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:palette/utils/validation_regex.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_chasing_dots_loader.dart';
import 'dark_text_field.dart';

class WebLinks extends StatefulWidget {
  final String title;
  final String link;
  final Function callBack;
  final Function upDateData;
  final String sfid;
  final String sfuuid;
  final String role;

  WebLinks(
      {required this.title,
      required this.link,
      required this.callBack,
      required this.upDateData,
      required this.sfid,
      required this.sfuuid,
      required this.role});
  @override
  _WebLinksState createState() => _WebLinksState();
}

class _WebLinksState extends State<WebLinks>
    with SingleTickerProviderStateMixin {
  var showOptions = false;
  var enableEditing = false;
  bool isDisabled = false;

  TextEditingController linkController = new TextEditingController();
  TextEditingController titleController = new TextEditingController();

  FocusNode nodeForLink = FocusNode();
  FocusNode nodeForTitle = FocusNode();

  bool isDeleting = false;

  editingWidget(width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
            width: 3.8 * width / 7,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 10,
                        ),
                        Icon(
                          Imported.language_black_18dp_1,
                          size: 30,
                          color: defaultDark,
                          semanticLabel: "Website",
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Container(
                            height: 32,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  top: 0, bottom: 4, left: 0, right: 0),
                              child: Container(
                                decoration: BoxDecoration(
                                    color: darkBackgroundColor,
                                    borderRadius: BorderRadius.circular(4)),
                                child: Center(
                                    child: Semantics(
                                  child: Text(
                                    'Website',
                                    style: darkTextFieldStyle.copyWith(
                                        fontWeight: FontWeight.w700),
                                  ),
                                )),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 4, left: 0, right: 0),
                        child: DarkTextField(
                          isTitle: true,
                          skillinterest: false,
                          hasPadding: false,
                          inputController: titleController,
                          inputFocus: nodeForTitle,
                          hintText: "Website Title",
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10),
                    child: Container(
                      height: 35,
                      child: Padding(
                        padding: const EdgeInsets.only(
                            top: 0, bottom: 4, left: 0, right: 0),
                        child: DarkTextField(
                          skillinterest: false,
                          hasPadding: false,
                          inputController: linkController,
                          inputFocus: nodeForLink,
                          hintText: "Website Link",
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
        optionsForEditing(width)
      ],
    );
  }

  websiteHead({width}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Icon(
            Imported.language_black_18dp_1,
            color: defaultDark,
            semanticLabel: "Website",
          ),
          SizedBox(
            width: 10,
          ),
          Semantics(
            child: Text(
              "WEBSITE",
              style: roboto700.copyWith(color: defaultDark, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  websiteUrl({width, height}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                child: Text(
                  "Website Title",
                  style: roboto700.copyWith(
                    fontWeight: FontWeight.w700,
                    color: defaultDark,
                    fontSize: 14,
                  ),
                ),
              ),
              SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Semantics(
                  child: Text(
                    widget.title,
                    style: roboto700.copyWith(
                        fontWeight: FontWeight.w500,
                        color: defaultDark.withOpacity(0.6),
                        fontSize: 14),
                  ),
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Semantics(
                child: Text(
                  "Website Link",
                  style: roboto700.copyWith(
                      fontWeight: FontWeight.w700,
                      color: defaultDark,
                      fontSize: 14),
                ),
              ),
              SizedBox(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Semantics(
                  child: Text(
                    widget.link,
                    style: roboto700.copyWith(
                        fontWeight: FontWeight.w500,
                        color: defaultDark.withOpacity(0.6),
                        fontSize: 14),
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Future<void> _launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'my_header_key': 'my_header_value'},
      );
    } else {
      showTopSnackBar(
        context,
        CustomSnackBar.error(
          message: "The link provided is not valid",
          backgroundColor: Colors.grey,
        ),
      );
    }
  }

  options(width) {
    return Container(
      width: .8 * width / 7,
      child: showOptions
          ? BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
              builder: (context, pendoState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          print('called');
                          showOptions = !showOptions;
                          print(showOptions);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_up,
                          size: 36,
                          color: defaultDark,
                          semanticLabel: "Collapse options",
                        ),
                      )),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      ProfilePendoRepo.trackCopySocialLink(
                          pendoState: pendoState,
                          socialType: 'Website',
                          socialLink: widget.link);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text('Copied to clipboard'),
                      ));
                      Clipboard.setData(ClipboardData(text: widget.link));
                    },
                    child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            color: defaultDark,
                            borderRadius: BorderRadius.circular(500)),
                        child: Center(
                            child: Icon(
                          Icons.copy,
                          size: 24,
                          color: defaultLight,
                          semanticLabel: "Copy",
                        ))),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    onTap: () {
                      ProfilePendoRepo.trackOpenSocialLink(
                          pendoState: pendoState,
                          socialType: 'Website',
                          socialLink: widget.link);
                      setState(() {
                        _launchInBrowser(widget.link);
                      });
                    },
                    child: SvgPicture.asset(
                      'images/open_link.svg',
                      height: 36,
                      semanticsLabel: "Navigate to link",
                    ),
                  ),
                  SizedBox(height: 8),
                  GestureDetector(
                    //TODO: add a loader to this delete button
                    onTap: isDeleting
                        ? () {}
                        : () {
                            ProfilePendoRepo.trackDeleteSocialLink(
                                pendoState: pendoState, socialType: 'Website');
                            BlocProvider.of<ProfileBloc>(context).add(
                                LinkDataEvent(
                                    webTitle: "", value: "", title: "Website"));
                            setState(() => isDeleting = true);
                            widget.upDateData();
                          },
                    child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            color: defaultDark,
                            borderRadius: BorderRadius.circular(500)),
                        child: Center(
                            child: Icon(
                          Icons.delete,
                          size: 24,
                          color: defaultLight,
                          semanticLabel: "Delete",
                        ))),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      ProfilePendoRepo.trackOpenEditSocialLink(
                          pendoState: pendoState, socialType: 'Website');
                      enableEditing = true;
                      setState(() {});
                    },
                    child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            color: defaultDark,
                            borderRadius: BorderRadius.circular(500)),
                        child: Icon(
                          Icons.edit,
                          size: 24,
                          color: defaultLight,
                          semanticLabel: "Edit",
                        )),
                  )
                ],
              );
            })
          : Container(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          print('called');
                          showOptions = !showOptions;
                          print(showOptions);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: defaultDark,
                          semanticLabel: "Expand options",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
    );
  }

  optionsForEditing(width) {
    return Container(
      width: 0.8 * width / 7,
      child: showOptions
          ? BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
              builder: (context, pendoState) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  GestureDetector(
                    onTap: () {
                      enableEditing = false;
                      setState(() {});
                    },
                    child: Icon(
                      Icons.close,
                      size: 36,
                      color: defaultDark,
                      semanticLabel: "Close",
                    ),
                  ),
                  SizedBox(height: 12),
                  GestureDetector(
                    onTap: () {
                      ProfilePendoRepo.trackDeleteSocialLink(
                          pendoState: pendoState, socialType: 'Website');

                      BlocProvider.of<ProfileBloc>(context).add(LinkDataEvent(
                          webTitle: "", value: "", title: "Website"));
                    },
                    child: Container(
                        height: 36,
                        width: 36,
                        decoration: BoxDecoration(
                            color: defaultDark,
                            borderRadius: BorderRadius.circular(500)),
                        child: Center(
                            child: Icon(
                          Icons.delete,
                          size: 26,
                          color: defaultLight,
                          semanticLabel: "Delete",
                        ))),
                  ),
                  SizedBox(
                    height: 12,
                  ),
                  GestureDetector(
                    onTap: () {
                      var link = linkController.text;
                      if (titleController.text.isEmpty) {
                        Helper.showCustomSnackBar(
                            'Please enter a title', context);
                        return;
                      } else if (linkController.text.isEmpty) {
                        Helper.showCustomSnackBar(
                            'Please enter a link', context);
                        return;
                      } else if (link.contains(checkHttp) ||
                          link.contains(checkHttps))
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
                      } else {
                        ProfilePendoRepo.trackUploadEditedLink(
                            pendoState: pendoState,
                            socialType: 'Website',
                            socialLink: linkController.text);
                        BlocProvider.of<ProfileBloc>(context).add(LinkDataEvent(
                            webTitle: titleController.text,
                            value: link,
                            title: "Website"));

                        // enableEditing = false;
                        setState(() {
                          isDisabled = true;
                        });
                      }
                    },
                    child: isDisabled
                        ? _getLoadingIndicatorsubmit()
                        : Icon(
                            Imported.done_all_black_18dp__1__1,
                            size: 36,
                            color: defaultDark,
                            semanticLabel: "Submit",
                          ),
                  ),
                  SizedBox(
                    height: 12,
                  )
                ],
              );
            })
          : Container(
              alignment: Alignment.topCenter,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  GestureDetector(
                      onTap: () {
                        setState(() {
                          print('called');
                          showOptions = !showOptions;
                          print(showOptions);
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Icon(
                          Icons.keyboard_arrow_down,
                          size: 20,
                          color: defaultDark,
                          semanticLabel: "Expand options",
                        ),
                      )),
                  SizedBox(
                    height: 20,
                  )
                ],
              ),
            ),
    );
  }

  Widget _getLoadingIndicatorsubmit() {
    return Padding(
      padding: const EdgeInsets.only(left: 4, top: 7),
      child: Container(
          height: 18,
          width: 30,
          child: CustomChasingDotsLoader(
            color: defaultDark,
          )),
    );
  }

  getBody(height, width) {
    return enableEditing
        ? editingWidget(width)
        : Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 3.5 * width / 7,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 10,
                      ),
                      websiteHead(width: width),
                      SizedBox(
                        height: 8,
                      ),
                      websiteUrl(width: width, height: height),
                    ],
                  ),
                ),
                options(width)
              ],
            ),
          );
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;

    return BlocListener(
      listener: (_, state) {
        if (state is LinkDataSuccessState) {
          BlocProvider.of<RefreshProfileBloc>(context)
              .add(RefreshUserProfileDetails());
        }
      },
      bloc: context.read<ProfileBloc>(),
      child: Column(
        children: [
          Expanded(child: GestureDetector(
            onTap: () {
              setState(() {
                print('ca;;ed');
                widget.callBack(false);
              });
            },
          )),
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                    onTap: () {
                      setState(() {
                        widget.callBack(false);
                      });
                    },
                    child: SizedBox(
                      width: width * 1.5 / 7,
                    )),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 0),
                child: Container(
                  width: 5 * width / 7,
                  decoration: BoxDecoration(
                      color: defaultLight,
                      borderRadius: BorderRadius.circular(12)),
                  child: getBody(height, width),
                ),
              ),
              GestureDetector(
                  onTap: () {
                    setState(() {
                      widget.callBack(false);
                    });
                  },
                  child: SizedBox(
                    width: width * 1.3 / 7,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
