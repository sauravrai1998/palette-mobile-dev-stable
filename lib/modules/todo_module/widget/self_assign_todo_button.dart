import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class SelfAssignButton extends StatelessWidget {
  final bool isSelected;
  final Function onTap;
  final String? name;
  final String profilePicture;
  const SelfAssignButton(
      {required this.isSelected,
      required this.onTap,
      required this.profilePicture,
      required this.name});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        return onTap();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        margin: const EdgeInsets.symmetric(horizontal: 20),
        height: 69,
        decoration: BoxDecoration(
          color: isSelected ? defaultDark : shareBackground,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 5,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            CircleAvatar(
                backgroundColor: white,
                radius: 30,
                child: CachedNetworkImage(
                  imageUrl: profilePicture,
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
                  errorWidget: (context, url, error) => Text(
                      Helper.getInitials(name ?? ''),
                      style: darkTextFieldStyle.copyWith(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: aquaBlue)),
                )),
            SizedBox(width: 5),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name ?? '',
                  style: roboto700.copyWith(
                    color: isSelected ? white : defaultDark,
                    fontSize: 16,
                  ),
                ),
                SizedBox(height: 3),
                Container(
                  width: MediaQuery.of(context).size.width * .70,
                  child: Text(
                    'YOU',
                    style: roboto700.copyWith(
                        fontSize: 13,
                        color: isSelected
                            ? white.withOpacity(0.5)
                            : defaultDark.withOpacity(0.5)),
                    maxLines: 2,
                    overflow: TextOverflow.clip,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class SelfAsigneeModel {
  final String name;
  final String profilePicture;
  final bool isSelfSelectedFlag;

  SelfAsigneeModel({
    required this.name,
    required this.profilePicture,
    required this.isSelfSelectedFlag,
  });
}
