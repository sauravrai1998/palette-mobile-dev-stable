import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

class RecommendationBulkShareEvent {

  final List<String> oppIds;
  final List<String> userIds; 
  RecommendationBulkShareEvent({required this.oppIds, required this.userIds});
}


///
/// States
///
abstract class RecommendationBulkShareState {}

/// Initial Opportunity Bulk state
class RecommendationBulkInitialShareState extends RecommendationBulkShareState {}

/// Recommendation Bulk Share States
class RecommendationBulkShareSuccessState extends RecommendationBulkShareState {}

class RecommendationBulkShareLoadingState extends RecommendationBulkShareState {}

class RecommendationBulkShareFailedState extends RecommendationBulkShareState {
  final String err;
  RecommendationBulkShareFailedState({required this.err});
}

///
///Bloc
///
class RecommendationBulkShareBloc
    extends Bloc<RecommendationBulkShareEvent, RecommendationBulkShareState> {
  RecommendationBulkShareBloc() : super((RecommendationBulkInitialShareState()));

  @override
  Stream<RecommendationBulkShareState> mapEventToState(
      RecommendationBulkShareEvent event) async* {
    if (event is RecommendationBulkShareEvent) {
      yield RecommendationBulkShareLoadingState();
      try {
        await OpportunityRepository.instance.opportunityBulkShare(
          event.oppIds,
          event.userIds,
        );
        yield RecommendationBulkShareSuccessState();
      } catch (e) {
        print(e);
        yield RecommendationBulkShareFailedState(err: e.toString());
      }
    }
  }
}
