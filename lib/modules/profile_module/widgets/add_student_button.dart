import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette/common_components/custom_chasing_dots_loader.dart';
import 'package:palette/utils/konstants.dart';

class AddStudentButton extends StatelessWidget {
  final Function()? onPressed;
  final String? profileImage;
  final String? initial;
  //final String? initial2;

  AddStudentButton({
    Key? key,
    required this.onPressed,
    this.profileImage,
    this.initial,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Semantics(
      onTapHint: "View student",
      child: GestureDetector(
        onTap: onPressed,
        child: ExcludeSemantics(
          child: CircleAvatar(
            radius: 36,
            backgroundColor: defaultDark,
            child: CircleAvatar(
              radius: 32,
              backgroundColor: white,
              child: Builder(builder: (context) {
                if (profileImage == null ) {
                  return ClipRRect(
                      borderRadius: BorderRadius.circular(36.0),
                      child: Text(
                        initial!,
                        style:
                            kalamLight.copyWith(color: defaultDark, fontSize: 24),
                      ));
                } else {
                  return
                    CachedNetworkImage(
                      imageUrl: profileImage ?? '',
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
                          child: CustomChasingDotsLoader(color: defaultDark)),
                      errorWidget: (context, url, error) => ClipRRect(
                          borderRadius: BorderRadius.circular(36.0),
                          child: Text(
                            initial!,
                            style:
                            kalamLight.copyWith(color: defaultDark, fontSize: 24),
                          )),
                    );
                  //   Center(
                  //   child: Icon(
                  //     Icons.add,
                  //     size: 30,
                  //     color: defaultDark,
                  //   ),
                  // );
                }
              }),
            ),
          ),
        ),
      ),
    );
  }
}
