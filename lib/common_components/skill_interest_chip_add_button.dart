import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/profile_module/services/profile_pendo_repo.dart';
import 'package:palette/modules/profile_module/widgets/add_value.dart';

import 'common_components_link.dart';

class SkillInterestChipAddButton extends StatelessWidget {
  final String? point;
  final Function? callBackfn;
  final List<String?> data;
  final String sfid;
  final String sfuuid;
  
  SkillInterestChipAddButton(
      {required this.point, required this.callBackfn, required this.data, required this.sfid, required this.sfuuid});

  @override
  Widget build(BuildContext context) {
    return Semantics(
      child: Padding(
        padding: const EdgeInsets.only(right: 25, bottom: 13),
        child: BlocBuilder<PendoMetaDataBloc,PendoMetaDataState>(
                builder: (context, pendoState) {
                  return GestureDetector(
                    onTap: () {
                ProfilePendoRepo.trackOpenSheetForAddingValue(pendoState: pendoState, isSkill: false);
                print("called");
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20)),
                  ),
                  isDismissible: true,
                  builder: (BuildContext bc) {
                    return Padding(
                      padding:MediaQuery.of(bc).viewInsets,
                      child: AddValue(
                        value: point!.split(' ')[1],
                        callBackfn: callBackfn,
                        points: data, sfid: sfid, sfuuid: sfuuid,
                      ),
                    );
                  },
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: profileCardBackgroundColor,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    point.toString(),
                    style: kalamLight,
                  ),
                ),
              ),
            );
          }
        ),
      ),
    );
  }
}
