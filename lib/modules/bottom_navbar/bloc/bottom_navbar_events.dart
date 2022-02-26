abstract class BottomNavbarEvent {}

class InitialBottomNavbarEvent extends BottomNavbarEvent {}

class GetBottomNavbarIndexValue extends BottomNavbarEvent {
  int indexValue;

  GetBottomNavbarIndexValue({required this.indexValue});
}
