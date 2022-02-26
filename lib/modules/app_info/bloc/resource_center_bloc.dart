import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/app_info/models/app_info_model.dart';
import 'package:palette/modules/app_info/services/app_info_repo.dart';

class GetResourceCenterGuidesEvent {}

abstract class ResourceCenterState {}

class ResourceCenterInitialState extends ResourceCenterState {}

class ResourceCenterGuidesSuccessState extends ResourceCenterState {
  List<ResourceCenterGuides> guideList;
  ResourceCenterGuidesSuccessState({required this.guideList});
}

class ResourceCenterGuidesLoadingState extends ResourceCenterState {}

class ResourceCenterGuidesFailedState extends ResourceCenterState {
  String err;
  ResourceCenterGuidesFailedState({required this.err});
}

class ResourceCenterBloc
    extends Bloc<GetResourceCenterGuidesEvent, ResourceCenterState> {
  ResourceCenterBloc() : super(ResourceCenterInitialState());

  @override
  Stream<ResourceCenterState> mapEventToState(event) async* {
    if (event is GetResourceCenterGuidesEvent) {
      yield ResourceCenterGuidesLoadingState();
      try {
        final guideList = await AppInfoRepo.getResourceCenterList();
        yield ResourceCenterGuidesSuccessState(guideList: guideList);
      } catch (e) {
        yield ResourceCenterGuidesFailedState(err: e.toString());
      }
    }
  }
}
