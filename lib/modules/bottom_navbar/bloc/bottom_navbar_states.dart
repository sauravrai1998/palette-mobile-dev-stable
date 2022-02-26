abstract class BottomNavbarState {}

class InitialBottomNavbarState extends BottomNavbarState {}

class BottomNavbarSuccessState extends BottomNavbarState {
  int indexValue;

  BottomNavbarSuccessState({required this.indexValue});
}

class BottomNavbarFailedState extends BottomNavbarState {
  String error;

  BottomNavbarFailedState({required this.error});
}

class BottomNavbarLoadingState extends BottomNavbarState {}
