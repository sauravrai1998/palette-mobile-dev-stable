import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/modules/profile_module/models/user_models/observer_profile_user_model.dart';
import '../../../utils/konstants.dart';

class InstituteListWidget extends StatelessWidget {
  final List<InstituteDetail>? educationList;
  final String? value;
  InstituteListWidget({this.educationList, this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Container(
            height: 100,
            child: ListView.builder(
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 28.0),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: profileCardBackgroundColor,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 8),
                      child: educationList == null
                          ? Container()
                          : Builder(builder: (context) {
                              final educationModel = educationList![index];
                              return Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 6.0),
                                child: Semantics(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Text(
                                        educationModel.instituteName ?? '',
                                        maxLines: 1,
                                        style: kalamTextStyleSmall.copyWith(
                                          fontSize: 18,
                                          color: defaultLight,
                                        ),
                                      ),
                                      (educationModel.designation == null ||
                                              educationModel.designation == '')
                                          ? Container()
                                          : Text(
                                              educationModel.designation ?? '',
                                              maxLines: 1,
                                              style:
                                                  kalamTextStyleSmall.copyWith(
                                                fontSize: 18,
                                                color: white.withOpacity(0.5),
                                              ),
                                            ),
                                      // Row(
                                      //   children: [
                                      //     Text(
                                      //       educationModel.rollNo ?? '',
                                      //       maxLines: 1,
                                      //       style: kalamTextStyleSmall.copyWith(
                                      //         fontSize: 18,
                                      //         color: white.withOpacity(0.5),
                                      //       ),
                                      //     ),
                                      //   ],
                                      // )
                                    ],
                                  ),
                                ),
                              );
                            }),
                    ),
                  ),
                );
              },
              scrollDirection: Axis.horizontal,
              itemCount: educationList == null ? 0 : educationList!.length,
            ),
          )
        ],
      ),
    );
  }
}
