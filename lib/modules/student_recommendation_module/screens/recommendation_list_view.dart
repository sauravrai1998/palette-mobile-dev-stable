import 'package:flutter/material.dart';
import 'package:palette/modules/student_recommendation_module/screens/recommendation_list_item.dart';

class RecommendListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: ListView.builder(
        itemCount: 1,
        itemBuilder: (context, index) {
          // final type = todoList[index].task.type;

          /// For social icon has to be checked for 4 types
          // final grad1 = type.startsWith('College')
          //     ? educationColorGrad1
          //     : type.startsWith('Job')
          //         ? companyColorGrad1
          //         : type == 'Generic'
          //             ? genericColorGrad1
          //             : socialColorGrad1;
          // final grad2 = type.startsWith('College')
          //     ? educationColorGrad2
          //     : type.startsWith('Job')
          //         ? companyColorGrad2
          //         : type == 'Generic'
          //             ? genericColorGrad2
          //             : socialColorGrad2;
          //
          // final image = type.startsWith('College')
          //     ? "images/todo_education.svg"
          //     : type.startsWith('Job')
          //         ? "images/todo_business.svg"
          //         : _getImageStringForEvent(type: type);
          //
          // final iconBackground = type.startsWith('College')
          //     ? educationColorGrad1
          //     : type.startsWith('Job')
          //         ? companyColorGrad1
          //         : type == 'Generic'
          //             ? genericColorGrad1
          //             : socialColorGrad1;

          return Semantics(
            child: RecommendListItemWidget(),
          );
        },
      ),
    );
  }
}
