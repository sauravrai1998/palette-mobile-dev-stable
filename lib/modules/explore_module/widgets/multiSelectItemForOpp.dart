import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class MultiSelectItemOpportunity extends StatefulWidget {
  final String name;
  bool select;
  final ValueChanged<bool> isSelected;
  String? image;

  MultiSelectItemOpportunity(
      {required this.name,
      required this.select,
      required this.isSelected,
      required this.image});

  @override
  _MultiSelectItemOpportunityState createState() =>
      _MultiSelectItemOpportunityState();
}

class _MultiSelectItemOpportunityState
    extends State<MultiSelectItemOpportunity> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    String initials =
        widget.name.split(" ").first[0] + widget.name.split(" ").last[0];
    return InkWell(
      onTap: () {
        setState(() {
          widget.select = !widget.select;
          widget.isSelected(widget.select);
        });
      },
      child: Container(
          margin: EdgeInsets.only(top: 5),
          padding: const EdgeInsets.fromLTRB(25, 2, 25, 2),
          child: Container(
            decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(12),
        ),color: widget.select ? aquaBlue : Colors.white,),
        height: 60,
            child: Row(
              children: [
                SizedBox(
                  width: 10
                ),
                _avatar(initials),
                SizedBox( width: 10),
                Text(
              '${widget.name}',
              style: darkTextFieldStyle.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: !widget.select ? aquaBlue : Colors.white),
            ),
              ],
            ),
          )),
    );
  }

  Widget _avatar(String initials) {
    return Container(
      height: 45,
      width: 45,
      decoration: BoxDecoration(
        border: Border.all(width: 2, color: aquaBlue),
        color: Colors.white,
        borderRadius: BorderRadius.circular(50),
      ),
      child: Center(
        child: widget.image == null
            ? Text(initials,
                style: darkTextFieldStyle.copyWith(
                    fontSize: 16, fontWeight: FontWeight.w700, color: aquaBlue))
            : CachedNetworkImage(
                imageUrl: widget.image ?? '',
                imageBuilder: (context, imageProvider) => Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: imageProvider, fit: BoxFit.cover),
                  ),
                ),
                placeholder: (context, url) => CircleAvatar(
                    radius:
                        // widget.screenHeight <= 736 ? 35 :
                        29,
                    backgroundColor: Colors.white,
                    child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => Text(initials,
                    style: darkTextFieldStyle.copyWith(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: aquaBlue)),
              ),
      ),
    );
  }
}
