import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/common_dashboard_body_widget.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/common_components/invite_button.dart';
import 'package:palette/common_components/invite_user_screen.dart';
import 'package:palette/common_components/notifications_bell_icon.dart';
import 'package:palette/common_components/student_view_components/custom_palette_loader.dart';
import 'package:palette/common_components/top_program_button.dart';
import 'package:palette/modules/contacts_module/bloc/contacts_bloc.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/multi_tenant_module/widgets/top_sheet.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/common_pendo_repo/dashboard_pendo_repo.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/screens/notification_list_screen.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/modules/profile_module/bloc/profile_image_bloc/profile_image_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_bloc.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_events.dart';
import 'package:palette/modules/profile_module/bloc/refresh_profile_screens_bloc/refresh_profile_states.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/parent_profile_screen.dart';
import 'package:palette/modules/profile_module/widgets/children_list_view.dart';
import 'package:palette/modules/share_drawer_module/screens/share_create_opportunity_screens/share_create_opportunity_form.dart';
import 'package:palette/modules/share_drawer_module/screens/share_create_todo/share_create_todo.dart';
import 'package:palette/modules/share_drawer_module/screens/share_send_chat/share_send_chat.dart';
import 'package:palette/modules/student_dashboard_module/widgets/unread_counter_empty_widget.dart';
import 'package:palette/modules/todo_module/screens/todo_list_screen.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ParentDashboard extends StatefulWidget {
  final ParentProfileUserModel? parent;
  final bool directLoad;

  ParentDashboard({required this.parent, this.directLoad = false});

  @override
  _ParentDashboardState createState() => _ParentDashboardState();
}

class _ParentDashboardState extends State<ParentDashboard>
    with SingleTickerProviderStateMixin {
  ParentProfileUserModel? parent;
  String? sfid;
  String? sfuuid;
  String? role;
  List<ContactsData> contacts = [];
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  int unreadNotifCounter = 0;

  TextEditingController searchController = TextEditingController();
  late AnimationController controller;
  late Animation<Offset> offset;

  List<Pupil> filteredList = [];
  bool isSort = false;
  @override
  void initState() {
    parent = widget.parent!;
    super.initState();
    _getSfidAndRole();
    unreadMessageCountMapStreamController =
        StreamController<Map<String, int>>();
    controller =
        AnimationController(vsync: this, duration: Duration(seconds: 1));

    offset = Tween<Offset>(begin: Offset(0.0, -1.0), end: Offset.zero)
        .animate(controller);
  }

  _getSfidAndRole() async {
    final prefs = await SharedPreferences.getInstance();
    sfid = prefs.getString(sfidConstant);
    sfuuid = prefs.getString(saleforceUUIDConstant);
    role = prefs.getString('role').toString();
  }


  @override
  Widget build(BuildContext context) {
    void _onRefresh() async {
      final bloc = context.read<GetContactsBloc>();
      bloc.add(
        GetContactsEvent(),
      );
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use refreshFailed()
      _refreshController.refreshCompleted();
    }

    void _onLoading() async {
      // monitor network fetch
      await Future.delayed(Duration(milliseconds: 1000));
      // if failed,use loadFailed(),if no data return,use LoadNodata()
      if (mounted) setState(() {});
      _refreshController.loadComplete();
    }

    void onSearchTextChanged(String text) async {
      setState(() {
        filteredList = [];
        if (!searchController.text.startsWith(' ')) {
          filteredList.addAll(widget.parent!.pupils.where((Pupil model) {
            return model.name.toLowerCase().contains(text.toLowerCase());
          }).toList());
          // recommendationObserver.sink.add(filteredList);
          print(filteredList[0].name);
        }
      });
    }

    final devWidth = MediaQuery.of(context).size.width;
    final devHeight = MediaQuery.of(context).size.height;
    Widget searchBar() {
      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: ExcludeSemantics(
          child: TextField(
            controller: searchController,
            cursorColor: Colors.blueGrey,
            autocorrect: false,
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xFF545454),
              ),
              border: InputBorder.none,
              hintText: 'Search...',
            ),
            onChanged: onSearchTextChanged,
          ),
        ),
      );
    }


    Widget _getLoadingIndicator() {
      return Center(
        child: Container(height: 38, width: 50, child: CustomPaletteLoader()),
      );
    }

    Widget _getErrorLabel() {
      return Center(
        child: Text(
          'Something went wrong. \nTry again later !',
          textAlign: TextAlign.center,
          style: kalamTextStyle.copyWith(color: white, fontSize: 28),
        ),
      );
    }

    Widget getBody(ParentProfileUserModel parentData) {
      return BlocBuilder<GetContactsBloc, GetContactsState>(
        builder: (context, state) {
          if(state is GetContactsLoadingState){
            return _getLoadingIndicator();
          }
          else if (state is GetContactsSuccessState)
            contacts = state.contactsResponse.contacts;
          return DashboardBody(devHeight: devHeight, widget: contacts,);});
    }

    return SafeArea(
        child: Semantics(
          label:
              "Welcome to your home page. A tap on the profile image on the top left will navigate to your profile and there is a chat button on the top right will navigate to your chat page. "
              "On the center of this page you have childrens. tap for more details",
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Stack(
              children: [
                Scaffold(
                  backgroundColor: Colors.transparent,
                  appBar: AppBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                  ),
                  body: GestureDetector(
                    onTap: () {
                      switch (controller.status) {
                        case AnimationStatus.completed:
                          controller.reverse();
                          break;
                        default:
                      }
                    },
                    child: SmartRefresher(
                      enablePullDown: true,
                      enablePullUp: false,
                      header: WaterDropHeader(
                        waterDropColor: defaultDark,
                      ),
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      onLoading: _onLoading,
                      child: Container(
                          child: widget.directLoad == false
                              ? BlocBuilder<RefreshProfileBloc,
                                  RefreshProfileState>(
                                  builder: (context, state) {
                                    if (state is RefreshProfileScreenInitialState) {
                                      print('initial');
                                      return getBody(widget.parent!);
                                    }
                                    if (state is RefreshProfileScreenLoadingState) {
                                      return _getLoadingIndicator();
                                    } else if (state
                                        is RefreshProfileScreenSuccessState) {
                                      print('success');
                                      //parent =
                                      //    state.profileUser as ParentProfileUserModel;
                                      return getBody(widget.parent!);
                                    } else if (state
                                        is RefreshProfileScreenFailedState) {
                                      return _getErrorLabel();
                                    } else {
                                      return Container();
                                    }
                                  },
                                )
                              : getBody(widget.parent!)),
                    ),
                  ),
                ),
                TopProgramButton(controller: controller),
                GestureDetector(
                  onTap: () {
                    DashboardPendoRepo.trackTapOnProfilePictureEvent(
                        buildContext: context);
                    if (parent == null) return;
                    final route = MaterialPageRoute(
                        builder: (_) => ParentProfileScreen(parent: parent!));
                    Navigator.push(context, route);
                  },
                  child: Container(
                    child: Stack(children: [
                      SvgPicture.asset(
                        'images/parent_small_splash.svg',
                        height: 130,
                        semanticsLabel: "Profile Picture.",
                      ),
                      BlocBuilder<ProfileImageBloc, ProfileImageState>(
                          builder: (context, state) {
                        final String? profileImageUrl;
                        if (state is ProfileImageSuccessState) {
                          profileImageUrl = state.url;
                        } else if (state is ProfileImageDeleteState) {
                          return Container();
                        } else {
                          profileImageUrl = widget.parent!.profilePicture;
                        }
                        return Padding(
                          padding: const EdgeInsets.only(top: 22, left: 16),
                          child: CachedNetworkImage(
                            imageUrl: profileImageUrl ?? '',
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
                                child:
                                    CustomChasingDotsLoader(color: defaultDark)),
                            errorWidget: (context, url, error) => Container(),
                          ),
                        );
                      }),
                    ]),
                  ),
                ),
                TopSheet(controller: controller,offset: offset,)
              ],
            ),
          ),
        ),
      );
  }

}

