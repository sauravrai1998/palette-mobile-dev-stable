import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:palette/modules/share_drawer_module/model/sharing_content_model.dart';

class SharingCardItem extends StatelessWidget {
  final SharingContentModel model;
  final double iconSize;
  const SharingCardItem({Key? key, required this.model, this.iconSize = 24})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: model.onTap,
      child: Container(
        margin: EdgeInsets.only(top: 20),
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      color: Color.fromRGBO(0, 0, 0, 0.08),
                      spreadRadius: 5,
                      blurRadius: 8,
                      offset: Offset(0, 0),
                    ),
                  ],
                ),
                child: SvgPicture.asset(
                  model.leadingSvg,
                  color: Colors.black,
                  height: iconSize,
                  width: iconSize,
                ),
              ),
              title: Text(
                model.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
              ),
            ),
            Text(
              model.description,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 16),
            ),
            Align(
              alignment: Alignment.topRight,
              child: SvgPicture.asset(
                "images/arrow_right_round.svg",
                color: model.trailingIconColor,
              ),
            )
          ],
        ),
        decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: model.trailingIconColor.withOpacity(0.08),
                spreadRadius: 5,
                blurRadius: 10,
                offset: Offset(-10, 14),
              ),
            ],
            borderRadius: BorderRadius.circular(30)),
      ),
    );
  }
}
