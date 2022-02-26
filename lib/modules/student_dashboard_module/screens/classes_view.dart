import 'package:flutter/material.dart';
import 'package:palette/common_components/back_navigation_appbar.dart';
import 'package:palette/modules/profile_module/widgets/classes_card.dart';

class ClassesView extends StatefulWidget {
  @override
  _ClassesViewState createState() => _ClassesViewState();
}

class _ClassesViewState extends State<ClassesView> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          mainAxisSize: MainAxisSize.max,
          children: [
            BackNavAppBar(title: 'Classes'),
            GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                ),
                itemCount: 10,
                itemBuilder: (BuildContext context, int index) {
                  return ClassesCard(
                      subject: 'Data Analysis',
                      id: '15CA23',
                      faculty: 'John Smith',
                      progress: 0.75);
                }),
            // BottomNavBar(text: true, items: ['Past', 'Ongoing', 'Upcoming'])
          ],
        ),
      ),
    );
  }
}
