import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/common_components/selected_tick_icon.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';
import 'package:palette/utils/custom_date_formatter.dart';
import 'package:palette/utils/konstants.dart';
class RecommendationListItem extends StatelessWidget {
  const RecommendationListItem({
    Key? key,
    required this.data,
    required this.recomList,
    required this.onTap,
    required this.onLongPress,
  }) : super(key: key);

  final RecommendedByData data;
  final List<RecommendedByData> recomList;
  final Function onTap;
  final Function onLongPress;

  @override
  Widget build(BuildContext context) {
    var uniqueList = data.recommendedBy.map((e) => e.name).toSet();
    data.recommendedBy.retainWhere((x) => uniqueList.remove(x.name));
    return Stack(
      children: [
        Row(
          children: [
            BlocBuilder<PendoMetaDataBloc, PendoMetaDataState>(
                builder: (context, pendoState) {
              return Padding(
                padding: const EdgeInsets.only(left: 16, top: 16, right: 16),
                child: Material(
                  borderRadius: BorderRadius.circular(10),
                  child: GestureDetector(
                    onLongPress: () => onLongPress(),
                    onTap: () => onTap(),
                    child: Center(
                      child: Container(
                          margin: EdgeInsets.only(
                            left: data.isSelected ? 13 : 0,
                            right: 3,
                          ),
                          width: data.isSelected
                              ? MediaQuery.of(context).size.width * 0.84
                              : MediaQuery.of(context).size.width * 0.9,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.15),
                                  blurRadius:data.isSelected ?20: 5,
                                  offset: data.isSelected ? Offset(-1, 1):Offset(0, 1),
                                ),
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8, left: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  data.event!.name ?? '',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: kalamTextStyle.copyWith(
                                      fontWeight: FontWeight.bold, fontSize: 16),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 5,
                                  ),
                                  child: Text(
                                    data.event!.venue ?? '',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    style: montserratNormal.copyWith(
                                        fontSize: 12, color: closedOpac),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(left: 5, top: 4),
                                  child: Text(
                                    CustomDateFormatter.dateIn_DDMMMYYYY(
                                        data.event!.startDate ?? ''),
                                    // data.event!.startDate.toString().substring(0,),
                                    style: montserratNormal.copyWith(
                                        fontSize: 12, color: closedOpac),
                                  ),
                                ),
                                Padding(
                                  padding: data.isSelected
                                      ? EdgeInsets.all(2)
                                      : EdgeInsets.all(8.0),
                                  child: Align(
                                    alignment: Alignment.bottomRight,
                                    child: Column(
                                      children: [
                                        Text(
                                          "Recommended by",
                                          style: montserratNormal.copyWith(
                                              fontSize: 12, color: closedOpac),
                                        ),
                                        Text(
                                          data.recommendedBy.length == 0
                                              ? ""
                                              : data.recommendedBy.length == 1
                                                  ? data.recommendedBy[0].name
                                                  : data.recommendedBy[0].name +
                                                      " & ${data.recommendedBy.length - 1} other",
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                          style: montserratNormal.copyWith(),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          )),
                    ),
                  ),
                ),
              );
            }),
          ],
        ),
        if (data.isSelected)
          Positioned(
            right: 20,
            top: 1.4,
            child: SelectedTickMarkIcon(),
          )
      ],
    );
  }
}
