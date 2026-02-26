class KnoxDateUtil {

  static DateTime nextMonth(DateTime dateTime, int startDateDay){
    int year = dateTime.year;
    int month = dateTime.month + 1;
    int day = startDateDay;

    if(month > 12){
      year += 1;
      month = month - 12;
    }
    
    if(isMonthFeb(month) && day >= 30){
      day = isLeapYear(year) ? 29 : 28;
    }
    else if(isThirtyDayMonth(month) && day > 30){
      day = 30;
    }

    return DateTime(
      year,
      month,
      day
    );
  }

  static bool isMoreThanOneMonthDiff(DateTime lastUpdate, DateTime today, int startDateDay){
    return today.isAfter(nextMonth(lastUpdate, startDateDay));
  }

  static bool isLeapYear(int year){
    if(year % 4 == 0){
      if(year % 100 != 0){
        return true;
      }
      else{
        if(year % 400 == 0){
          return true;
        }
      }
    }

    return false;
  }

  static bool isMonthFeb(int month){
    return month == 2;
  }

  static bool isThirtyDayMonth(int month){
    return month == 4 || month == 6 || month == 9 || month == 11;
  }
}