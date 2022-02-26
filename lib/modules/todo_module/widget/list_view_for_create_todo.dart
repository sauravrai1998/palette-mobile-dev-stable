// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:flutter_svg/flutter_svg.dart';
// import 'package:intl/intl.dart';
// import 'package:palette/modules/todo_module/bloc/todo_bloc.dart';
// import 'package:palette/modules/todo_module/bloc/todo_event.dart';
// import 'package:palette/modules/todo_module/bloc/todo_state.dart';
// import 'package:palette/modules/todo_module/models/todo_model.dart';
// import 'package:palette/modules/todo_module/widget/create_new_form.dart';
// import 'package:palette/modules/todo_module/widget/event_venue_box_container.dart';
// import 'package:palette/modules/todo_module/widget/textFormfieldForTodo.dart';
// import 'package:palette/utils/helpers.dart';
// import 'package:palette/utils/konstants.dart';

// class ListViewForCreate extends StatefulWidget {
//   ListViewForCreate({
//     required this.actionController,
//     required this.filterDropDownValue,
//     required this.descriptionController,
//     required this.eventVenueController,
//     required this.runtimeType,
//     required this.dateTimeStart,
//     required this.selectedTime,
//     required this.dateTimeStartEve,
//     required this.selectedEveTime,
//     required this.showDateEve,
//     required this.showSelectedEveTime,
//     required this.showSelectedTime,
//     required this.timeController,
//     required this.showDate,
//   });

//   final TextEditingController actionController;
//   String filterDropDownValue;
//   final TextEditingController descriptionController;
//   final TextEditingController eventVenueController;
//   final Type runtimeType;
//   DateTime? dateTimeStart;
//   TimeOfDay? selectedTime;
//   DateTime? dateTimeStartEve;
//   TimeOfDay? selectedEveTime;
//   DateTime showDateEve;
//   DateTime showDate;
//   TimeOfDay showSelectedEveTime;
//   TimeOfDay showSelectedTime;
//   final TextEditingController timeController;
//   @override
//   _ListViewForCreateState createState() => _ListViewForCreateState();
// }

// class _ListViewForCreateState extends State<ListViewForCreate> {
//   List<String> filter = [
//     'to-do type',
//     'Job Application',
//     'Education',
//     'College Application',
//     "Event - Arts",
//     "Event - Social",
//     "Event - Volunteer",
//     "Event - Sports",
//     "Other"
//   ];

//   late String _time, _timeEve;
//   Future<Null> _selectTime(
//     BuildContext context,
//   ) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: widget.showSelectedTime,
//     );
//     if (picked != null)
//       setState(() {
//         widget.selectedTime = picked;
//         widget.showSelectedTime = picked;
//         _time =
//             "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, widget.showSelectedTime.hour, widget.showSelectedTime.minute))}";
//         widget.timeController.text = _time;
//         widget.timeController.text = widget.showSelectedTime.toString();
//       });
//   }

//   Future<Null> _selectTimeEvent(
//     BuildContext context,
//   ) async {
//     final TimeOfDay? picked = await showTimePicker(
//       context: context,
//       initialTime: widget.showSelectedEveTime,
//     );
//     if (picked != null)
//       setState(() {
//         widget.selectedEveTime = picked;
//         widget.showSelectedEveTime = picked;
//         _timeEve =
//             "${DateFormat.jm().format(DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day, widget.showSelectedEveTime.hour, widget.showSelectedEveTime.minute))}";
//         widget.timeController.text = _timeEve;
//         widget.timeController.text = widget.showSelectedEveTime.toString();
//       });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ListView(
//       children: [
//         Padding(
//           padding: EdgeInsets.fromLTRB(40, 30, 40, 10),
//           child: Column(
//             children: [
//               buildDropDownContainer(),
//               const SizedBox(
//                 height: 20,
//               ),
//               CommonTextFieldTodo(
//                 height: 50,
//                 hintText: 'Enter Action Text',
//                 inputController: widget.actionController,
//                 isCreateForm: true,
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   buildDatePicker(context, false),
//                   buildTimePicker(context, false),
//                 ],
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               if (widget.filterDropDownValue.startsWith('Event'))
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: [
//                     buildDatePicker(context, true),
//                     buildTimePicker(context, true),
//                   ],
//                 ),
//               if (widget.filterDropDownValue.startsWith('Event'))
//                 const SizedBox(
//                   height: 20,
//                 ),
//               CommonTextFieldTodo(
//                 height: 150,
//                 hintText: 'Enter Description',
//                 inputController: widget.descriptionController,
//                 isCreateForm: true,
//               ),
//               const SizedBox(
//                 height: 20,
//               ),
//               if (widget.filterDropDownValue.startsWith('Event'))
//                 EventVenueTextBox(controller: widget.eventVenueController,isCreateForm: false,),
//               if (widget.filterDropDownValue.startsWith('Event'))
//                 const SizedBox(
//                   height: 20,
//                 ),
//             ],
//           ),
//         ),
//         const SizedBox(
//           height: 40,
//         ),
//         BlocListener(
//           bloc: BlocProvider.of<TodoCrudBloc>(context),
//           listener: (context, state) {
//             if (state is CreateTodoSuccessState) {
//               response = state.response;
//             }
//           },
//           child: Center(
//             child: BlocBuilder<TodoCrudBloc, TodoCrudState>(
//                 builder: (context, state) {
//               return Container(
//                 height: 40,
//                 width: 200,
//                 child: MaterialButton(
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.all(
//                       Radius.circular(10),
//                     ),
//                   ),
//                   color: pinkRed,
//                   onPressed: () {
//                     if (widget.dateTimeStart == null ||
//                         widget.selectedTime == null ||
//                         widget.descriptionController.text.isEmpty ||
//                         widget.filterDropDownValue == 'to-do type' ||
//                         widget.actionController.text.isEmpty) {
//                       Helper.showGenericDialog(
//                           body: 'Please enter all entries',
//                           context: context,
//                           okAction: () {
//                             Navigator.pop(context);
//                           });
//                     } else if (widget.filterDropDownValue.startsWith("Event") &&
//                         (widget.dateTimeStartEve == null ||
//                             widget.selectedEveTime == null ||
//                             widget.eventVenueController.text.isEmpty)) {
//                       Helper.showGenericDialog(
//                           body:
//                               'Along with all the fields , event field is also required',
//                           context: context,
//                           okAction: () {
//                             Navigator.pop(context);
//                           });
//                     } else {
//                       if (widget.filterDropDownValue.startsWith("Event")) {
//                         BlocProvider.of<TodoCrudBloc>(context).add(
//                           CreateTodoEvent(
//                             todoModel: TodoModel(
//                               name: widget.actionController.text,
//                               description: widget.descriptionController.text,
//                               eventAt: DateTime(
//                                       widget.showDateEve.year,
//                                       widget.showDateEve.month,
//                                       widget.showDateEve.day,
//                                       widget.showSelectedEveTime.hour,
//                                       widget.showSelectedEveTime.minute)
//                                   .toUtc()
//                                   .toIso8601String(),
//                               status: "Open",
//                               completedBy: DateTime(
//                                       widget.showDate.year,
//                                       widget.showDate.month,
//                                       widget.showDate.day,
//                                       widget.showSelectedTime.hour,
//                                       widget.showSelectedTime.minute)
//                                   .toUtc()
//                                   .toIso8601String(),
//                               type: widget.filterDropDownValue,
//                               venue: widget.eventVenueController.text,
//                             ),
//                           ),
//                         );
//                       } else {
//                         BlocProvider.of<TodoCrudBloc>(context).add(
//                           CreateTodoEvent(
//                             todoModel: TodoModel(
//                               name: widget.actionController.text,
//                               description: widget.descriptionController.text,
//                               status: "Open",
//                               completedBy: DateTime(
//                                       widget.showDate.year,
//                                       widget.showDate.month,
//                                       widget.showDate.day,
//                                       widget.showSelectedTime.hour,
//                                       widget.showSelectedTime.minute)
//                                   .toUtc()
//                                   .toIso8601String(),
//                               type: widget.filterDropDownValue,
//                             ),
//                           ),
//                         );
//                       }
//                     }
//                   },
//                   child: state is CreateTodoLoadingState
//                       ? Center(
//                           child: SpinKitChasingDots(
//                             color: Colors.white,
//                             size: 20,
//                           ),
//                         )
//                       : Text(
//                           "Create",
//                           style: roboto700.copyWith(
//                               fontSize: 17, color: Colors.white),
//                         ),
//                 ),
//               );
//             }),
//           ),
//         ),
//         const SizedBox(
//           height: 40,
//         ),
//       ],
//     );
//   }

//   buildTimePicker(
//     BuildContext context,
//     bool isEvent,
//   ) {
//     return InkWell(
//       onTap: () {
//         isEvent ? _selectTimeEvent(context) : _selectTime(context);
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.35,
//         height: 50,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 5,
//                 offset: Offset(0, 1),
//               ),
//             ]),
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 SvgPicture.asset(
//                   'images/clock.svg',
//                   color: defaultDark,
//                   height: 19,
//                   width: 19,
//                 ),
//                 if (isEvent)
//                   Text(
//                     widget.selectedEveTime == null ? 'Event Time' : '$_timeEve',
//                     style: montserratNormal.copyWith(
//                         fontSize: 14, color: defaultDark),
//                   ),
//                 if (!isEvent)
//                   Text(
//                     widget.selectedTime == null ? 'Due Time' : '$_time',
//                     style: montserratNormal.copyWith(
//                         fontSize: 14, color: defaultDark),
//                   ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   buildDatePicker(BuildContext context, bool isEve) {
//     return InkWell(
//       onTap: () {
//         isEve
//             ? showDatePicker(
//                 context: context,
//                 initialDate: widget.dateTimeStartEve == null
//                     ? DateTime(DateTime.now().year, DateTime.now().month,
//                         DateTime.now().day - 7)
//                     : widget.showDateEve,
//                 firstDate: DateTime(2021),
//                 lastDate: DateTime(DateTime.now().year + 2),
//               ).then((date) {
//                 setState(() {
//                   widget.dateTimeStartEve = date;
//                   widget.showDateEve = date != null ? date : widget.showDateEve;
//                 });
//               })
//             : showDatePicker(
//                 context: context,
//                 initialDate: widget.dateTimeStart == null
//                     ? DateTime(DateTime.now().year, DateTime.now().month,
//                         DateTime.now().day - 7)
//                     : widget.showDate,
//                 firstDate: DateTime(2021),
//                 lastDate: DateTime(DateTime.now().year + 2),
//               ).then((date) {
//                 setState(() {
//                   widget.dateTimeStart = date;
//                   widget.showDate = date != null ? date : widget.showDate;
//                 });
//               });
//       },
//       child: Container(
//         width: MediaQuery.of(context).size.width * 0.35,
//         height: 50,
//         decoration: BoxDecoration(
//             color: Colors.white,
//             borderRadius: BorderRadius.circular(10),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black.withOpacity(0.15),
//                 blurRadius: 5,
//                 offset: Offset(0, 1),
//               ),
//             ]),
//         child: Center(
//           child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 Icon(
//                   Icons.calendar_today,
//                   color: defaultDark,
//                 ),
//                 isEve
//                     ? Text(
//                         widget.dateTimeStartEve == null
//                             ? ' Event Date'
//                             : ' ${(widget.dateTimeStartEve?.month)}-${widget.dateTimeStartEve?.day}-${widget.dateTimeStartEve?.year}',
//                         style: montserratNormal.copyWith(
//                             fontSize: 14, color: defaultDark),
//                       )
//                     : Text(
//                         widget.dateTimeStart == null
//                             ? ' Due Date'
//                             : ' ${(widget.dateTimeStart?.month)}-${widget.dateTimeStart?.day}-${widget.dateTimeStart?.year}',
//                         style: montserratNormal.copyWith(
//                             fontSize: 14, color: defaultDark),
//                       ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }

//   Container buildDropDownContainer() {
//     return Container(
//       height: 50,
//       decoration: BoxDecoration(
//           color: Colors.white,
//           borderRadius: BorderRadius.circular(10),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.15),
//               blurRadius: 5,
//               offset: Offset(0, 1),
//             ),
//           ]),
//       child: Center(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(18, 0, 8, 2),
//           child: DropdownButtonFormField<String>(
//             value: widget.filterDropDownValue,
//             dropdownColor: Colors.white,
//             decoration: InputDecoration.collapsed(hintText: ''),
//             onChanged: (String? newValue) {
//               setState(() {
//                 widget.filterDropDownValue =
//                     newValue != null ? newValue : 'to-do type';
//               });
//             },
//             icon: Icon(
//               Icons.arrow_drop_down,
//               color: Colors.black,
//             ),
//             items: filter.map<DropdownMenuItem<String>>((String value) {
//               return DropdownMenuItem<String>(
//                 value: value,
//                 child: Text(
//                   value,
//                   style: montserratSemiBoldTextStyle.copyWith(
//                     color: defaultDark,
//                   ),
//                 ),
//               );
//             }).toList(),
//           ),
//         ),
//       ),
//     );
//   }
// }
