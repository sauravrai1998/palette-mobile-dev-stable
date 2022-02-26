import 'package:flutter/material.dart';
import 'package:palette/modules/explore_module/widgets/add_to_todo_bulk_edit_button.dart';
import 'package:palette/modules/explore_module/widgets/consider_bulk_edit_button.dart';
import 'package:palette/modules/explore_module/widgets/share_opp_bulk_edit_button.dart';
import 'package:palette/utils/konstants.dart';

class ExploreBulkSelectOptionsStu extends StatelessWidget {
  final Function onClearTap;
  final Function onAddToTodoTap;
  final Function onConsiderTap;
  final Function() onShareTap;
  final bool showTodo;
  final bool showConsider;
  final bool showShare;
  const ExploreBulkSelectOptionsStu({
    required this.onClearTap,
    required this.onAddToTodoTap,
    required this.onConsiderTap,
    required this.onShareTap,
    required this.showTodo,
    required this.showConsider,
    required this.showShare,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      decoration: BoxDecoration(
        color: uploadIconButtonColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Text(
                  'Options',
                  style: roboto700.copyWith(fontSize: 14, color: Colors.white),
                ),
                SizedBox(height: 4),
                Container(
                  width: 28,
                  height: 1.6,
                  color: Colors.white,
                ),
                SizedBox(height: 18),
                if(showTodo)
                GestureDetector(
                    onTap: () {
                      onAddToTodoTap();
                    },
                    child: AddTodoBulkEditButton()),
                if(showConsider)
                GestureDetector(
                    onTap: () {
                      onConsiderTap();
                    },
                    child: ConsiderBulkEditButton()),
                if (showShare)
                GestureDetector(
                  onTap: () {
                    onShareTap();
                  },
                  child: ShareOppBulkEditButton(),
                ),
              ],
            ),
          ),
          _clearSelectionButton()
        ],
      ),
    );
  }

  Widget _clearSelectionButton() {
    return InkWell(
      onTap: () {
        print('Clear selection');
        onClearTap();
      },
      child: Container(
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 12),
        color: clearSelectionBackgroundColor.withOpacity(0.12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Clear Selection',
              style:
                  robotoTextStyle.copyWith(fontSize: 14, color: Colors.white),
            ),
            Icon(
              Icons.delete,
              color: white,
              size: 18,
            )
          ],
        ),
      ),
    );
  }
}
