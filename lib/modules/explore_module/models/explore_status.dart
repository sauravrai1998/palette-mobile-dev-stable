enum ExploreStatus {
  Enrolled,
  Recommended,
  Disinterest,
  CantShare,
  Open,
}

extension ExploreStatusExtension on ExploreStatus {
  String get name {
    switch (this) {
      case ExploreStatus.Enrolled:
        return 'Enrolled';
      case ExploreStatus.Recommended:
        return 'Recommended';
      case ExploreStatus.Disinterest:
        return 'Expressed disinterest';
      case ExploreStatus.CantShare:
        return 'Can\'t share';
      case ExploreStatus.Open:
        return 'Open';
    }
  }

  String get value {
    switch (this) {
      case ExploreStatus.Enrolled:
        return 'Enrolled';
      case ExploreStatus.Recommended:
        return 'Recommended';
      case ExploreStatus.Disinterest:
        return 'Disinterest';
      case ExploreStatus.CantShare:
        return "Can't Share";
      case ExploreStatus.Open:
        return 'Open';
    }
  }
}
