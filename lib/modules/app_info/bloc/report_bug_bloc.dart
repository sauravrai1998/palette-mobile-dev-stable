import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/app_info/models/app_info_model.dart';
import 'package:palette/modules/app_info/services/app_info_repo.dart';

abstract class ReportBugState {}

class ReportBugInitial extends ReportBugState {}


class ReportBugSuccess extends ReportBugState {}
class ReportBugLoading extends ReportBugState {}
class ReportBugFailed extends ReportBugState {
  final String error;
  ReportBugFailed({required this.error});
}


abstract class ReportBugEvent {}


class ReportBugClicked extends ReportBugEvent {
  final ReportBugModel reportBugModel;

  ReportBugClicked(this.reportBugModel);
}

class ReportBugBloc extends Bloc<ReportBugEvent, ReportBugState> {
  ReportBugBloc() : super(ReportBugInitial());

  @override
  Stream<ReportBugState> mapEventToState(event) async* {
    if (event is ReportBugClicked) {
      yield ReportBugLoading();
      try {
        print('App Info Report Bug Bloc');
        await AppInfoRepo.reportBug(event.reportBugModel);
          yield ReportBugSuccess();
        
      } catch (e) {
        yield ReportBugFailed(error: e.toString());
      }
    }
  }
}
