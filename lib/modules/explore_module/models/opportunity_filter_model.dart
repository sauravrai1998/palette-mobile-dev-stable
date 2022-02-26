class OpportunityEventFilterModel {
  final String title;
  final String icon;
  final String category;
  bool isSelected;

  OpportunityEventFilterModel({
    required this.title,
    required this.icon,
    required this.isSelected,
    required this.category,
  });
}

var eventTypeFilterModelList = [
  OpportunityEventFilterModel(
    icon: 'images/todo_sports.svg',
    title: 'Sports',
    category: 'Event - Sports',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/todo_social.svg',
    title: 'Social',
    category: 'Event - Social',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/todo_arts.svg',
    title: 'Art',
    category: 'Event - Arts',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/todo_volunteer.svg',
    title: 'Volunteer',
    category: 'Event - Volunteer',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/generic.svg',
    title: 'Generic',
    category: 'Other',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/todo_education.svg',
    title: 'Education',
    category: 'Education',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
      title: 'Employment',
      icon: 'images/employment.svg',
      isSelected: false,
      category: 'Employment'),
  // OpportunityEventFilterModel(
  //   icon: 'images/todo_education.svg',
  //   title: 'College Applications',
  //   category: '',
  //   isSelected: false,
  // ),
  // OpportunityEventFilterModel(
  //   icon: 'images/todo_business.svg',
  //   title: 'Job Applications',
  //   category: '',
  //   isSelected: false,
  // ),
];

final freshEventFilterList = [
  OpportunityEventFilterModel(
    icon: 'images/todo_sports.svg',
    title: 'Sports',
    category: 'Event - Sports',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/todo_social.svg',
    title: 'Social',
    category: 'Event - Social',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/todo_arts.svg',
    title: 'Art',
    category: 'Event - Arts',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/todo_volunteer.svg',
    title: 'Volunteer',
    category: 'Event - Volunteer',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/generic.svg',
    title: 'Generic',
    category: 'Other',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
    icon: 'images/todo_education.svg',
    title: 'Education',
    category: 'Education',
    isSelected: false,
  ),
  OpportunityEventFilterModel(
      title: 'Employment',
      icon: 'images/employment.svg',
      isSelected: false,
      category: 'Employment'),
  // OpportunityEventFilterModel(
  //   icon: 'images/todo_education.svg',
  //   title: 'College Applications',
  //   category: '',
  //   isSelected: false,
  // ),
  // OpportunityEventFilterModel(
  //   icon: 'images/todo_business.svg',
  //   title: 'Job Applications',
  //   category: '',
  //   isSelected: false,
  // ),
];
