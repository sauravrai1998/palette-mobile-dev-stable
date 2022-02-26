//  import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:palette/modules/profile_and_explore_view/bloc/profile_bloc.dart';
// import 'package:palette/modules/profile_and_explore_view/bloc/profile_states.dart';
// import 'package:palette/modules/student_view/Widgets/Tutoring.dart';
//
// import 'package:palette/modules/student_view/Widgets/classes_widget.dart';
// import 'package:palette/modules/student_view/Widgets/online_courses.dart';
// import 'package:palette/utils/konstants.dart';
//
// class StudentProfileScreenView extends StatefulWidget {
//   @override
//   _StudentProfileScreenViewState createState() => _StudentProfileScreenViewState();
// }
//
// class _StudentProfileScreenViewState extends State<StudentProfileScreenView> {
//   callBackToAddSkill(newSkills, value) {
//     print("printing DATA");
//     print(newSkills);
//     print(value);
//     if (newSkills == null || value == null) {
//     } else {
//       print("call bach function called");
//       setState(() {
//         if (value == "Classes") {
//           dummyClasses.addAll(newSkills);
//         }
//       });
//     }
//   }
//
//   List<String> dummyClasses = [
//     "Data Analysis",
//     "Computer Architecture",
//     "Computer Architecture",
//     "Computer Architecture",
//   ];
//
//   var tutoringData = [
//     {"courseName": "DBMS", "name": "Anil", "time": "8 months", "percent": "25"}
//   ];
//   var onlineCourses = [
//     {'name': "John", 'course': "DBMS", "platform": "Udemy", "percent": "26"},
//     {'name': "John", 'course': "DBMS", "platform": "Udemy", "percent": "26"},
//   ];
//
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           Transform.translate(
//             offset: Offset(-25,-20),
//             child: SvgPicture.asset(
//               'images/splash_placeholder.svg',
//               height: 130,
//             ),
//           ),
//           Scaffold(
//             backgroundColor: Colors.transparent,
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//               centerTitle: true,
//               title: Text('Palette', style: kalamLight.copyWith(
//                   color: defaultDark, fontSize: 24),),
//               leading: IconButton(color: Colors.transparent,icon: Icon(Icons.backspace_outlined),
//               onPressed: (){
//                 Navigator.pop(context);
//               },),
//             ),
//             body: Padding(
//               padding: const EdgeInsets.only(left: 20),
//               child: ListView(
//                 children: [
//                   SizedBox(height: 40,),
//                   Column(
//                     children: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 18.0, bottom: 5),
//                         child: Row(
//                           children: [
//                             Text(
//                               "Your Advisors",
//                               style: kalamLight.copyWith(
//                                   color: defaultDark, fontSize: 24),
//                             ),
//                             Spacer(),
//                             GestureDetector(
//                               child: Text(
//                                 "View All",
//                                 style: kalamLight.copyWith(
//                                     fontSize: 14, color: defaultDark),
//                               ),
//                             )
//                           ],
//                         ),
//                       ),
//                       Container(
//                         height: 100,
//                         child: ListView.builder(
//                           scrollDirection: Axis.horizontal,
//                           itemBuilder: (context, index) {
//                             return Padding(
//                               padding: const EdgeInsets.only(right: 18.0),
//                               child: Column(
//                                 children: [
//                                   CircleAvatar(
//                                     radius: 30,
//                                     child: Icon(Icons.person),
//                                   ),
//                                   SizedBox(
//                                     height: 3,
//                                   ),
//                                   Text(
//                                     'John Smith',
//                                     style: kalamTextStyle.copyWith(
//                                         fontSize: 12, fontWeight: FontWeight.w700),
//                                   ),
//                                 ],
//                               ),
//                             );
//                           },
//                           itemCount: 10,
//                         ),
//                       ),
//                     ],
//                   ),
//                   BlocBuilder<ProfileBloc, ProfileState>(
//                       bloc: context.read<ProfileBloc>(),
//                       builder: (context, state) {
//                         // ignore: unrelated_type_equality_checks
//                         if (state is GetEducationDataSuccessState) {
//                           var classData = state.educationData[0].classDataModel;
//                           var onlineCoursesData =
//                               state.educationData[0].onlineCoursesModel;
//                           var tutoringData = state.educationData[0].tutoringModel;
//                           print(tutoringData);
//                           return Column(
//                             children: [
//                               ClassesWidget(
//                                 points: classData,
//                                 value: 'Classes',
//                                 callBackfn: callBackToAddSkill,
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               OnlineCourses(
//                                 points: onlineCoursesData,
//                                 value: 'Online Courses',
//                                 callBackfn: callBackToAddSkill,
//                               ),
//                               SizedBox(
//                                 height: 16,
//                               ),
//                               Tutoring(
//                                 points: tutoringData,
//                                 value: 'Tutoring',
//                                 callBackfn: callBackToAddSkill,
//                               ),
//                             ],
//                           );
//                         }
//                         return Text("NONE");
//                       }),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
