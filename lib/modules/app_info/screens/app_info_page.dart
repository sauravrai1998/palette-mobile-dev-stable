import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:new_version/new_version.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/modules/app_info/Widgets/resource_center_dialog.dart';
import 'package:palette/modules/app_info/bloc/resource_center_bloc.dart';
import 'package:palette/modules/app_info/screens/leave_feedback_page.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:palette/modules/todo_module/widget/file_resource_card_button.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'bug_report_page.dart';
import 'contact_us_page.dart';

class AppInfoPage extends StatefulWidget {
  final String name;
  final String email;
  AppInfoPage({Key? key, required this.name, required this.email})
      : super(key: key);

  @override
  State<AppInfoPage> createState() => _AppInfoPageState();
}

class _AppInfoPageState extends State<AppInfoPage> {
  var canUpdate = false;
  var localVersion = '';
  var appStoreLink = '';
  var playStoreLink = '';
  var sfuuid = '';
  var sfid = '';
  var role = '';

  @override
  void initState() {
    super.initState();
    _checkForVersion();
    _setSfidAndRole();
  }

  _setSfidAndRole() async {
    var prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant) ?? '';
    sfuuid = prefs.getString(saleforceUUIDConstant) ?? '';
    role = prefs.getString('role') ?? '';
  }

  _checkForVersion() async {
    final status = await NewVersion().getVersionStatus();
    if (status == null) return;
    setState(() {
      canUpdate = status.canUpdate;
      localVersion = 'Version ${status.localVersion}';
      appStoreLink = status.appStoreLink;
    });

    print('status.localVersion: ${status.localVersion}');
    print('status.storeVersion: ${status.storeVersion}');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Colors.white,
          body: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    icon: Icon(
                      Icons.close,
                      color: Colors.black,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            EdgeInsets.only(top: 40, right: 40, bottom: 40),
                        child: Center(
                          child: Container(
                            width: 200,
                            child: Column(
                              children: [
                                Image.asset('images/palettelogonobg.png',
                                    width: 200),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        if (canUpdate) {
                                          if (Platform.isAndroid) {
                                            launchURL(
                                                'https://play.google.com/store/apps/details?id=com.paletteedu.palette');
                                          } else {
                                            launchURL(appStoreLink);
                                          }
                                        }
                                      },
                                      child: Row(
                                        children: [
                                          Text(
                                            localVersion,
                                            style: montserratNormal.copyWith(
                                                color: pureblack),
                                          ),
                                          SizedBox(width: 4),
                                          canUpdate
                                              ? Column(
                                                  children: [
                                                    Hero(
                                                      tag: 'settings',
                                                      child: SvgPicture.asset(
                                                          'images/update_app.svg'),
                                                    ),
                                                    SizedBox(height: 15),
                                                  ],
                                                )
                                              : Container(height: 0, width: 0),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'SUPPORT',
                          style: robotoTextStyle.copyWith(
                              color: pureblack,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(
                        children: [
                          _getListTile(
                              imageName: 'contact_us_icon',
                              text: 'Contact Us',
                              isSupport: true,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ContactUsPage(name: widget.name)));
                              }),
                          _getListTile(
                              imageName: 'bug',
                              text: 'Report a bug',
                              isSupport: true,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            BugReportPage(name: widget.name)));
                              }),
                          _getListTile(
                              imageName: 'feedback',
                              text: 'Leave a feedback',
                              isSupport: true,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => LeaveFeedBackPage(
                                            name: widget.name,
                                            email: widget.email)));
                              }),
                          _menuTile(
                              imageName: 'resource_center',
                              text: 'Resource Centre',
                              isSupport: true,
                              onTap: () {
                                BlocProvider.of<ResourceCenterBloc>(context)
                                    .add(GetResourceCenterGuidesEvent());
                                resourceCenterDialog(
                                  context: context,
                                  sfuuid: sfuuid,
                                  role: role,
                                  sfid: sfid,
                                );
                              }),
                        ],
                      ),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(left: 25),
                        child: Text(
                          'MORE',
                          style: robotoTextStyle.copyWith(
                              color: pureblack,
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      SizedBox(height: 10),
                      Column(children: [
                        _getListTile(
                            imageName: 'privacy_policy',
                            text: 'Privacy Policy',
                            isSupport: false,
                            onTap: () {
                              launchURL(
                                  'https://paletteedu.net/privacy-policy');
                            }),
                        // _getListTile(
                        //     'terms_of_service', 'Terms of Service', false, () {}),
                      ]),
                    ],
                  ),
                  LogoutButtonAppInfoPage(),
                ],
              ),
            ],
          )),
    );
  }

  Widget _getListTile({
    required String imageName,
    required String text,
    required bool isSupport,
    required Function? onTap(),
  }) {
    return SizedBox(
      width: double.infinity,
      child: Card(
        elevation: 0.4,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: ListTile(
            leading: SvgPicture.asset(
              'images/$imageName.svg',
              width: 18,
              height: 18,
              color: isSupport ? purpleBlue : Colors.red,
            ),
            title: Text(
              text,
              style: robotoTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.bold, color: pureblack),
            ),
            visualDensity: VisualDensity.compact,
            onTap: onTap,
          ),
        ),
      ),
    );
  }
}

Widget _menuTile({
  required String imageName,
  required String text,
  required bool isSupport,
  required Function? onTap(),
}) {
  return BlocBuilder<ResourceCenterBloc, ResourceCenterState>(
      builder: (context, state) {
    return Card(
      child: MaterialButton(
          child: Row(children: [
            SizedBox(width: 20),
            SvgPicture.asset(
              'images/$imageName.svg',
              color: isSupport ? purpleBlue : Colors.red,
              semanticsLabel: "Logout button",
              height: 18,
              width: 18,
            ),
            SizedBox(width: 35),
            Text(
              '$text',
              style: robotoTextStyle.copyWith(
                  fontSize: 16, fontWeight: FontWeight.bold, color: pureblack),
            ),
            SizedBox(width: 100),
            state is ResourceCenterGuidesLoadingState
                ? CustomPaletteLoader()
                : SizedBox()
          ]),
          onPressed: () {
            onTap();
          }),
    );
  });
}

class LogoutButtonAppInfoPage extends StatelessWidget {
  const LogoutButtonAppInfoPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
      builder: (context, pendoState) {
        return Container(
          margin: EdgeInsets.only(bottom: 25),
          width: MediaQuery.of(context).size.width * 0.6,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.10),
                  blurRadius: 5,
                  offset: Offset(0, 1),
                ),
              ]),
          height: 50,
          child: MaterialButton(
            child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              Text(
                'LOGOUT',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  height: 1,
                  color: pinkRed,
                  fontSize: 14,
                ),
              ),
              SizedBox(width: 10),
              SvgPicture.asset(
                'images/logout.svg',
                color: pinkRed,
                width: 22,
                height: 22,
                semanticsLabel: "Logout button",
              ),
            ]),
            onPressed: () async {
              print('logout');
              ProfilePendoRepo.trackLogoutEvent(pendoState: pendoState);
              await Helper.logout(context: context);
            },
          ),
        );
      }
    );
  }
}
