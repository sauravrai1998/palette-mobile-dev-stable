import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/models/recipients_response.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';

abstract class GetRecipientsState {}

class GetRecipientsInitialState extends GetRecipientsState {}

class GetRecipientsLoadingState extends GetRecipientsState {}

class GetRecipientsSuccessState extends GetRecipientsState {
  final RecipientsResponse recipientsResponse;
  GetRecipientsSuccessState({required this.recipientsResponse});
}

class GetRecipientsFailureState extends GetRecipientsState {
  final String errorMessage;

  GetRecipientsFailureState(this.errorMessage);
}

abstract class GetRecipientsEvent {}

class GetRecipientsForOpportunityEvent extends GetRecipientsEvent {
}

class GetRecipientsBloc extends Bloc<GetRecipientsEvent, GetRecipientsState> {
  GetRecipientsBloc(GetRecipientsState initialState)
      : super(GetRecipientsInitialState());

  @override
  Stream<GetRecipientsState> mapEventToState(GetRecipientsEvent event) async* {
    if (event is GetRecipientsForOpportunityEvent) {
      yield GetRecipientsLoadingState();
      try {
      final recipientsResponse = await OpportunityRepository.instance.getAllRecipients();
        yield GetRecipientsSuccessState(recipientsResponse: recipientsResponse);
      } catch (e) {
        yield GetRecipientsFailureState(e.toString());
      }
    }
  }
}
