import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette/utils/konstants.dart';

class ProfileIconTodo extends StatelessWidget {
  final String? initial;
  final String img;
  final double height;
  final Color bgColor;

  const ProfileIconTodo(
      {Key? key, required this.img,this.initial, this.bgColor = openOpac, this.height = 50})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: height,
      margin: EdgeInsets.all(4),
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: bgColor),
      child: CachedNetworkImage(
        imageUrl: img,
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
        errorWidget: (context, url, error) => CircleAvatar(
          backgroundColor: Colors.white,
          child: Center(
            child: Text(
              initial!,
              style:
              kalamLight.copyWith(color: defaultDark, fontSize: 24),
            ),
          ),
        ),
      ),
    );
  }
}
