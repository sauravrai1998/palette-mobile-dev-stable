/// FilterCheckboxOption
enum FilterCheckboxOption {
  Applications,
  Events,
  ListedBy,
  Education,
  Employment,
  Other,
}

extension FilterCheckboxOptionExtension on FilterCheckboxOption {
  String get name {
    switch (this) {
      case FilterCheckboxOption.Employment:
        return 'Employment';
      case FilterCheckboxOption.Applications:
        return 'Applications';
      case FilterCheckboxOption.Events:
        return 'Events';
      case FilterCheckboxOption.ListedBy:
        return 'ListedBy';
      case FilterCheckboxOption.Education:
        return 'Education';
      case FilterCheckboxOption.Other:
        return 'Other';
    }
  }
}

enum FilterCheckboxApplicationsOption {
  College,
  Job,
}

extension FilterCheckboxApplicationsOptionExtension
    on FilterCheckboxApplicationsOption {
  String get name {
    switch (this) {
      case FilterCheckboxApplicationsOption.College:
        return 'College';
      case FilterCheckboxApplicationsOption.Job:
        return 'Job';
    }
  }
}

enum FilterCheckboxEventsOption {
  Art,
  Social,
  Sports,
  Volunteer,
}

extension FilterCheckboxEventsOptionExtension on FilterCheckboxEventsOption {
  String get name {
    switch (this) {
      case FilterCheckboxEventsOption.Art:
        return 'Art';
      case FilterCheckboxEventsOption.Social:
        return 'Social';
      case FilterCheckboxEventsOption.Sports:
        return 'Sports';
      case FilterCheckboxEventsOption.Volunteer:
        return 'Volunteer';
    }
  }
}

///
class FilterCheckboxHeadingModel {
  FilterCheckboxOption title;
  bool isCheck;
  List<FilterCheckboxSubCategoryModel>? subCategories;

  FilterCheckboxHeadingModel({
    required this.title,
    required this.isCheck,
    this.subCategories,
  });
}

class FilterCheckboxSubCategoryModel {
  String title;
  bool isCheck;

  FilterCheckboxSubCategoryModel({
    required this.title,
    required this.isCheck,
  });
}

List<FilterCheckboxHeadingModel> getFilterCheckboxHeadingList(
    {required List<String> listedByNames}) {
  print('listedByNames: $listedByNames');
  return <FilterCheckboxHeadingModel>[
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Education,
      isCheck: false,
    ),
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Employment,
      isCheck: false,
    ),
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Applications,
      isCheck: false,
      subCategories: [
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxApplicationsOption.College.name,
          isCheck: false,
        ),
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxApplicationsOption.Job.name,
          isCheck: false,
        ),
      ],
    ),
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Events,
      isCheck: false,
      subCategories: [
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxEventsOption.Art.name,
          isCheck: false,
        ),
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxEventsOption.Social.name,
          isCheck: false,
        ),
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxEventsOption.Sports.name,
          isCheck: false,
        ),
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxEventsOption.Volunteer.name,
          isCheck: false,
        ),
      ],
    ),
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Other,
      isCheck: false,
    ),
    FilterCheckboxHeadingModel(
        title: FilterCheckboxOption.ListedBy,
        isCheck: false,
        subCategories: listedByNames
            .map(
                (e) => FilterCheckboxSubCategoryModel(title: e, isCheck: false))
            .toList()),
  ];
}

List<FilterCheckboxHeadingModel>
    getFilterCheckboxHeadingListForParentAndAdvisor(
        {List<String> listedByNames = const []}) {
  return <FilterCheckboxHeadingModel>[
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Education,
      isCheck: false,
    ),
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Employment,
      isCheck: false,
    ),
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Applications,
      isCheck: false,
      subCategories: [
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxApplicationsOption.College.name,
          isCheck: false,
        ),
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxApplicationsOption.Job.name,
          isCheck: false,
        ),
      ],
    ),
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Events,
      isCheck: false,
      subCategories: [
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxEventsOption.Art.name,
          isCheck: false,
        ),
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxEventsOption.Social.name,
          isCheck: false,
        ),
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxEventsOption.Sports.name,
          isCheck: false,
        ),
        FilterCheckboxSubCategoryModel(
          title: FilterCheckboxEventsOption.Volunteer.name,
          isCheck: false,
        ),
      ],
    ),
    FilterCheckboxHeadingModel(
      title: FilterCheckboxOption.Other,
      isCheck: false,
    ),
    FilterCheckboxHeadingModel(
        title: FilterCheckboxOption.ListedBy,
        isCheck: false,
        subCategories: listedByNames
            .map(
                (e) => FilterCheckboxSubCategoryModel(title: e, isCheck: false))
            .toList())
  ];
}
