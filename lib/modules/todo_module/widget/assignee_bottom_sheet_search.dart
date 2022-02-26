import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/todo_module/models/asignee.dart';
import 'package:palette/modules/todo_module/widget/multiSelectListItem.dart';
import 'package:palette/modules/todo_module/widget/self_assign_todo_button.dart';
import 'package:palette/modules/todo_module/widget/suggest_program_todo_button.dart';

import '../../../main.dart';

class AsigneeBottomSheetSearch extends StatefulWidget {
  final SelfAsigneeModel selfAsigneeModel;
  final bool isSendToProgramSelectedFlag;
  final List<Asignee> asigneeList;
  final Function selfAssignButtonOnTap;
  final Function suggestEntireProgramOnTap;
  final Function(bool, int) asigneeOnTap;
  final Function sendOnTap;
  final Function searchTextChanged;
  final TextEditingController searchController;

  const AsigneeBottomSheetSearch({
    Key? key,
    required this.selfAsigneeModel,
    required this.isSendToProgramSelectedFlag,
    required this.asigneeList,
    required this.selfAssignButtonOnTap,
    required this.suggestEntireProgramOnTap,
    required this.asigneeOnTap,
    required this.sendOnTap,
    required this.searchTextChanged,
    required this.searchController,
  }) : super(key: key);

  @override
  _AsigneeBottomSheetSearchState createState() =>
      _AsigneeBottomSheetSearchState();
}

class _AsigneeBottomSheetSearchState extends State<AsigneeBottomSheetSearch> {
  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.8,
        maxChildSize: 0.95, // full screen on scroll
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Stack(children: [
                Column(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 5,
                      width: 50,
                      child: Container(
                        padding: EdgeInsets.only(left: 150, right: 150, top: 5),
                        color: defaultDark,
                        height: 5,
                        width: 50,
                      ),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    SelfAssignButton(
                        name: widget.selfAsigneeModel.name,
                        profilePicture: widget.selfAsigneeModel.profilePicture,
                        isSelected: widget.selfAsigneeModel.isSelfSelectedFlag,
                        onTap: () {
                          widget.selfAssignButtonOnTap();
                        }),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: _searchBar(context: context),
                    ),
                    // Row(
                    //   children: [
                    //     InstituteItemButton(isSelected: false),
                    //     InstituteItemButton(isSelected: false),
                    //   ],
                    // ),
                    SizedBox(height: 15),
                    SuggestEntireProgramButton(
                        isSelected: widget.isSendToProgramSelectedFlag,
                        onTap: () {
                          widget.suggestEntireProgramOnTap();
                        }),
                    SizedBox(height: 15),
                    TextScaleFactorClamper(
                      child: Expanded(
                        child: ListView.builder(
                          controller: scrollController,
                          itemCount: widget.asigneeList.length,
                          itemBuilder: (ctx, ind) {
                            return MultiSelectItem(
                              image:
                                  widget.asigneeList[ind].ward.profilePicture,
                              name: widget.asigneeList[ind].ward.name,
                              select: widget.asigneeList[ind].isSelected,
                              isSelected: (bool value) {
                                // mysetState(() {
                                widget.asigneeOnTap(value, ind);
                               setState(() {});
                                // });
                              },
                            );
                          },
                        ),
                      ),
                    )
                  ],
                ),
                Positioned(
                  bottom: 20,
                  right: 20,
                  child: Container(
                    color: Colors.transparent,
                    padding:
                        const EdgeInsets.only(bottom: 20, left: 15, right: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // TextButton(
                        //   onPressed: () {
                        //     if (!isSelectAll) {
                        //       isSelectAll = true;
                        //       selectedAsignee = [];
                        //       filterAsigneeDropDown
                        //           .forEach((element) {
                        //         element.isSelected = true;
                        //         selectedAsignee.add(element.ward.id);
                        //       });
                        //     } else {
                        //       isSelectAll = false;
                        //       selectedAsignee = [];
                        //       filterAsigneeDropDown
                        //           .forEach((element) {
                        //         element.isSelected = false;
                        //       });
                        //     }
                        //     final bloc = BlocProvider.of<
                        //         CreateTodoLocalSaveBloc>(context);
                        //     bloc.add(AssigneeDropDownChanged(
                        //         assigneeDropDown:
                        //         filterAsigneeDropDown));
                        //     bloc.add(SelectedAssigneesChanged(
                        //         selectedAssignees: selectedAsignee));
                        //     mysetState(() {});
                        //   },
                        //   child: Text(
                        //     !isSelectAll
                        //         ? "Select all"
                        //         : selectedAsignee.length == 0
                        //         ? "Select all"
                        //         : "Unselect all",
                        //     style: roboto700.copyWith(
                        //         fontSize: 17, color: aquaBlue),
                        //   ),
                        // ),
                        InkWell(
                          onTap: () {
                            widget.sendOnTap();
                          },
                          child: Container(
                            height: 38,
                            width: 38,
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: purpleBlue,
                            ),
                            child: SvgPicture.asset(
                              "images/sendIcon.svg",
                              height: 14,
                              width: 14,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ]),
            );
        });
  }

  void onSearchTextChanged(String text) async {
    widget.searchTextChanged(text);
  }

  Widget _searchBar({required BuildContext context}) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ExcludeSemantics(
        child: TextField(
          onTap: () {
            print('searchbartapped');
          },
          controller: widget.searchController,
          cursorColor: Colors.blueGrey,
          autocorrect: false,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            border: InputBorder.none,
            hintText: 'Search by name',
          ),
          onChanged: onSearchTextChanged,
        ),
      ),
    );
  }
}
