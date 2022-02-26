import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/todo_module/bloc/todo_filter_bloc/todo_filter_bloc.dart';
import 'package:palette/modules/todo_module/services/todo_pendo_repo.dart';

import '../../../main.dart';
import 'circular_todo_button.dart';

class TodoListFilterWidget extends StatelessWidget {
  final Function onSearchIconPressed;
  final bool isSearchSelected;
  final bool byme;
  final Widget filterButton;
  final void Function(PendoMetaDataState) onByMeSelected;
  const TodoListFilterWidget(
      {Key? key,
      required this.onSearchIconPressed,
      required this.isSearchSelected,
      required this.byme,
      required this.filterButton,
      required this.onByMeSelected})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 20, right: 10),
      color: Colors.white,
      width: MediaQuery.of(context).size.width,
      child: Stack(
        children: [
          AnimatedAlign(
            duration: Duration(milliseconds: 300),
            alignment: !isSearchSelected
                ? Alignment.centerRight
                : Alignment.centerLeft,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                filterButton,
                SizedBox(
                  width: 10,
                ),
                Material(
                  elevation: 0,
                  borderRadius: BorderRadius.circular(10),
                  child: BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                      builder: (context, pendoState) {
                    return InkWell(
                      onTap: () {
                        onByMeSelected(pendoState);
                      },
                      child: TextScaleFactorClamper(
                        child: Container(
                          padding: EdgeInsets.all(8),
                          //width: 100,
                          decoration: BoxDecoration(
                              color: byme ? pinkRed : Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius: 5,
                                  offset: Offset(0, 1),
                                ),
                              ]),

                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Text(
                                "By me",
                                style: montserratBoldTextStyle.copyWith(
                                  color: byme ? Colors.white : pinkRed,
                                  fontSize: 14,
                                ),
                                semanticsLabel: byme
                                    ? "Remove filter"
                                    : "Filter to only show tasks created by you",
                              ),
                              if (byme)
                                SvgPicture.asset(
                                  "images/crossicon.svg",
                                  color: Colors.white,
                                  height: 14,
                                  width: 14,
                                ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ),
                SizedBox(width: 10),
                if (!isSearchSelected)
                  CircularTodoSearchButton(
                    onTap: () {
                      onSearchIconPressed();
                    },
                    icon: Icons.search,
                    iconColor: pinkRed,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
