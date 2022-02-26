import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/common_blocs/pendo_meta_data_bloc.dart';
import 'package:palette/modules/explore_module/blocs/get_my_creations_bloc/get_my_creations_bloc.dart';
import 'package:palette/modules/explore_module/screens/create_opportunity_page.dart';
import 'package:palette/modules/explore_module/screens/created_by_me_screen.dart';
import 'package:palette/modules/explore_module/services/explore_pendo_repo.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_bloc.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_event.dart';
import 'package:palette/modules/student_recommendation_module/screens/recommendation_screen.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_pendo_repo.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';
import 'package:palette/utils/konstants.dart';

class MoreOptionsPopupMenu extends StatelessWidget {
  const MoreOptionsPopupMenu({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.transparent,
            ),
          ),
          Positioned(
            top: MediaQuery.of(context).size.height * 0.022,
            right: 10,
            child: Container(
              width: 224,
              decoration: BoxDecoration(
                color: defaultDark,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Column(
                children: [
                  SizedBox(height: 15),
                  Text('More options',
                      style: roboto700.copyWith(
                          color: Colors.white, fontSize: 17)),
                  SizedBox(height: 15),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      children: [
                        optionsItem(
                          title: 'Create Opportunity',
                          subtitle:
                              'Found an opportunity? Share with your peers',
                          onTap: () {
                            Navigator.of(context).pushReplacement(
                              MaterialPageRoute(
                                builder: (c) => CreateOpportunityPage(),
                              ),
                            );
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Divider(
                            color: Color(0xFF465562),
                            thickness: 2,
                            height: 2,
                            indent: 54,
                            endIndent: 56,
                          ),
                        ),
                        pendoState.role == 'Student'
                            ? optionsItem(
                                title: 'My Creations',
                                subtitle:
                                    'Looking for an opportunity you created?',
                                onTap: () {
                                  final bloc =
                                      BlocProvider.of<GetMyCreationsBloc>(
                                          context);
                                  bloc.add(GetMyCreationsFetchEvent());

                                  /// Pendo log
                                  ///
                                  final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
                                  ExplorePendoRepo.trackViewMyCreationPage(
                                    pendoState: pendoState,
                                  );

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) => OppCreatedByMeScreen(),
                                      ));
                                })
                            : optionsItem(
                                title: 'My Creations',
                                subtitle:
                                    'Looking for an opportunity you created or shared with a student? Find it here.',
                                onTap: () {
                                  final bloc =
                                      BlocProvider.of<GetMyCreationsBloc>(
                                          context);
                                  bloc.add(GetMyCreationsFetchEvent());

                                  /// Pendo log
                                  ///
                                  final pendoState = BlocProvider.of<PendoMetaDataBloc>(context).state;
                                  ExplorePendoRepo.trackViewMyCreationPage(
                                    pendoState: pendoState,
                                  );

                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (c) => OppCreatedByMeScreen(),
                                      ));
                                }),
                        Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              child: Divider(
                                color: Color(0xFF465562),
                                thickness: 2,
                                height: 2,
                                indent: 54,
                                endIndent: 56,
                              ),
                            ),
                            Container(
                              child: optionsItem(
                                  title: 'Considerations',
                                  subtitle: 'View your recommendations here',
                                  onTap: () {
                                    RecommendationPendoRepo
                                        .trackOpenConsiderationPageEvent(
                                      context: context,
                                    );
                                    Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => BlocProvider(
                                                create: (BuildContext context) {
                                                  return RecommendationBloc(
                                                      recommendRepo:
                                                          RecommendRepository
                                                              .instance)
                                                    ..add(GetRecommendation());
                                                },
                                                child:
                                                    RecommendationScreen())));
                                  }),
                            ),
                          ],
                        ),
                        SizedBox(height: 20),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget optionsItem(
      {required String title,
      required String subtitle,
      required Function onTap}) {
    return InkWell(
      onTap: () {
        onTap();
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title,
              style: roboto700.copyWith(color: Colors.white, fontSize: 15)),
          SizedBox(height: 4),
          Text('$subtitle',
              style: robotoTextStyle.copyWith(
                  color: Color(0xFFC0C0C0),
                  fontWeight: FontWeight.w500,
                  fontSize: 12)),
        ],
      ),
    );
  }
}
