enum TodoStatus {
  Open,
  Completed,
  Closed,
  Draft,
  Removed
}

extension TodoStatusExtension on TodoStatus {
  String get name {
    switch (this) {
      case TodoStatus.Open:
        return 'Open';
      case TodoStatus.Completed:
        return 'Completed';
      case TodoStatus.Closed:
        return 'Closed';
      case TodoStatus.Draft:
        return 'Draft';
      case TodoStatus.Removed:
        return 'Removed';
    }
  }
}
