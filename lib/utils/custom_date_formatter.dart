import 'package:intl/intl.dart';

class CustomDateFormatter {
  static String convertIntoString(String dateTime) {
    //2021-05-10T16:00:00.000+0000
    DateTime date = DateFormat('yyyy-mm-ddThh:mm:ss.000+0000').parse(dateTime);

    String monthName = '';

    switch (date.month) {
      case 1:
        monthName = 'Jan';
        break;
      case 2:
        monthName = 'Feb';
        break;
      case 3:
        monthName = 'Mar';
        break;
      case 4:
        monthName = 'Apr';
        break;
      case 5:
        monthName = 'May';
        break;
      case 6:
        monthName = 'Jun';
        break;
      case 7:
        monthName = 'Jul';
        break;
      case 8:
        monthName = 'Aug';
        break;
      case 9:
        monthName = 'Sep';
        break;
      case 10:
        monthName = 'Oct';
        break;
      case 11:
        monthName = 'Nov';
        break;
      case 10:
        monthName = 'Dec';
        break;
    }
    String theDate = '$monthName, ${date.year}';
    return theDate;
  }

  static String dateIn_DDMMMYYYY(String dateTime) {
    //2021-05-10T16:00:00.000+0000
    DateTime date;
    String theDate;
    if(dateTime != '') {
      date = DateFormat('yyyy-mm-dd').parse(dateTime);

      String monthName = '';

      switch (date.month) {
        case 1:
          monthName = 'Jan';
          break;
        case 2:
          monthName = 'Feb';
          break;
        case 3:
          monthName = 'Mar';
          break;
        case 4:
          monthName = 'Apr';
          break;
        case 5:
          monthName = 'May';
          break;
        case 6:
          monthName = 'Jun';
          break;
        case 7:
          monthName = 'Jul';
          break;
        case 8:
          monthName = 'Aug';
          break;
        case 9:
          monthName = 'Sep';
          break;
        case 10:
          monthName = 'Oct';
          break;
        case 11:
          monthName = 'Nov';
          break;
        case 10:
          monthName = 'Dec';
          break;
      }
      theDate =  '${date.day} $monthName ${date.year}';
    } else
        theDate = '';

    return theDate;
  }

  static String convertDateIntoString(DateTime date) {
    String monthName = '';

    switch (date.month) {
      case 1:
        monthName = 'Jan';
        break;
      case 2:
        monthName = 'Feb';
        break;
      case 3:
        monthName = 'Mar';
        break;
      case 4:
        monthName = 'Apr';
        break;
      case 5:
        monthName = 'May';
        break;
      case 6:
        monthName = 'Jun';
        break;
      case 7:
        monthName = 'Jul';
        break;
      case 8:
        monthName = 'Aug';
        break;
      case 9:
        monthName = 'Sep';
        break;
      case 10:
        monthName = 'Oct';
        break;
      case 11:
        monthName = 'Nov';
        break;
      case 10:
        monthName = 'Dec';
        break;
    }
    String theDate = '$monthName, ${date.year}';
    return theDate;
  }

  static String dateIntoIntoDDMMYY(DateTime date) {
    //2021-05-10T16:00:00.000+0000
    print(date);
    String theDate = DateFormat('dd/MM/yy').format(date);

    return theDate;
  }
  static String dateIntoDDMMYYWithhash(DateTime date) {
    //2021-05-10
    print(date);
    String theDate = DateFormat('yyyy-MM-dd').format(date);

    return theDate;
  }


  static String stringDateIntoDDMMYY(String dateInString) {
    String theDate = '';
    //2021-05-10T16:00:00.000+0000
    // String tempData= date;
    try {
      DateTime date =
          DateFormat('yyyy-mm-ddThh:mm:ss.000+0000').parse(dateInString);
      theDate = DateFormat('dd/MM/yy').format(date);
    } catch (e) {
      DateTime date = DateFormat('yyyy-mm-dd').parse(dateInString);
      theDate = DateFormat('dd/MM/yy').format(date);
    }
    return theDate;
  }
}
