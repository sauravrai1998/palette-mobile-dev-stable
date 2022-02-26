import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/profile_module/models/user_models/profile_education_model.dart';
import '../../../utils/konstants.dart';
import 'package:flutter_svg/flutter_svg.dart';

class EducationHistoryWidget extends StatelessWidget {
  final List<ProfileEducationModel>? educationList;
  final String? value;
  EducationHistoryWidget({this.educationList, this.value});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 12),
                  child: SvgPicture.asset(
                    'images/education.svg',
                    width: 20,
                    height: 20,
                    color: defaultLight,
                  ),
                ),
                value == null
                    ? Container()
                    : Text(
                        value!,
                        style: kalamLight,
                      ),
                Spacer()
              ],
            ),
            SizedBox(
              height: 10,
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(
                    educationList == null ? 0 : educationList!.length,
                    (index) => _educationTile(context, educationList, index)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _educationTile(BuildContext context, List? educationList, int index) {
  return Padding(
    padding: const EdgeInsets.only(right: 28.0),
    child: Container(
      constraints: BoxConstraints(
        maxWidth: MediaQuery.of(context).size.width * 0.8,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: profileCardBackgroundColor,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child:
        // educationList == null
        //     ? Container()
        //     :
        Builder(
                builder: (context) {
                  final educationModel = educationList![index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          educationModel.instituteName ?? '',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: kalamTextStyleSmall.copyWith(
                            fontSize: 18,
                            color: defaultLight,
                          ),
                        ),
                        (educationModel.course == null ||
                                educationModel.course == '')
                            ? Container()
                            : Text(
                                educationModel.course ?? '',
                                maxLines: 1,
                                style: kalamTextStyleSmall.copyWith(
                                  fontSize: 18,
                                  color: white.withOpacity(0.5),
                                ),
                              ),
                        Row(
                          children: [
                            Text(
                              educationModel.rollNo ?? '',
                              maxLines: 1,
                              style: kalamTextStyleSmall.copyWith(
                                fontSize: 18,
                                color: white.withOpacity(0.5),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  );
                },
              ),
      ),
    ),
  );
}
