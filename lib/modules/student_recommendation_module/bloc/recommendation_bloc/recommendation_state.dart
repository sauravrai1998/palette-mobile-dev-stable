import 'package:palette/modules/student_recommendation_module/models/user_models/recommendation_model.dart';

abstract class RecommendationState {}

class InitialRecommendState extends RecommendationState {}

///
class GetRecommendInitialStage extends RecommendationState {}

///

/// User Profile Fetching
class RecommendationSuccessState extends RecommendationState {
  Recommendation recommendationList;
  RecommendationSuccessState({required this.recommendationList});
}

class RecommendationFailedState extends RecommendationState {
  String error;

  RecommendationFailedState({required this.error});
}

class RecommendationLoadingState extends RecommendationState {}
