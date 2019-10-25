public with sharing class fasHolidayUtils {
    public static final Integer DAY_SUNDAY = 0;
    public static final Integer DAY_MONDAY = 1;
    public static final Integer DAY_TUESDAY = 2;
    public static final Integer DAY_WEDNESDAY = 3;
    public static final Integer DAY_THURSDAY = 4;
    public static final Integer DAY_FRIDAY = 5;
    public static final Integer DAY_SATURDAY = 6;
    
    public static final Integer MASK_SUNDAY = 1;
    public static final Integer MASK_MONDAY = 2;
    public static final Integer MASK_TUESDAY = 4;
    public static final Integer MASK_WEDNESDAY = 8;
    public static final Integer MASK_THURSDAY = 16;
    public static final Integer MASK_FRIDAY = 32;
    public static final Integer MASK_SATURDAY = 64;


    public static List<Holiday> usHolidayList {
        get {
            if (usHolidayList == null) {
                usHolidayList = [SELECT ActivityDate, Name, IsRecurrence, RecurrenceType,
                                        RecurrenceStartDate, RecurrenceDayOfMonth, RecurrenceDayOfWeekMask,
                                        RecurrenceInstance, RecurrenceMonthOfYear
                                   FROM Holiday
                                  WHERE RecurrenceType = 'RecursYearly' OR RecurrenceType = 'RecursYearlyNth'
                               ORDER BY ActivityDate LIMIT 2000];
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
                Integer nYearsAgo   = (System.now().addYears(-7)).year();
                Integer nYearsAhead = (System.now().addYears(7)).year()+1;
                Integer MonInstances = 0, TueInstances = 0, WedInstances = 0, ThuInstances = 0, FriInstances = 0, SatInstances = 0, SunInstances = 0;

                for (Holiday h: usHolidayList) {
                    System.debug('HOLIDAY='+h.ActivityDate);
                    if (! h.IsRecurrence) { usHolidayMap.put(h.ActivityDate, h.Name); continue; }
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
                            usHolidayMap.put(Date.newInstance(thisYear, month, h.RecurrenceDayOfMonth),h.Name);
                            if (dayOfWeek(Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)) == DAY_SATURDAY) {
                                // nextHolidayDateTime=(Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)).addDays(-1);
                                // usHolidayMap.put( (Date.newInstance(nextHolidayDatetime.year(),nextHolidayDatetime.month(),nextHolidayDatetime.day())),h.Name);
                                usHolidayMap.put( (Date.newInstance(((Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)).addDays(-1)).year(),((Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)).addDays(-1)).month(),((Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)).addDays(-1)).day())),h.Name);
                            } else if (dayOfWeek(Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)) == DAY_SUNDAY) {
                                // nextHolidayDateTime=(Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)).addDays(1);
                                // usHolidayMap.put( (Date.newInstance(nextHolidayDatetime.year(),nextHolidayDatetime.month(),nextHolidayDatetime.day())),h.Name);
                                usHolidayMap.put( (Date.newInstance(((Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)).addDays(1)).year(),((Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)).addDays(1)).month(),((Datetime.newInstance(thisYear, month, h.RecurrenceDayOfMonth)).addDays(1)).day())),h.Name);
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
                            MonInstances = 0; TueInstances = 0; WedInstances = 0; ThuInstances = 0; FriInstances = 0; SatInstances = 0; SunInstances = 0;
                            Date calendarDate = Date.newInstance(thisYear, month, 1);   // First Day of Month
                            monthMap = new Map<Date, Holiday>();
                            do { // scan all the days for the month
                                Holiday cD = new Holiday();
                                cD.ActivityDate=calendarDate;
                                Integer day = dayOfWeek(Datetime.newInstance(calendarDate.year(), calendarDate.month(), calendarDate.day()));
                                if (day == DAY_SUNDAY) {
                                    cD.RecurrenceInterval=++SunInstances;
                                    cD.RecurrenceDayOfWeekMask= MASK_SUNDAY;
                                } else if (day == DAY_MONDAY) {
                                    cD.RecurrenceInterval=++MonInstances;
                                    cD.RecurrenceDayOfWeekMask= MASK_MONDAY;
                                } else if (day == DAY_TUESDAY) {
                                    cD.RecurrenceInterval=++TueInstances;
                                    cD.RecurrenceDayOfWeekMask= MASK_TUESDAY;
                                } else if (day == DAY_WEDNESDAY) {
                                    cD.RecurrenceInterval=++WedInstances;
                                    cD.RecurrenceDayOfWeekMask= MASK_WEDNESDAY;
                                } else if (day == DAY_THURSDAY) {
                                    cD.RecurrenceInterval=++ThuInstances;
                                    cD.RecurrenceDayOfWeekMask= MASK_THURSDAY;
                                } else if (day == DAY_FRIDAY) {
                                    cD.RecurrenceInterval=++FriInstances;
                                    cD.RecurrenceDayOfWeekMask= MASK_FRIDAY;
                                } else if (day == DAY_SATURDAY) {
                                    cD.RecurrenceInterval=++SatInstances;
                                    cD.RecurrenceDayOfWeekMask= MASK_SATURDAY;
                                }
                                monthMap.put(calendarDate,cD);
                                if (calendarDate.day()>=28)  {
                                   lastDayOfMonth=calendarDate;    // will contain last Day if loop ends
                                }
                                calendarDate=calendarDate.addDays(1);
                            } while (calendarDate.month()==month);
                            // Identify the holiday
                            if (h.RecurrenceDayOfWeekMask!=127) {
                                for (Holiday dS : monthMap.values()) { // keep only desired DayOfWeek
                                    if (h.RecurrenceDayOfWeekMask!=dS.RecurrenceDayOfWeekMask) { monthMap.remove(dS.ActivityDate); }
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
                                    if (whichInstance==dS.RecurrenceInterval) { usHolidayMap.put(dS.ActivityDate,h.Name); continue; }
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

    public static Integer dayOfWeek(Datetime USDate) {
        return dayOfWeek(USDate.date());
    }

    public static Integer dayOfWeek(Date USDate) {
        return Math.mod(Date.newInstance(1900, 1, 7).daysBetween(USDate), 7);
    }
}
