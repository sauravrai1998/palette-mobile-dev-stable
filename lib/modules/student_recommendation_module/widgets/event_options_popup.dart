import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';
import 'package:palette/modules/student_recommendation_module/screens/recommendation_detail_screen.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_pendo_repo.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';
import 'package:palette/utils/helpers.dart';
import 'package:palette/utils/konstants.dart';

class EventOptionsPopup extends StatelessWidget {
  final RecommendedByData recommendation;
  final RejectOpportunityCallBack rejectOpportunityCallBack;

  const EventOptionsPopup({
    Key? key,
    required this.recommendation,
    required this.rejectOpportunityCallBack,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      right: 30,
      bottom: 16 + 45 + 10,
      child: Material(
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(8)),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                offset: Offset(0, 2),
                blurRadius: 8,
                color: Colors.black.withOpacity(0.08),
              )
            ],
          ),
          height: 90,
          width: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  SizedBox(width: 12),
                  SvgPicture.asset('images/conflict_icon.svg'),
                  SizedBox(width: 12),
                  Text(
                    'Raise Conflict',
                    style: robotoTextStyle.copyWith(
                      color: todoListActiveTab,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 12),
              Container(
                height: 1.5,
                width: 30,
                color: Colors.black.withOpacity(0.2),
              ),
              SizedBox(height: 12),
              GestureDetector(
                onTap: () {
                  final pendoState =
                      BlocProvider.of<PendoMetaDataBloc>(context).state;
                  Helper.showAcceptRejectDialog(
                      body:
                          'Are you sure you want to reject this recommendation?',
                      context: context,
                      okAction: () async {
                        bool result = await RecommendRepository.instance
                            .rejectRecommendation(id: recommendation.id);
                        rejectOpportunityCallBack(recommendation);

                        if (result) {
                          RecommendationPendoRepo.trackRejectRecommendation(
                              pendoState: pendoState,
                              event: recommendation.event);
                        }
                        Navigator.pop(context);

                        Navigator.pop(context);
                      },
                      cancel: () {
                        Navigator.pop(context);
                      });
                },
                child: Row(
                  children: [
                    SizedBox(width: 12),
                    SvgPicture.asset('images/dismiss_icon.svg'),
                    SizedBox(width: 12),
                    Text(
                      'Dismiss',
                      style: robotoTextStyle.copyWith(
                        color: todoListActiveTab,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
