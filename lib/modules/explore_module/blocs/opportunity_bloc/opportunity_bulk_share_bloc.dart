import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

class OpportunityBulkShareEvent {

  final List<String> oppIds;
  final List<String> userIds; 
  OpportunityBulkShareEvent({required this.oppIds, required this.userIds});
}


///
/// States
///
abstract class OpportunityBulkShareState {}

/// Initial Opportunity Bulk state
class OpportunityBulkInitialShareState extends OpportunityBulkShareState {}

/// Opportunity Bulk Share States
class OpportunityBulkShareSuccessState extends OpportunityBulkShareState {}

class OpportunityBulkShareLoadingState extends OpportunityBulkShareState {}

class OpportunityBulkShareFailedState extends OpportunityBulkShareState {
  final String err;
  OpportunityBulkShareFailedState({required this.err});
}

///
///Bloc
///
class OpportunityBulkShareBloc
    extends Bloc<OpportunityBulkShareEvent, OpportunityBulkShareState> {
  OpportunityBulkShareBloc() : super((OpportunityBulkInitialShareState()));

  @override
  Stream<OpportunityBulkShareState> mapEventToState(
      OpportunityBulkShareEvent event) async* {
    if (event is OpportunityBulkShareEvent) {
      yield OpportunityBulkShareLoadingState();
      try {
        await OpportunityRepository.instance.opportunityBulkShare(
          event.oppIds,
          event.userIds,
        );
        yield OpportunityBulkShareSuccessState();
      } catch (e) {
        print(e);
        yield OpportunityBulkShareFailedState(err: e.toString());
      }
    }
  }
}
