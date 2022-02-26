import 'package:flutter_bloc/flutter_bloc.dart';



class NavBarChangeIndexEvent {
  final int index;
  NavBarChangeIndexEvent({required this.index});
}

class NavBarChangeIndexState {
  final int index;
  NavBarChangeIndexState({required this.index});
}

class NavBarChangeIndexBloc extends Bloc<NavBarChangeIndexEvent, NavBarChangeIndexState> {
  NavBarChangeIndexBloc() : super((NavBarChangeIndexState(index:0)));

  @override
  Stream<NavBarChangeIndexState> mapEventToState(NavBarChangeIndexEvent event) async* {
    if(event is NavBarChangeIndexEvent) {
      yield NavBarChangeIndexState(index: event.index);
    }
  }
}
