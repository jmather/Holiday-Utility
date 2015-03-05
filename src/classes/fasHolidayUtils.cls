public with sharing class fasHolidayUtils {
    public static List<Holiday> usHolidayList {
        get {
            if (usHolidayList == null) {
                usHolidayList = [SELECT activityDate, name, IsRecurrence, RecurrenceType,
                                        RecurrenceStartDate, recurrencedayofmonth, recurrencedayofweekmask,
                                        RecurrenceInstance, RecurrenceMonthOfYear
                                   FROM Holiday
                                  WHERE RecurrenceType = 'RecursYearly' OR RecurrenceType = 'RecursYearlyNth'
                               ORDER BY activityDate LIMIT 2000];
            }
            return usHolidayList;
        }
        set; 
    }
    public static Map<Date, String> usHolidayMap {
        get {
            if (usHolidayMap == null) {
                usHolidayMap = new Map<Date, String>();
                Map<Date, Holiday> monthMap = new Map<Date, Holiday>();
                Date lastDayOfMonth; // Last Day of Month
                Integer month = 01;
                Date nextHolidayDate;
                Datetime nextHolidayDateTime;
                Integer nYearsAgo   = (system.now().addYears(-7)).year();
                Integer nYearsAhead = (system.now().addYears(7)).year()+1;
                Integer MONinstances, TUEinstances, WEDinstances, THUinstances, FRIinstances, SATinstances, SUNinstances;
                for (Holiday h: usHolidayList) {
                    system.debug('HOLIDAY='+h.activityDate);
                    if (! h.IsRecurrence) { usHolidayMap.put(h.activityDate, h.name); continue; }
                    if (h.RecurrenceMonthOfYear=='January')         { month=01; }
                    else if (h.RecurrenceMonthOfYear=='February')   { month=02; }
                    else if (h.RecurrenceMonthOfYear=='March')      { month=03; }
                    else if (h.RecurrenceMonthOfYear=='April')      { month=04; }
                    else if (h.RecurrenceMonthOfYear=='May')        { month=05; }
                    else if (h.RecurrenceMonthOfYear=='June')       { month=06; }
                    else if (h.RecurrenceMonthOfYear=='July')       { month=07; }
                    else if (h.RecurrenceMonthOfYear=='August')     { month=08; }
                    else if (h.RecurrenceMonthOfYear=='September')  { month=09; }
                    else if (h.RecurrenceMonthOfYear=='October')    { month=10; }
                    else if (h.RecurrenceMonthOfYear=='November')   { month=11; }
                    else if (h.RecurrenceMonthOfYear=='December')   { month=12; }
                    // For Recurring Fixed Holidays for Americans ...
                    //     If it falls on a Saturday, it is observed on the Friday before.
                    //     Or, if falls on a Sunday, it is observed on the following Monday.
                    //     SF supported dates: 1700-01-01T00:00:00Z GMT thru 4000-12-31T00:00:00Z GMT
                    if (h.RecurrenceType=='RecursYearly') {
                        for (Integer thisYear=nYearsAgo; thisYear<nYearsAhead; thisYear++) {
                            usHolidayMap.put(Date.newInstance(thisYear, month, h.recurrencedayofmonth),h.Name);
                            if ((DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).format('EEE')=='Sat') {
                                // nextHolidayDateTime=(DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).addDays(-1);
                                // usHolidayMap.put( (date.newInstance(nextHolidayDateTime.year(),nextHolidayDateTime.month(),nextHolidayDateTime.day())),h.Name);
                                usHolidayMap.put( (date.newInstance(((DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).addDays(-1)).year(),((DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).addDays(-1)).month(),((DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).addDays(-1)).day())),h.Name);
                            } else if ((DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).format('EEE')=='Sun') {
                                // nextHolidayDateTime=(DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).addDays(1);
                                // usHolidayMap.put( (date.newInstance(nextHolidayDateTime.year(),nextHolidayDateTime.month(),nextHolidayDateTime.day())),h.Name);
                                usHolidayMap.put( (date.newInstance(((DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).addDays(1)).year(),((DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).addDays(1)).month(),((DateTime.newInstance(thisYear, month, h.recurrencedayofmonth)).addDays(1)).day())),h.Name);
                            }
                        } // for all 14 years
                    } else { // RecursYearlyNth
                        //  RecurrenceInstance = First,Second,Third,Fourth,Last
                        //  RecurrenceDayOfWeekMask =
                        //      Sunday=1, Monday=2, Tuesday=4, Wednesday=8, Thursday=16, Friday=32, Saturday=64
                        //      Every Day = 127
                        //  RecurrenceMonthOfYear = January,February,March .... December
                        //  RecurrenceInterval = used as temp field to store occurrence instance
                        for (Integer thisYear=nYearsAgo; thisYear<nYearsAhead; thisYear++) {
                            MONinstances=0; TUEinstances=0; WEDinstances=0; THUinstances=0; FRIinstances=0; SATinstances=0; SUNinstances=0;
                            Date calendarDate = Date.newInstance(thisYear, month, 1);   // First Day of Month
                            monthMap = new Map<Date, Holiday>();
                            do { // scan all the days for the month
                                Holiday cD = new Holiday();
                                cD.activityDate=calendarDate;
                                if ( (DateTime.newInstance(calendarDate.year(), calendarDate.month(), calendarDate.day())).format('EEE')=='Sun') {
                                    cD.recurrenceinterval=++SUNinstances;
                                    cD.RecurrenceDayOfWeekMask=1;
                                } else if ( (DateTime.newInstance(calendarDate.year(), calendarDate.month(), calendarDate.day())).format('EEE')=='Mon') {
                                    cD.recurrenceinterval=++MONinstances;
                                    cD.RecurrenceDayOfWeekMask=2;
                                } else if ( (DateTime.newInstance(calendarDate.year(), calendarDate.month(), calendarDate.day())).format('EEE')=='Tue') {
                                    cD.recurrenceinterval=++TUEinstances;
                                    cD.RecurrenceDayOfWeekMask=4;
                                } else if ( (DateTime.newInstance(calendarDate.year(), calendarDate.month(), calendarDate.day())).format('EEE')=='Wed') {
                                    cD.recurrenceinterval=++WEDinstances;
                                    cD.RecurrenceDayOfWeekMask=8;
                                } else if ( (DateTime.newInstance(calendarDate.year(), calendarDate.month(), calendarDate.day())).format('EEE')=='Thu') {
                                    cD.recurrenceinterval=++THUinstances;
                                    cD.RecurrenceDayOfWeekMask=16;
                                } else if ( (DateTime.newInstance(calendarDate.year(), calendarDate.month(), calendarDate.day())).format('EEE')=='Fri') {
                                    cD.recurrenceinterval=++FRIinstances;
                                    cD.RecurrenceDayOfWeekMask=32;
                                } else if ( (DateTime.newInstance(calendarDate.year(), calendarDate.month(), calendarDate.day())).format('EEE')=='Sat') {
                                    cD.recurrenceinterval=++SATinstances;
                                    cD.RecurrenceDayOfWeekMask=64;
                                }
                                monthMap.put(calendarDate,cD);
                                if (calendarDate.day()>=28)  {
                                   lastDayOfmonth=calendarDate;    // will contain last Day if loop ends
                                }
                                calendarDate=calendarDate.addDays(1);
                            } while (calendarDate.month()==month);
                            // Identify the holiday
                            if (h.RecurrenceDayOfWeekMask!=127) {
                                for (Holiday dS : monthMap.values()) { // keep only desired DayOfWeek
                                    if (h.RecurrenceDayOfWeekMask!=dS.RecurrenceDayOfWeekMask) { monthMap.remove(dS.activitydate); }
                                }
                            }
                            Integer whichInstance = monthMap.size();  // 'Last' instance
                            if (h.RecurrenceInstance=='First')       { whichInstance=1; }
                            else if (h.RecurrenceInstance=='Second') { whichInstance=2; }
                            else if (h.RecurrenceInstance=='Third')  { whichInstance=3; }
                            else if (h.RecurrenceInstance=='Fourth') { whichInstance=4; }
                            if (whichInstance>4) { // Last Day of the Month
                                usHolidayMap.put(lastDayOfMonth,h.Name);
                            } else {
                                for (Holiday dS : monthMap.values()) {
                                    if (whichInstance==dS.recurrenceinterval) { usHolidayMap.put(dS.activityDate,h.Name); continue; }
                                }
                            }
                        }  // for all 14 years
                    }   // end of RecursYearlyNth
                } // for usHolidayList
            }  // if map == null
            return usHolidayMap;
        } // get
        set;
    }
}