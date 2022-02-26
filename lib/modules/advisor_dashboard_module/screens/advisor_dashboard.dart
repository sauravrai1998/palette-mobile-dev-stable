import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app_badger/flutter_app_badger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:page_view_indicators/circle_page_indicator.dart';
import 'package:palette/common_components/common_components_link.dart';
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
import 'package:palette/modules/advisor_dashboard_module/bloc/student_list_bloc/advisor_student_bloc.dart';
import 'package:palette/modules/advisor_dashboard_module/bloc/student_list_bloc/advisor_student_events.dart';
import 'package:palette/modules/advisor_dashboard_module/bloc/student_list_bloc/advisor_student_states.dart';
import 'package:palette/modules/advisor_dashboard_module/models/advisor_student_model.dart';
import 'package:palette/modules/advisor_dashboard_module/services/advisor_repository.dart';
import 'package:palette/modules/advisor_dashboard_module/widgets/circular_student_button.dart';
import 'package:palette/modules/auth_module/services/notification_repository.dart';
import 'package:palette/modules/common_pendo_repo/dashboard_pendo_repo.dart';
import 'package:palette/modules/notifications_module/bloc/notifications_bloc.dart';
import 'package:palette/modules/notifications_module/screens/notification_list_screen.dart';
import 'package:palette/modules/notifications_module/services/notifications_repo.dart';
import 'package:palette/modules/profile_module/bloc/profile_image_bloc/profile_image_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_events.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_states.dart';
import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/advisor_profile_screen.dart';
import 'package:palette/modules/student_dashboard_module/screens/student_dashboard.dart';
import 'package:palette/modules/student_dashboard_module/widgets/unread_counter_empty_widget.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/screens/todo_list_screen.dart';
import 'package:palette/modules/todo_module/services/todo_repo.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdvisorDashboard extends StatefulWidget {
  final AdvisorProfileUserModel? advisor;

  AdvisorDashboard({required this.advisor});
  @override
  _AdvisorDashboardState createState() => _AdvisorDashboardState();
}

class _AdvisorDashboardState extends State<AdvisorDashboard> with SingleTickerProviderStateMixin{
  AdvisorStudentList? advisorStudents;
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  String? sfid;
  String? sfuuid;
  String? role;
  int unreadNotifCounter =0;

  late AnimationController controller;
  late Animation<Offset> offset;

  final List<String> imgEx = [
    'https://cdn.pixabay.com/photo/2020/03/11/23/24/lamp-post-4923527_960_720.jpg',
    'https://cdn.pixabay.com/photo/2020/03/11/23/24/lamp-post-4923527_960_720.jpg',
  ];
  TextEditingController searchController = TextEditingController();

  List<AdvisorStudent> filteredList = [];
  bool isSort = false;
  List<ContactsData> contacts = [];

  @override
  void initState() {
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

  String? selectedId;

  Widget _getLoadingIndicator() {
    return Center(
      child: Container(height: 38, width: 50, child: CustomPaletteLoader()),
    );
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

    final devWidth = MediaQuery.of(context).size.width;
    final devHeight = MediaQuery.of(context).size.height;

    Widget getBody() {
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
            "Welcome to your home page. A tap on the profile image on the top left will navigate to your profile and there is a chat button on the top right will navigate to your chat page .On the center of this page you have list of students",
        child: Scaffold(
          body: SafeArea(
            child: Stack(
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
                    child: Stack(
                      children: [SmartRefresher(
                        enablePullDown: true,
                        enablePullUp: false,
                        header: WaterDropHeader(
                          waterDropColor: defaultDark,
                        ),
                        controller: _refreshController,
                        onRefresh: _onRefresh,
                        onLoading: _onLoading,
                        child: TextScaleFactorClamper(
                          child: getBody(),
                        ),
                      ),
                      ]
                    ),
                  ),
                ),
                TopProgramButton(controller: controller),
                GestureDetector(
                  onTap: () {
                    DashboardPendoRepo.trackTapOnProfilePictureEvent(
                        buildContext: context);
                    print('profile advisor user is null');
                    if (widget.advisor == null) return;
                    final route = MaterialPageRoute(
                        builder: (_) => AdvisorProfileScreen(
                              advisor: widget.advisor!,
                            ));

                    Navigator.push(context, route);
                  },
                  child: Container(
                    child: Stack(children: [
                      SvgPicture.asset(
                        'images/advisor_small_splash.svg',
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
                          profileImageUrl = widget.advisor!.profilePicture;
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
      ),
    );
  }

  Column failedContainer() {
    return Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  child: Text(
                                                'Students',
                                                style: kalamLight.copyWith(
                                                    color: defaultDark,
                                                    fontSize: 24),
                                              )),
                                              Container(
                                                  child: Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10, left: 20),
                                                child: Text(
                                                  'None',
                                                  style: kalamLight.copyWith(
                                                      color: defaultDark,
                                                      fontSize: 18),
                                                ),
                                              )),
                                            ],
                                          );
  }

  void onSearchTextChanged(String text) async {
    setState(() {
      filteredList = [];
      if (!searchController.text.startsWith(' ')) {
        filteredList.addAll(advisorStudents!.data.students.where((AdvisorStudent model) {
          return model.name!.toLowerCase().contains(text.toLowerCase());
        }).toList());
        // recommendationObserver.sink.add(filteredList);
        print(filteredList[0].name);
      }
    });

  }

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

  Widget _body() {
    return Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Column(
          children: [
            SizedBox(
              height: 100,
            ),
            Expanded(
              child: BlocProvider(
                create: (BuildContext context) {
                  //context.read<RefreshProfileBloc>().add(RefreshUserProfileDetails());
                  return AdviserStudentBloc(
                      advisorRepo: AdvisorRepository.instance)
                    ..add(AdvisorGetStudentUser());
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.7,
                  child: BlocBuilder<AdviserStudentBloc, AdvisorStudentState>(
                    builder: (context, state) {
                      if (state is AdvisorStudentUserLoadingState) {
                        return _getLoadingIndicator();
                      } else if (state is AdvisorStudentUserSuccessState) {
                        advisorStudents = state.advisorStudentsMentorsList;
                        return BlocListener(
                            bloc: context.read<ThirdPersonBloc>(),
                            listener: (context, state) async {
                              if (state is ThirdPersonSuccessState) {
                                var studentData = state.profileUser
                                    as StudentProfileUserModel;
                                Navigator.of(context).pop();
                                if (selectedId != null) {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentDashBoard(
                                        student: studentData,
                                        studentId: selectedId!,
                                      ),
                                    ),
                                  );
                                } else {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => StudentDashBoard(
                                        student: studentData,
                                        studentId: " ",
                                      ),
                                    ),
                                  );
                                }
                              } else if (state is ThirdPersonFailedState) {
                                Helper.showGenericDialog(
                                    title: 'Oops...',
                                    body: state.error,
                                    context: context,
                                    okAction: () {
                                      Navigator.pop(context);
                                    });
                              } else if (state is ThirdPersonLoadingState) {
                                showGeneralDialog(
                                  context: context,
                                  transitionDuration:
                                      Duration(milliseconds: 400),
                                  pageBuilder: (context, animation,
                                          secondaryAnimation) =>
                                      SafeArea(
                                    child: Scaffold(
                                        backgroundColor:
                                            Colors.black12.withOpacity(0.6),
                                        body: Center(
                                            child: Container(
                                                height: 100,
                                                width: 100,
                                                child: CustomChasingDotsLoader(
                                                  color: defaultDark,
                                                  size: 60,
                                                )))),
                                  ),
                                );
                                // showDialog(
                                //     context: context,
                                //     builder: (BuildContext context) {
                                //       return Dialog(
                                //         shape: RoundedRectangleBorder(
                                //             borderRadius:
                                //                 BorderRadius.circular(30.0)),
                                //         backgroundColor: white,
                                //         child: IntrinsicHeight(
                                //           child: Container(
                                //             height: MediaQuery.of(context)
                                //                     .size
                                //                     .width *
                                //                 0.5,
                                //             decoration: BoxDecoration(
                                //               borderRadius: BorderRadius.all(
                                //                   Radius.circular(30.0)),
                                //             ),
                                //             child: Center(
                                //               child: Container(
                                //                 width: 50,
                                //                 height: 38,
                                //                 child:
                                //                     CustomCircularIndicator(),
                                //               ),
                                //             ),
                                //           ),
                                //         ),
                                //       );
                                //     });
                              }
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Students',
                                  style: kalamLight.copyWith(
                                      color: defaultDark, fontSize: 24),
                                ),
                                Expanded(
                                  child: ListView.builder(
                                      shrinkWrap: true,
                                      scrollDirection: Axis.horizontal,
                                      itemCount:
                                          advisorStudents!.data.students.length,
                                      itemBuilder: (_, index) {
                                        var users = advisorStudents!
                                            .data.students[index].name;
                                        var fullName = users!.split(" ");
                                        var firstName = fullName[0].trim();
                                        var lastName = fullName[1].trim();
                                        return _listItem(
                                            firstName: firstName,
                                            lastName: lastName,
                                            index: index);
                                      }),
                                ),
                              ],
                            ));
                      } else if (state is AdvisorStudentUserFailedState) {
                        return Container(
                          child: _getLoadingIndicator(),
                        );
                      }

                      return Container(
                        child: Text('here'),
                      );
                    },
                  ),
                ),
              ),
            )
          ],
        ));
  }
  GestureDetector sortButton(AdvisorStudentList data) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSort = !isSort;
          if(isSort)
          {
            data.data.students
                .sort((a, b) => a.name!.compareTo(b.name!));
          }
          else
          {
            data.data.students
                .sort((b, a) => a.name!.compareTo(b.name!));
          }
        });
        print(isSort);
      },
      child: Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: SvgPicture.asset('images/a_to_z.svg',color: isSort?red:Color(0xFF545454),),
      ),
    );
  }
  Widget _listItem(
      {required String firstName,
      required String lastName,
      required int index}) {
    return Container(
      child: Column(
        children: [
          CircularStudentButton(
            profileImage: advisorStudents!.data.students[index].profilePicture,
            onPressed: () {
              final selectedId = advisorStudents!.data.students[index].id!;
              this.selectedId = selectedId;
              final bloc = context.read<ThirdPersonBloc>();
              bloc.add(GetThirdPersonProfileScreenUser(
                studentId: selectedId,
                context: context,
                role: 'Student'
              ));
            },
            initial: firstName.substring(0, 1).toUpperCase() +
                lastName.substring(0, 1).toUpperCase(),
          ),
          SizedBox(height: 4),
          Text(
            '$firstName $lastName',
            style: roboto700.copyWith(color: defaultDark,fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 2),
          Container(
            width: 100,
            child: Center(
              child: Text(
                'Student',
                style: roboto700.copyWith(color: defaultDark,fontSize: 8),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


