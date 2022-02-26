import 'package:flutter/cupertino.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/common_components/skill_interest_chip_add_button.dart';
import 'package:palette/icons/imported_icons.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:palette/modules/profile_module/widgets/skill_interest_chip.dart';
import 'package:palette/modules/profile_module/widgets/view_all_modal_sheet.dart';

import '../../../utils/konstants.dart';

class InterestAndActivities extends StatefulWidget {
  final List<String>? points;
  final String? value;
  final Function? callBackfn;
  final bool thirdPerson;
  final String userId;
  final String sfid;
  final String sfuuid;
  final String role;
  InterestAndActivities(
      {this.points, this.value, this.callBackfn, this.thirdPerson = false,required this.userId,
        required this.sfid, required this.sfuuid, required this.role});
  @override
  _InterestAndActivitiesState createState() => _InterestAndActivitiesState();
}

class _InterestAndActivitiesState extends State<InterestAndActivities> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(widget.thirdPerson);
  }

  var listOfWidgets = [];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Row(
            children: [
              widget.value == "Interest"
                  ? Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        Imported.hiking_24px_1,
                        color: defaultLight,
                      ),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(right: 12),
                      child: Icon(
                        Imported.mood_black_18dp_1,
                        color: defaultLight,
                      ),
                    ),
              Semantics(
                label: widget.thirdPerson == false
                    ? "${widget.value} entered by you are displayed here. To view them all or add more, click on the view all button next to this title"
                    : "${widget.value} entered by you are displayed here. To view them all, click on the view all button next to this title",
                child: Text(
                  "${widget.value}",
                  style: kalamLight,
                ),
              ),
              Spacer(),
              Semantics(
                child: BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
                        ProfilePendoRepo.trackViewAllInterests(pendoState: pendoState, thirdPerson: widget.thirdPerson);
                        onViewAllTap(
                          context: this.context,
                          points: widget.points,
                          value: widget.value,
                          callBackfn: widget.callBackfn,
                          thirdPerson: widget.thirdPerson,
                          isSkill: false,
                            sfid: widget.sfid
                        );
                      },
                      child: Text(
                        "View All",
                        style: kalamLight.copyWith(fontSize: 14, color: white),
                      ),
                    );
                  }
                ),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: List.generate(
                widget.points == null
                    ? 0
                    : widget.thirdPerson
                        ? widget.points!.length
                        : widget.points!.length + 1,
                (index) {
                  print(widget.thirdPerson);
                  if (widget.points!.length == 0 && !widget.thirdPerson) {
                    return SkillInterestChipAddButton(
                      point: "+ ${widget.value}",
                      callBackfn: widget.callBackfn,
                      data: widget.points!,
                      sfid: widget.sfid,
                      sfuuid: widget.sfuuid,
                    );
                  }
                  if (widget.thirdPerson) {
                    return widget.points!.length == 0?SkillInterestChip(
                      point: "No ${widget.value} added",)
                          :SkillInterestChip(
                      point: widget.points![index],
                    );
                  } else {
                    return widget.points!.length == index
                        ? SkillInterestChipAddButton(
                            point: "+ ${widget.value}",
                            callBackfn: widget.callBackfn,
                            data: widget.points!,
                        sfid: widget.sfid,
                        sfuuid: widget.sfuuid,
                          )
                        : SkillInterestChip(
                            point: widget.points![index],
                          );
                  }

                },
              ),
            ),
          )
        ],
      ),
    );
  }
}
