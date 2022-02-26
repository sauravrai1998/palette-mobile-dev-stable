import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/skill_interest_chip_add_button.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:palette/modules/profile_module/widgets/skill_interest_chip.dart';
import 'package:palette/modules/profile_module/widgets/view_all_modal_sheet.dart';
import '../../../utils/konstants.dart';

class SkillWidget extends StatefulWidget {
  final List<String>? points;
  final String? value;
  final Function? callBackfn;
  final bool thirdPerson;
  final String userId;
  final String sfid;
  final String sfuuid;
  final String role;
  SkillWidget({
    this.points,
    this.value,
    this.callBackfn,
    this.thirdPerson = false,
    required this.userId,
    required this.sfid,
    required this.sfuuid,
    required this.role
  });
  @override
  _SkillWidgetState createState() => _SkillWidgetState();
}

class _SkillWidgetState extends State<SkillWidget> {
  var listOfWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: Icon(
                  Imported.stream_black_18dp_1,
                  color: defaultLight,
                ),
              ),
              Text(
                "${widget.value}",
                style: kalamLight,
              ),
              Spacer(),
              BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
                      ProfilePendoRepo.trackViewAllSkills(pendoState: pendoState,thirdPerson: widget.thirdPerson);
                      onViewAllTap(
                        context: this.context,
                        points: widget.points,
                        value: widget.value,
                        callBackfn: widget.callBackfn,
                        thirdPerson: widget.thirdPerson,
                        isSkill: true,
                        sfid: widget.sfid
                      );
                    },
                    child: Text(
                      "View All",
                      style: kalamLight.copyWith(fontSize: 14, color: white),
                    ),
                  );
                }
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          Builder(
            builder: (_) {
              final length;
              if (widget.points == null) {
                length = 0;
              } else if (widget.points!.length > 6) {
                length = 6;
              } else {
                length = widget.points!.length;
              }
              return Wrap(
                children: List.generate(length + 1, (index) {
                  if (length == 6 && length == index) {
                    return BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
                      ProfilePendoRepo.trackViewAllSkills(pendoState: pendoState,thirdPerson: widget.thirdPerson);
                            onViewAllTap(
                              context: this.context,
                              points: widget.points,
                              value: widget.value,
                              callBackfn: widget.callBackfn,
                              thirdPerson: widget.thirdPerson,
                              isSkill: true,
                                sfid: widget.sfid
                            );
                          },
                          child: widget.points!.length - 6 == 0 ? SkillInterestChipAddButton(
                            point: "+ ${widget.value}",
                            callBackfn: widget.callBackfn,
                            data: widget.points!,
                              sfid: widget.sfid,
                              sfuuid: widget.sfuuid,
                          ):SkillInterestChip(
                            color: moreChipColor,
                            point: '${widget.points!.length - 6} more',
                          ),
                        );
                      }
                    );
                  }
                  return widget.thirdPerson == false
                      ? length == index
                          ? SkillInterestChipAddButton(
                              point: "+ ${widget.value}",
                              callBackfn: widget.callBackfn,
                              data: widget.points!,
                      sfid: widget.sfid,
                      sfuuid: widget.sfuuid,
                            )
                          : SkillInterestChip(
                              point: widget.points![index],
                            )
                      : length == 0
                          ? SkillInterestChip(
                              point: "No ${widget.value} added",
                            )
                          : length == index
                              ? SizedBox()
                              : SkillInterestChip(
                                  point: widget.points![index],
                                );
                }),
              );
            },
          )
        ],
      ),
    );
  }
}
