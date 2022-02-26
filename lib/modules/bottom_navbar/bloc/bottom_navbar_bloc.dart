import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_events.dart';
import 'package:palette/modules/bottom_navbar/bloc/bottom_navbar_states.dart';

class BottomNavbarBloc extends Bloc<BottomNavbarEvent, BottomNavbarState> {
  BottomNavbarBloc() : super((InitialBottomNavbarState()));

  @override
  Stream<BottomNavbarState> mapEventToState(BottomNavbarEvent event) async* {
    if (event is GetBottomNavbarIndexValue) {
      yield BottomNavbarLoadingState();
      try {
        final navbarIndex = event.indexValue;
        yield BottomNavbarSuccessState(indexValue: navbarIndex);
      } catch (e) {
        print(e);
        yield BottomNavbarFailedState(error: e.toString());
      }
    } else if (event is InitialBottomNavbarEvent) {
      yield InitialBottomNavbarState();
    }
  }
}
