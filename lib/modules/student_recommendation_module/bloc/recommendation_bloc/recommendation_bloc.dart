import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_event.dart';

import 'package:palette/modules/student_recommendation_module/bloc/recommendation_bloc/recommendation_state.dart';
import 'package:palette/modules/student_recommendation_module/services/recommendation_repository.dart';

class RecommendationBloc
    extends Bloc<RecommendationEvent, RecommendationState> {
  final RecommendRepository recommendRepo;

  RecommendationBloc({required this.recommendRepo})
      : super((InitialRecommendState()));

  @override
  Stream<RecommendationState> mapEventToState(
      RecommendationEvent event) async* {
    if (event is GetRecommendation) {
      yield RecommendationLoadingState();
      try {
        final recommendationList = await recommendRepo.getRecommendation();

        yield RecommendationSuccessState(
            recommendationList: recommendationList);
      } catch (e) {
        print(e);
        yield RecommendationFailedState(error: e.toString());
      }
    }
  }
}
