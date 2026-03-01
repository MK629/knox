import 'package:flutter/material.dart';

class KnoxDateUtil {

  static DateTime nextMonth(DateTime lifeDutylatestUpdate, DateTime lifeDutyStartDate){
    bool startOnFinalDay = false;

    int year = lifeDutylatestUpdate.year;
    int month = lifeDutylatestUpdate.month + 1;
    int day = lifeDutyStartDate.day;

    if(month > 12){
      year += 1;
      month = month - 12;
    }

    if(isMonthFeb(lifeDutyStartDate.month) && 
      (
        (isLeapYear(lifeDutyStartDate.year) && lifeDutyStartDate.day == 29) 
        || 
        (!isLeapYear(lifeDutyStartDate.year) && lifeDutyStartDate.day == 28)
      )
    ){
      startOnFinalDay = true;
    }
    else if(isThirtyDayMonth(lifeDutyStartDate.month) && lifeDutyStartDate.day == 30){
      startOnFinalDay = true;
    }
    else if(!isThirtyDayMonth(lifeDutyStartDate.month) && lifeDutyStartDate.day == 31){
      startOnFinalDay = true;
    }

    //If it's supposed to start on final day.
    if(startOnFinalDay){
      if(isMonthFeb(month)){
        day = isLeapYear(year) ? 29 : 28;
      }
      else if(isThirtyDayMonth(month)){
        day = 30;
      }
      else{
        day = 31;
      }
    }
    //If not, clamp february to prevent January 29,30,31 scenarios.
    else if(isMonthFeb(month) && day >= 29){
      day = isLeapYear(year) ? 29 : 28;
    }

    return DateTime(
      year,
      month,
      day
    );
  }

  static bool isMoreThanOrIsOneMonthDiff(DateTime lifeDutylatestUpdate, DateTime today, DateTime lifeDutyStartDate){
    DateTime oneMonthAfter = nextMonth(lifeDutylatestUpdate, lifeDutyStartDate);
    return today.isAfter(oneMonthAfter) || DateUtils.isSameDay(oneMonthAfter, today);
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

  static DateTime nextYear(DateTime lifeDutylatestUpdate, DateTime lifeDutyStartDate){

    int year = lifeDutylatestUpdate.year + 1;
    int month = lifeDutyStartDate.month;
    int day = lifeDutyStartDate.day;

    if(isMonthFeb(month) && day == 29 && !isLeapYear(year)){
      day = 28;
    }

    return DateTime(
      year,
      month,
      day
    );
  }

  static bool isMoreThanOrIsOneYearDiff(DateTime lifeDutylatestUpdate, DateTime today, DateTime lifeDutyStartDate){
    DateTime oneYearAfter = nextYear(lifeDutylatestUpdate, lifeDutyStartDate);
    return today.isAfter(oneYearAfter) || DateUtils.isSameDay(oneYearAfter, today);
  }
}