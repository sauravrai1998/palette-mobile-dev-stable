import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/modules/contacts_module/models/contact_response.dart';
import 'package:palette/modules/profile_module/widgets/children_list_view.dart';
import 'package:palette/modules/todo_module/bloc/hide_bottom_navbar_bloc/hide_bottom_navbar_bloc.dart';
import 'package:palette/utils/konstants.dart';

import '../main.dart';
import 'invite_button.dart';

class DashboardBody extends StatefulWidget {
  const DashboardBody({
    Key? key,
    required this.devHeight,
    required this.widget,
  }) : super(key: key);

  final double devHeight;
  final List<ContactsData> widget;

  @override
  State<DashboardBody> createState() => _DashboardBodyState();
}

class _DashboardBodyState extends State<DashboardBody> {
  TextEditingController searchController = TextEditingController();
  late List<ContactsData> filteredList = [];
  bool isSort = false;
  FocusNode myFocusNode = FocusNode();

  var keyboardVisibilityController = KeyboardVisibilityController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    keyboardVisibilityController.onChange.listen((bool visible) {
      print('keyboard $visible');
      if (!visible) {
        BlocProvider.of<HideNavbarBloc>(context)
            .add(ShowBottomNavbarEvent());
        setState(() {
          myFocusNode.unfocus();
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    void onSearchTextChanged(String text) async {
      setState(() {
        filteredList = [];
        if (!searchController.text.startsWith(' ')) {
          filteredList.addAll(widget.widget.where((ContactsData model) {
            return model.name.toLowerCase().contains(text.toLowerCase());
          }).toList());
          // recommendationObserver.sink.add(filteredList);
          print(filteredList[0].name);
        }
      });
    }

    Widget searchBar() {
      return Container(
        width: MediaQuery.of(context).size.width * 0.5,
        padding: EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: ExcludeSemantics(
          child: TextField(
            focusNode: myFocusNode,
            controller: searchController,
            onTap: () {
              BlocProvider.of<HideNavbarBloc>(context)
                  .add(HideBottomNavbarEvent());
            },
            cursorColor: Colors.blueGrey,
            autocorrect: false,
            onSubmitted: (_) {
              BlocProvider.of<HideNavbarBloc>(context)
                  .add(ShowBottomNavbarEvent());
            },
            decoration: InputDecoration(
              suffixIcon: Icon(
                Icons.search,
                color: Color(0xFF545454),
              ),
              border: InputBorder.none,
              hintText: 'Search...',
            ),
            onChanged: onSearchTextChanged,
          ),
        ),
      );
    }

    return TextScaleFactorClamper(
      child: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.only(top: widget.devHeight * 0.15),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          searchBar(),
                          // SizedBox(width: 10,),
                          sortButton(widget.widget),
                          // InviteButton()
                        ],
                      ),
                    ),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: ChildrenListView(
                          pupils: searchController.text.isNotEmpty &&
                                  searchController != null
                              ? filteredList
                              : widget.widget,
                        )),
                  ],
                ),
              ),
            ],
          )),
    );
  }

  GestureDetector sortButton(List<ContactsData> data) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isSort = !isSort;
          if (isSort) {
            data.sort((a, b) => a.name.compareTo(b.name));
          } else {
            data.sort((b, a) => a.name.compareTo(b.name));
          }
        });
        print(isSort);
      },
      child: Container(
        width: 50,
        height: 50,
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
        child: SvgPicture.asset(
          'images/a_to_z.svg',
          color: isSort ? red : Color(0xFF545454),
        ),
      ),
    );
  }
}
