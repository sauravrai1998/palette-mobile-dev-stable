import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_events.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_states.dart';
import 'package:palette/modules/profile_module/models/user_models/admin_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/admin_profile_screen.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/advisor_profile_screen.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/observer_profile_screen.dart';
import 'package:palette/modules/profile_module/screens/profile_screens/parent_profile_screen.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/screens/todo_list_screen.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

import 'add_student_button.dart';

class ChildrenListView extends StatefulWidget {
  final List<ContactsData> pupils;

  ChildrenListView({required this.pupils});

  @override
  _ChildrenListViewState createState() => _ChildrenListViewState();
}

class _ChildrenListViewState extends State<ChildrenListView> {
  String? selectedId;
  bool upDateState = false;
  String? selectedRole;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: BlocListener(
        bloc: context.read<ThirdPersonBloc>(),
        listener: (context, state) async {
          if (state is ThirdPersonSuccessState) {
            print(state.profileUser);
            if (selectedId == null || selectedRole == null) return;

            if (selectedRole!.toLowerCase() == 'student') {
              final bloc = context.read<TodoListBloc>();
              bloc.add(
                TodoListEvent(studentId: selectedId!),
              );

              var studentData = state.profileUser as StudentProfileUserModel;
              print('pupil.id: ${selectedId!}');
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoListScreen(
                    student: studentData,
                    studentId: selectedId!,
                    thirdPerson: true,
                  ),
                ),
              );
            }
            else if (selectedRole!.toLowerCase() == 'observer') {
              var observerData = state.profileUser as ObserverProfileUserModel;
              print('pupil.id: ${selectedId!}');
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ObserverProfileScreen(observer: observerData,thirdPerson: true,),
                ),
              );
            }
            else if (selectedRole!.toLowerCase() == 'advisor') {
              var advisorData = state.profileUser as AdvisorProfileUserModel;
              print('pupil.id: ${selectedId!}');
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdvisorProfileScreen(advisor: advisorData,thirdPerson: true,),
                ),
              );
            }
            else if (selectedRole!.toLowerCase() == 'admin' || selectedRole!.toLowerCase() == 'administrator') {
              var adminData = state.profileUser as AdminProfileUserModel;
              print('pupil.id: ${selectedId!}');
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AdminProfileScreen(admin: adminData,thirdPerson: true,),
                ),
              );
            }
            else {
              var parentData = state.profileUser as ParentProfileUserModel;
              print('pupil.id: ${selectedId!}');
              Navigator.of(context).pop();
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ParentProfileScreen(parent: parentData,thirdPerson: true,),
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
              transitionDuration: Duration(milliseconds: 400),
              pageBuilder: (context, animation, secondaryAnimation) => SafeArea(
                child: Scaffold(
                    backgroundColor: Colors.black12.withOpacity(0.6),
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
          }
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // SizedBox(height: 30),
            SizedBox(height: 12),
            widget.pupils.isEmpty
                ? Padding(
                    padding: const EdgeInsets.only(left: 20),
                    child: Text(
                      'None',
                      style: kalamTextStyleSmall.copyWith(
                        color: defaultDark,
                        fontSize: 18,
                      ),
                    ),
                  )
                : Column(
                    children: [
                      Container(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: GridView.builder(
                              itemCount: widget.pupils.length,
                              shrinkWrap: false,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2,
                                childAspectRatio: (3 / 4),
                              ),
                              itemBuilder: (
                                context,
                                index,
                              ) {
                                return _childItem(
                                    context, widget.pupils[index]);
                              })),
                      SizedBox(
                        height: 10,
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
    //   }
    // });
  }

  Widget _childItem(BuildContext context, ContactsData pupil) {
    var fullName = pupil.name.split(" ");
    var firstName = fullName[0].trim().substring(0, 1).toUpperCase();
    var lastName = fullName[1].trim().substring(0, 1).toUpperCase();
    var initial = firstName + lastName;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          AddStudentButton(
            onPressed: () {
              final selectedId = pupil.sfid;
              this.selectedId = selectedId;
              final selectedRole = pupil.relationship;
              this.selectedRole = selectedRole;
              final bloc = context.read<ThirdPersonBloc>();
              bloc.add(GetThirdPersonProfileScreenUser(
                context: context,
                studentId: selectedId,
                role: selectedRole!
              ));
            },
            profileImage: pupil.profilePicture,
            initial: initial,
          ),
          SizedBox(height: 4),
          Container(
            width: 100,
            child: Center(
              child: Text(
                pupil.name,
                style: roboto700.copyWith(color: defaultDark,fontSize: 14),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          SizedBox(height: 2),
          Container(
            width: 100,
            child: Center(
              child: Text(
                pupil.relationship == null ? '': pupil.relationship! ,
                style: roboto700.copyWith(color: defaultDark,fontSize: 8),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _addChildButtonItem() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6.0),
      child: Column(
        children: [
          AddStudentButton(
            onPressed: () {},
          ),
          SizedBox(height: 4),
          Text(
            'Add Child',
            style: kalamTextStyleSmall.copyWith(color: defaultLight),
          ),
        ],
      ),
    );
  }
}
