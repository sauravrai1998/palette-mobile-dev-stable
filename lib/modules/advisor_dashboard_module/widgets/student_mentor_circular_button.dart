import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/modules/admin_dashboard_module/models/user_models/admin_student_mentors_model.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_bloc.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_events.dart';
import 'package:palette/modules/profile_module/bloc/third_person_bloc/third_person_states.dart';
import 'package:palette/modules/profile_module/models/user_models/parent_profile_user_model.dart';
import 'package:palette/modules/profile_module/models/user_models/student_profile_user_model.dart';
import 'package:palette/modules/profile_module/widgets/add_student_button.dart';
import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
import 'package:palette/modules/todo_module/screens/todo_list_screen.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class StudentMentorCircularButton extends StatefulWidget {
  final List<CommonStudentMentor> pupils;

  StudentMentorCircularButton({required this.pupils});

  @override
  _StudentMentorCircularButtonState createState() => _StudentMentorCircularButtonState();
}

class _StudentMentorCircularButtonState extends State<StudentMentorCircularButton> {
  String? selectedId;
  bool upDateState = false;
  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: BlocListener(
        bloc: context.read<ThirdPersonBloc>(),
        listener: (context, state) async {
          if (state is ThirdPersonSuccessState) {
            if (selectedId == null) return;
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
            SizedBox(height: 30),
            // HeaderRowText(leftText: 'My children'),
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
                    height: MediaQuery.of(context).size.height * 0.5,
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
                          // if(widget.isSort)
                          //   {
                          //     widget.pupils
                          //         .sort((b, a) => a.name.compareTo(b.name));
                          //   }
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

  Widget _childItem(BuildContext context, CommonStudentMentor pupil) {
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
              final selectedId = pupil.id;
              this.selectedId = selectedId;
              final bloc = context.read<ThirdPersonBloc>();
              bloc.add(GetThirdPersonProfileScreenUser(
                context: context,
                studentId: selectedId,
                role: 'Student'
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
                pupil.role ?? '',
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
