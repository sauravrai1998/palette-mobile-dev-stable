import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ProfilePictureWidget extends StatefulWidget {
  final String? profileImage;

  ProfilePictureWidget({
    Key? key,
    this.profileImage,
  }) : super(key: key);
  @override
  _ProfilePictureWidgetState createState() => _ProfilePictureWidgetState();
}

class _ProfilePictureWidgetState extends State<ProfilePictureWidget> {
  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(
            child: SvgPicture.asset(
              'images/profile_pic_background_inverted.svg',
            ),
          ),
          Positioned(
            bottom: (250 / 2) - 38,
            child: CircleAvatar(
              backgroundColor: Colors.grey,
              radius: 40,
              child: Builder(builder: (context) {
                return widget.profileImage != null
                    ? ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(40)),
                        child: Image.network(
                          widget.profileImage!,
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: AssetImage('images/Black_Box.png'),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
              }),
            ),
          )
        ],
      ),
    );
  }
}
