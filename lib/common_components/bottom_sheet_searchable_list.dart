import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class BottomSheetSearchableList extends StatefulWidget {
  final List<String> itemList;
  final Function(String) onTap;

  BottomSheetSearchableList({required this.itemList, required this.onTap});

  @override
  _BottomSheetSearchableListState createState() =>
      _BottomSheetSearchableListState();
}

class _BottomSheetSearchableListState extends State<BottomSheetSearchableList> {
  TextEditingController _textController = TextEditingController();
  late List<String> newDataList;

  @override
  void initState() {
    newDataList = widget.itemList;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              controller: _textController,
              decoration: InputDecoration(
                hintText: 'Search Here...',
              ),
              onChanged: onItemChanged,
            ),
          ),
          _listView()
        ],
      ),
    );
  }

  Widget _listView() {
    return Expanded(
      child: ListView.builder(
        itemCount: newDataList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
              newDataList[index],
              style: robotoTextStyle.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            onTap: () {
              widget.onTap(newDataList[index]);
            },
          );
        },
      ),
    );
  }

  onItemChanged(String value) {
    setState(() {
      newDataList = widget.itemList
          .where((string) => string.toLowerCase().contains(value.toLowerCase()))
          .toList();
    });
  }
}
