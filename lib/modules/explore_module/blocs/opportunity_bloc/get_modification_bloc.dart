import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/explore_module/models/modification_request_model.dart';
import 'package:palette/modules/explore_module/services/opportunity_repository.dart';


abstract class ModificationDetailEvent {}

class FetchModificationDetail extends ModificationDetailEvent {
  final String modificationId;
  FetchModificationDetail(this.modificationId,);
}

abstract class ModificationDetailState {}

class ModificationDetailInitialState extends ModificationDetailState {}

class FetchModificationDetailLoadingState extends ModificationDetailState {}
class FetchModificationDetailSuccessState extends ModificationDetailState {
 ModificationRequestResponse modification;
  FetchModificationDetailSuccessState({required this.modification});
}

class FetchModificationDetailFailureState extends ModificationDetailState {
  final String error;
  FetchModificationDetailFailureState(this.error);
}
class ModificationDetailBloc extends Bloc<ModificationDetailEvent, ModificationDetailState> {

  final OpportunityRepository opportunityRepository;

  ModificationDetailBloc({required this.opportunityRepository})
      : super((ModificationDetailInitialState()));

  @override
  Stream<ModificationDetailState> mapEventToState(ModificationDetailEvent event) async*{

    if (event is FetchModificationDetail) {
      yield FetchModificationDetailLoadingState();
      try {
        print('fetching');
        var modification = await opportunityRepository.getModificationDetail(modificationId: event.modificationId);
        print(modification);
        yield FetchModificationDetailSuccessState(modification: modification);
      } catch (e) {
        yield FetchModificationDetailFailureState(e.toString());
      }
    }
    // throw UnimplementedError();
  }
}
