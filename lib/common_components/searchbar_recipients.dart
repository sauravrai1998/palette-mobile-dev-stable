import 'package:flutter/material.dart';

class SearchBarForRecipients extends StatelessWidget {
  final TextEditingController searchController;
  FocusNode? searchFocusNode;
  final Function(String) onChanged;
  
  SearchBarForRecipients({required this.searchController,this.searchFocusNode,required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      margin: EdgeInsets.symmetric(horizontal: 10),
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.all(Radius.circular(10.0)),
      ),
      child: ExcludeSemantics(
        child: TextField(
          onTap: () {
            print('searchbartapped');
          },
          controller: searchController,
          focusNode: searchFocusNode,
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
          onChanged: onChanged,
          onSubmitted: (str) {
            print('submitted');
          },
        ),
      ),
    );
  }
}