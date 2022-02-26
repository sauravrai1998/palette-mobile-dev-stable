import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/common_components_link.dart';
import 'package:palette/main.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';


import '../../../utils/konstants.dart';
import 'add_value.dart';

onViewAllTap({context, points, value, callBackfn, thirdPerson, isSkill, sfid,sfuuid}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: false,
    isDismissible: true,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20), topRight: Radius.circular(20)),
    ),
    builder: (context) {
      return Builder(builder: (context) {
        print(points.length);
        return TextScaleFactorClamper(
          child: Container(
            height: 105.0 + (8 / 3.0 * 100.0),
            child: SafeArea(
              child: Padding(
                padding: EdgeInsets.only(top: 0, left: 20, right: 20),
                child: Semantics(
                    label: "All your added $value are as follows",
                    child: points.length == 0
                        ? Container(
                            child: Center(
                                child: isSkill
                                    ? Text(
                                        "No Skills added",
                                        style: kalam700,
                                      )
                                    : Text(
                                        "No Interests added",
                                        style: kalam700,
                                      )),
                          )
                        : Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                                //SizedBox(height: 10),
                                Container(
                                  // height: devHeight * 0.42,
                                  height: ((8 / 3) * 100.0),
                                  child: Scrollbar(
                                    isAlwaysShown: true,
                                    child: SingleChildScrollView(
                                      child: Wrap(
                                        direction: Axis.horizontal,
                                        children: List.generate(
                                          points.length,
                                          (index) {
                                            return Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 25,
                                                    top: 10,
                                                    bottom: 10),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    color:
                                                        profileCardBackgroundColor,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 12,
                                                        vertical: 8),
                                                    child: Text(
                                                      "${points[index]}",
                                                      style: kalamLight,
                                                    ),
                                                  ),
                                                ));
                                          },
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                if (thirdPerson == false)
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Semantics(
                                        button: true,
                                        child: BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
                                                ProfilePendoRepo.trackOpenSheetForAddingValue(pendoState: pendoState, isSkill: isSkill);
                                                Navigator.pop(context);
                                                showModalBottomSheet(
                                                  context: context,
                                                  isScrollControlled: true,
                                                  shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.only(
                                                        topLeft:
                                                            Radius.circular(20),
                                                        topRight:
                                                            Radius.circular(20)),
                                                  ),
                                                  isDismissible: true,
                                                  builder: (BuildContext context) {
                                                    return Padding(
                                                      padding:MediaQuery.of(context).viewInsets,
                                                      child: AddValue(
                                                        value: value,
                                                        callBackfn: callBackfn,
                                                        points: points, sfid: sfid,
                                                        sfuuid: sfuuid,
                                                      ),
                                                    );
                                                  },
                                                );
                                              },
                                              child: Padding(
                                                padding: const EdgeInsets.only(
                                                    right: 25, top: 10, bottom: 16),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(10),
                                                    color:
                                                        profileCardBackgroundColor,
                                                  ),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.symmetric(
                                                            horizontal: 12,
                                                            vertical: 8),
                                                    child: Text(
                                                      "+ $value",
                                                      style: kalamLight,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            );
                                          }
                                        ),
                                      )),
                              ])),
              ),
            ),
          ),
        );
      });
    },
  );
}
