import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
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

import 'dark_text_field.dart';

class ReusableSocialLink extends StatefulWidget {
  final String link;
  final String title;
  final Function callBack;
  final Icon icon;
  final Function upDateData;
  final String sfid;
  final String role;
  final String sfuuid;
  ReusableSocialLink(
      {required this.upDateData,
      required this.link,
      required this.title,
      required this.callBack,
      required this.icon,
      required this.sfid,
      required this.role,
      required this.sfuuid});
  @override
  _ReusableSocialLinkState createState() => _ReusableSocialLinkState();
}

class _ReusableSocialLinkState extends State<ReusableSocialLink>
    with SingleTickerProviderStateMixin {
  var showOptions = false;
  var enableEditing = false;
  bool isDisabled = false;
  TextEditingController linkController = new TextEditingController();
  FocusNode nodeForLink = FocusNode();

  void launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
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

  Future<void> _launchInBrowser(String url) async {
    String validUrl;
    if (url.startsWith('http') || url.startsWith('https')) {
      validUrl = url;
      launchURL(validUrl);
      return;
    } else if (!(url.startsWith('https')) || !(url.startsWith('http'))) {
      validUrl = 'http://' + url;
      launchURL(validUrl);
    }
  }

  optionsForEditing(width) {
    return Container(
      width: 0.4 * width / 7,
      child: showOptions
          ? Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 20,
                ),
                GestureDetector(
                  onTap: () {
                    enableEditing = false;
                    setState(() {});
                  },
                  child: Icon(
                    Icons.close,
                    size: 30,
                    color: defaultDark,
                    semanticLabel: "Close",
                  ),
                ),
                SizedBox(height: 12),
                BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                    builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
                      if (linkController.text.isEmpty) {
                        Helper.showCustomSnackBar(
                            'Please enter a link', context);
                      }
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
                      } else {
                        ProfilePendoRepo.trackUploadEditedLink(
                            pendoState: pendoState,
                            socialType: widget.title,
                            socialLink: linkController.text);
                        BlocProvider.of<ProfileBloc>(context).add(LinkDataEvent(
                            webTitle: "", value: link, title: widget.title));

                        widget.upDateData();
                        setState(() {
                          isDisabled = true;
                        });
                      }
                    },
                    child: isDisabled
                        ? _getLoadingIndicatorsubmit()
                        : Icon(
                            Imported.done_all_black_18dp__1__1,
                            size: 30,
                            color: defaultDark,
                            semanticLabel: "Submit",
                          ),
                  );
                })
              ],
            )
          : Container(
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
                ],
              ),
            ),
    );
  }

  getBody(_width, _height) {
    return Container(
      child: enableEditing
          ? editingWidget(_width)
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Container(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            height: 10,
                          ),
                          linkedInHead(width: _width),
                          SizedBox(
                            height: 8,
                          ),
                          linkedInUrl(width: _width, height: _height),
                          SizedBox(
                            height: 15,
                          ),
                        ],
                      ),
                    ),
                  ),
                  getOptions(_width),
                ],
              ),
            ),
    );
  }

  getOptions(_width) {
    return Container(
      width: 0.5 * _width / 7,
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
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
                child: Icon(
                  showOptions
                      ? Icons.keyboard_arrow_up
                      : Icons.keyboard_arrow_down,
                  size: 34,
                  color: defaultDark,
                  semanticLabel: "Show options",
                )),
            showOptions
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
                            ProfilePendoRepo.trackOpenSocialLink(
                                pendoState: pendoState,
                                socialType: widget.title,
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
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            ProfilePendoRepo.trackDeleteSocialLink(
                                pendoState: pendoState,
                                socialType: widget.title);
                            BlocProvider.of<ProfileBloc>(context).add(
                                LinkDataEvent(
                                    webTitle: "",
                                    value: "",
                                    title: widget.title));
                            widget.upDateData();
                            setState(() {
                              isDisabled = true;
                            });
                          },
                          child: Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                  color: defaultDark,
                                  borderRadius: BorderRadius.circular(500)),
                              child: isDisabled
                                  ? _getLoadingIndicatordelete()
                                  : Padding(
                                      padding: const EdgeInsets.all(2.0),
                                      child: Center(
                                          child: Icon(
                                        Icons.delete,
                                        size: 24,
                                        color: defaultLight,
                                        semanticLabel: "Delete",
                                      )),
                                    )),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        GestureDetector(
                          onTap: () {
                            ProfilePendoRepo.trackOpenEditSocialLink(
                                pendoState: pendoState,
                                socialType: widget.title);
                            enableEditing = true;
                            setState(() {});
                          },
                          child: Container(
                              height: 36,
                              width: 36,
                              decoration: BoxDecoration(
                                  color: defaultDark,
                                  borderRadius: BorderRadius.circular(500)),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Icon(
                                  Icons.edit,
                                  size: 24,
                                  color: defaultLight,
                                  semanticLabel: "Edit",
                                ),
                              )),
                        ),
                        SizedBox(
                          height: 15,
                        ),
                      ],
                    );
                  })
                : Container()
          ],
        ),
      ),
    );
  }

  Widget _getLoadingIndicatordelete() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(
          left: 4,
        ),
        child: Container(
            height: 15,
            width: 33,
            child: CustomChasingDotsLoader(
              color: Colors.white,
            )),
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

  editingWidget(width) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Container(
              width: 2.45 * width / 7,
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 10,
                          ),
                          widget.icon,
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 36,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    top: 0, bottom: 4, left: 0, right: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: darkBackgroundColor,
                                      borderRadius: BorderRadius.circular(4)),
                                  child: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 8.0),
                                      child: Semantics(
                                        child: Text(
                                          widget.title,
                                          style: darkTextFieldStyle.copyWith(
                                              fontWeight: FontWeight.w700),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10, left: 10),
                      child: Container(
                        height: 35,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              top: 0, bottom: 4, left: 0, right: 0),
                          child: DarkTextField(
                            hasPadding: false,
                            inputController: linkController,
                            inputFocus: nodeForLink,
                            hintText: "${widget.title} Link",
                            skillinterest: false,
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
        optionsForEditing(width)
      ],
    );
  }

  linkedInHead({width}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          widget.icon,
          SizedBox(
            width: 10,
          ),
          Semantics(
            child: Text(
              widget.title,
              style: roboto700.copyWith(color: defaultDark, fontSize: 16),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  linkedInUrl({width, height}) {
    return Padding(
      padding: const EdgeInsets.only(left: 12.0, top: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Semantics(
            child: Text(
              widget.title,
              style: roboto700.copyWith(color: defaultDark, fontSize: 10),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Semantics(
              child: Text(
                widget.link,
                style: roboto700.copyWith(
                  fontWeight: FontWeight.w500,
                  color: defaultDark.withOpacity(0.6),
                  fontSize: 14,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
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
                widget.callBack(popUp: false);
              });
            },
          )),
          Row(
            children: [
              SizedBox(
                width: 10,
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
                    width: width * 0.1 / 7,
                  )),
            ],
          ),
        ],
      ),
    );
  }
}
