import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/utils/konstants.dart';

class LandingPageTopWidget extends StatelessWidget {
  final double screenHeight;
  final double screenWidth;
  final double? imageHeight;
  final double? imageWidth;
  final String role;
  final String title;
  final String? subtitle;

  LandingPageTopWidget({
    required this.screenWidth,
    required this.screenHeight,
    required this.role,
    required this.title,
    this.imageHeight,
    this.imageWidth,
    this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 14,
        left: 8,
        right: 2,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SvgPicture.asset(
            'images/${role}_splash_ph.svg',
            height: imageHeight ?? screenHeight * 0.35,
            width: imageWidth ?? screenWidth * 0.6,
            semanticsLabel: "Profile Picture",
          ),
          Flexible(
            child: Padding(
              padding: EdgeInsets.only(
                bottom: screenHeight * 0.08,
              ),
              child: Transform.translate(
                // offset: Offset(-(screenWidth * 0.08), 57),
                offset: Offset(0, 48),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Semantics(
                          child: Text(
                            title,
                            style: kalamLight.copyWith(
                              height: 1,
                              color: Colors.white.withOpacity(0.85),
                              fontSize: 22,
                            ),
                            maxLines: 2,
                          ),
                        ),
                        if (subtitle != null)
                          Semantics(
                            child: Text(
                              // '${age.toString() + " yr • " + student!.gender.toString() + " • " + student!.mailingState.toString()}',
                              subtitle!,
                              style: kalamLight.copyWith(
                                color: Colors.white.withOpacity(0.85),
                                fontSize: 16,
                              ),
                              maxLines: 2,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
