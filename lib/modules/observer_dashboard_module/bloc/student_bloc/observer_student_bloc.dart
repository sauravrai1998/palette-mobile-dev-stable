import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/observer_dashboard_module/bloc/student_bloc/observer_student_events.dart';

import 'package:palette/modules/observer_dashboard_module/bloc/student_bloc/observer_student_states.dart';
import 'package:palette/modules/observer_dashboard_module/services/observer_repository.dart';

class ObserverStudentBloc extends Bloc<StudentEvent, ObserverStudentState> {
  final ObserverRepository observerRepo;

  ObserverStudentBloc({required this.observerRepo})
      : super((InitialUserState()));

  @override
  Stream<ObserverStudentState> mapEventToState(StudentEvent event) async* {
    if (event is ObserverGetStudentUser) {
      yield StudentUserLoadingState();
      try {
        final student = await observerRepo.getStudentData();

        yield StudentUserSuccessState(observerStudentsMentorsList: student);
      } catch (e) {
        print(e);
        yield StudentUserFailedState(error: e.toString());
      }
    }
  }
}
