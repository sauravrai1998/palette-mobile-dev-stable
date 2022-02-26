int getHashCode(DateTime key) {
  return key.day * 1000000 + key.month * 10000 + key.year;
}

int startingYear = 2019;
int endingYear = DateTime.now().year + 3;
final kToday = DateTime.now();
final kFirstDay = DateTime(startingYear, 1, 1);
final kLastDay = DateTime(endingYear, 12, 31);

final kYearsList = [for (var i = startingYear; i <= endingYear; i++) i];
final kMonthsList = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'June',
  'July',
  'Aug',
  'Sept',
  'Oct',
  'Nov',
  'Dec'
];
