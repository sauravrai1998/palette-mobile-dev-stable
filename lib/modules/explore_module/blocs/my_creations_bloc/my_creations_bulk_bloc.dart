import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/models/opp_created_by_me_response.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

abstract class MyCreationsBulkState{}

class MyCreationsBulkInitialState extends MyCreationsBulkState{}
class MyCreationsBulkLoadingState extends MyCreationsBulkState{}
class MyCreationsBulkSuccessState extends MyCreationsBulkState{
  final String message;
  MyCreationsBulkSuccessState({required this.message});
}
class MyCreationsBulkFailedState extends MyCreationsBulkState{
  final String errorMessage;
  MyCreationsBulkFailedState({required this.errorMessage});
}

abstract class MyCreationsBulkEvent{}

class BulkHideMyCreationsEvent extends MyCreationsBulkEvent{
  final OpportunityVisibility visibility;
  final List<String> opportunityIds;
  BulkHideMyCreationsEvent({required this.opportunityIds, required this.visibility});
}

class BulkDeleteMyCreationsEvent extends MyCreationsBulkEvent{
  final List<String> eventIds;
  final String? message;
  BulkDeleteMyCreationsEvent({required this.eventIds,this.message});
}

class MyCreationBulkResetEvent extends MyCreationsBulkEvent{}

class MyCreationsBlukBloc extends Bloc<MyCreationsBulkEvent, MyCreationsBulkState>{
  MyCreationsBlukBloc(MyCreationsBulkState initialState) : super(MyCreationsBulkInitialState());


  Stream<MyCreationsBulkState> mapEventToState(MyCreationsBulkEvent event) async*{
    if(event is BulkHideMyCreationsEvent){
      yield MyCreationsBulkLoadingState();
      try{
        await OpportunityRepository.instance.setBulkOpportunityVisibility(visibilty: event.visibility, opporunityIds: event.opportunityIds);
        yield MyCreationsBulkSuccessState(message: 'Opportunities are Successfully ${event.visibility.name}');
      }catch(e){
        yield MyCreationsBulkFailedState(errorMessage: e.toString());
      }
    }else if(event is BulkDeleteMyCreationsEvent){
      yield MyCreationsBulkLoadingState();
      try{
       await OpportunityRepository.instance.deleteBulkOpportunities(opportunityIds: event.eventIds, message: event.message);
        yield MyCreationsBulkSuccessState(message: 'Opportunities are Successfully removed');
      }catch(e){
        yield MyCreationsBulkFailedState(errorMessage: e.toString());
      }
    } else if(event is MyCreationBulkResetEvent){
      yield MyCreationsBulkInitialState();
      
    }

  }
}