//Send Feedback states
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/app_info/models/app_info_model.dart';
import 'package:palette/modules/app_info/services/app_info_repo.dart';

abstract class SendFeedbackState {}

class SendFeedbackInitialState extends SendFeedbackState {}

class SendFeedbackSuccess extends SendFeedbackState {}

class SendFeedbackLoading extends SendFeedbackState {}

class SendFeedbackFailed extends SendFeedbackState {
  final String error;
  SendFeedbackFailed({required this.error});
}

//Send Feedback events
abstract class SendFeedbackEvent {}

class SendFeedbackClicked extends SendFeedbackEvent {
  final FeedbackModel feedbackModel;

  SendFeedbackClicked(this.feedbackModel);
}

//Send Feedback Bloc
class SendFeedbackBloc extends Bloc<SendFeedbackEvent, SendFeedbackState> {
  SendFeedbackBloc() : super(SendFeedbackInitialState());

  @override
  Stream<SendFeedbackState> mapEventToState(SendFeedbackEvent event) async*{
     if (event is SendFeedbackClicked) {
      yield SendFeedbackLoading();
      try {
        print('App Info Send Feedback Bloc');
        await AppInfoRepo.sendFeeback(event.feedbackModel);
          yield SendFeedbackSuccess();
        
      } catch (e) {
        yield SendFeedbackFailed(error: e.toString());
      }
    }
  }
}
