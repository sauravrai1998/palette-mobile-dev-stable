//Hide Bottom navbar bloc

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class HideNavbarState {}

class HideNavbarInitialState extends HideNavbarState {}

class ShowBottomNavbarState extends HideNavbarState {}

class HideBottomNavbarState extends HideNavbarState {}

abstract class HideNavbarEvent {}

class ShowBottomNavbarEvent extends HideNavbarEvent {}

class HideBottomNavbarEvent extends HideNavbarEvent {}

class HideNavbarBloc extends Bloc<HideNavbarEvent, HideNavbarState> {
  HideNavbarBloc() : super((HideNavbarInitialState()));
  @override
  Stream<HideNavbarState> mapEventToState(HideNavbarEvent event) async*{
    if (event is ShowBottomNavbarEvent) {
      yield (ShowBottomNavbarState());
    }
    if (event is HideBottomNavbarEvent) {
      yield (HideBottomNavbarState());
    }

  }
}
