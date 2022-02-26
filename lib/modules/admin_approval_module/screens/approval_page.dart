import 'package:flutter/material.dart';
import 'package:palette/modules/admin_approval_module/widgets/approval_list_item_widget.dart';
import 'package:palette/utils/konstants.dart';

class ApprovalPage extends StatefulWidget {
  const ApprovalPage({Key? key}) : super(key: key);

  @override
  _ApprovalPageState createState() => _ApprovalPageState();
}

class _ApprovalPageState extends State<ApprovalPage> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Scaffold(
        body: Column(
          children: [
            titleRow(),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 10,
              ),
              child: Semantics(
                  container: true, label: "Search button", child: searchBar()),
            ),
            Expanded(child: _listView()),
          ],
        ),
      ),
    );
  }

  Widget titleRow() {
    return Align(
      alignment: Alignment.topLeft,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(35, 50, 30, 0),
        child: Container(
            child: Text(
          "Approvals",
          style: robotoTextStyle.copyWith(
              fontWeight: FontWeight.bold, fontSize: 26),
        )),
      ),
    );
  }

  Widget searchBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ExcludeSemantics(
        child: TextField(
          controller: searchController,
          cursorColor: Colors.blueGrey,
          autocorrect: false,
          decoration: InputDecoration(
            suffixIcon: Icon(
              Icons.search,
              color: Colors.grey,
            ),
            border: InputBorder.none,
            hintText: 'Search...',
          ),
          onChanged: onSearchTextChanged,
        ),
      ),
    );
  }

  void onSearchTextChanged(String text) async {
    // filteredList = [];
    // if (!searchController.text.startsWith(' ')) {
    //   filteredList.addAll(mainList.where((RecommendedByData model) {
    //     return model.event!.name!.toLowerCase().contains(text.toLowerCase());
    //   }).toList());
    //   recommendationObserver.sink.add(filteredList);
    // }
  }

  Widget _listView() {
    return ListView.builder(
        itemCount: 3,
        itemBuilder: (context, index) {
          return ApprovalListItemWidget(
            index: index,
          );
        });
  }
}
