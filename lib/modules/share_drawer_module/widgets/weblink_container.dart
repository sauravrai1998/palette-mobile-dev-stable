import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class SharedWebLinkContainer extends StatelessWidget {
  final String url;
  const SharedWebLinkContainer({ Key? key,required this.url }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50,
      padding: EdgeInsets.symmetric(horizontal: 8,vertical: 4),
      width: MediaQuery.of(context).size.width * 0.8,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: offWhite,
      ),
      child: Row(
        children: [
            Icon(
              CupertinoIcons.link,
              color: Colors.black,
              size: 20,
            ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Web Link',
                style: roboto700.copyWith(
                  fontSize: 10,
                )
              ),
              Container(
                width: MediaQuery.of(context).size.width * 0.7 -10,
                child: Text(
                  '$url',
                  style: robotoTextStyle.copyWith(
                    fontSize: 14,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}