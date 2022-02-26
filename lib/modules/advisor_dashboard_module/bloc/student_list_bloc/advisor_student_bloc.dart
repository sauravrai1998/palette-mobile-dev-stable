import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/advisor_dashboard_module/services/advisor_repository.dart';
import 'package:palette/modules/advisor_dashboard_module/bloc/student_list_bloc/advisor_student_events.dart';
import 'package:palette/modules/advisor_dashboard_module/bloc/student_list_bloc/advisor_student_states.dart';

class AdviserStudentBloc
    extends Bloc<AdvisorStudentEvent, AdvisorStudentState> {
  final AdvisorRepository advisorRepo;

  AdviserStudentBloc({required this.advisorRepo})
      : super((AdvisorGetStudentInitialStage()));

  @override
  Stream<AdvisorStudentState> mapEventToState(
      AdvisorStudentEvent event) async* {
    if (event is AdvisorGetStudentUser) {
      yield AdvisorStudentUserLoadingState();
      try {
        final student = await advisorRepo.getStudentData();

        yield AdvisorStudentUserSuccessState(
            advisorStudentsMentorsList: student);
      } catch (e) {
        print(e);
        yield AdvisorStudentUserFailedState(error: e.toString());
      }
    }
  }
}
