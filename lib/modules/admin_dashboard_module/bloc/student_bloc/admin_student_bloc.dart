import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_events.dart';
import 'package:palette/modules/admin_dashboard_module/bloc/student_bloc/admin_student_states.dart';
import 'package:palette/modules/admin_dashboard_module/services/admin_repository.dart';

class AdminStudentBloc extends Bloc<StudentEvent, AdminStudentState> {
  final AdminRepository adminRepo;

  AdminStudentBloc({required this.adminRepo})
      : super((AdminInitialUserState()));

  @override
  Stream<AdminStudentState> mapEventToState(StudentEvent event) async* {
    if (event is AdminInitStudentUser) {
      yield AdminInitialUserState();
    } else if (event is AdminGetStudentUser) {
      yield StudentUserLoadingState();
      try {
        final student = await adminRepo.getStudentData();
        yield StudentUserSuccessState(adminStudentsMentorsList: student);
      } catch (e) {
        print(e);
        yield StudentUserFailedState(error: e.toString());
      }
    }
  }
}
