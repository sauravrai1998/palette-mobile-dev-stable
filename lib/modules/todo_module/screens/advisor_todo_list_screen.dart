// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:palette/main.dart';
// import 'package:palette/modules/advisor_dashboard_module/models/advisor_student_model.dart';
// import 'package:palette/modules/profile_module/models/user_models/advisor_profile_user_model.dart';
// import 'package:palette/utils/konstants.dart';
//
// import '../models/todo_listItem.dart';
//
// class AdvisorTodoListScreen extends StatefulWidget {
//   // final StudentProfileUserModel? student;
//   // final bool thirdPerson;
//   // final String studentId;
//   final AdvisorProfileUserModel? advisor;
//   final AdvisorStudentList? student;
//   AdvisorTodoListScreen({
//     Key? key,
//     // required this.student,
//     // this.thirdPerson = false,
//     // this.studentId = '',
//     required this.student,
//     required this.advisor,
//   }) : super(key: key);
//
//   @override
//   _AdvisorTodoListScreenState createState() => _AdvisorTodoListScreenState();
// }
//
// class _AdvisorTodoListScreenState extends State<AdvisorTodoListScreen> {
//   @override
//   void initState() {
//     getTodoData();
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return SafeArea(
//       child: TextScaleFactorClamper(
//         child: Semantics(
//           label:
//               "Welcome to your dashboard! you can keep track of your tasks using this todo module",
//           child: Scaffold(
//             body: Stack(children: [
//               Scaffold(
//                 backgroundColor: Colors.white,
//                 appBar: PreferredSize(
//                   preferredSize: Size.fromHeight(125.0),
//                   child: AppBar(
//                     automaticallyImplyLeading: false,
//                     backgroundColor: Colors.transparent,
//                     elevation: 0,
//                     centerTitle: true,
//                     title: Text(
//                       'To Do',
//                       style:
//                           kalamLight.copyWith(color: defaultDark, fontSize: 24),
//                     ),
//                   ),
//                 ),
//                 // body: ParentTodoListTabView(
//                 //     studentId: widget.student!.data.students[4].id!),
//               ),
//               GestureDetector(
//                 onTap: () {
//                   Navigator.pop(context);
//                 },
//                 child: Container(
//                   child: SvgPicture.asset(
//                     'images/advisor_small_splash.svg',
//                     height: 130,
//                     semanticsLabel: "Profile Picture.",
//                   ),
//                 ),
//               )
//             ]),
//           ),
//         ),
//       ),
//     );
//   }
// }
