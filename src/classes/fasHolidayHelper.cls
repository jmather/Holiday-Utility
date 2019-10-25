public with sharing class fasHolidayHelper {
    public static Boolean isHoliday(Datetime USDateTime)
    {
        return isHoliday(USDateTime.date());
    }

    public static Boolean isHoliday(Date USDate)
    {
        return fasHolidayUtils.usHolidayMap.get(USDate) != null;
    }

    public static Boolean isBusinessDay(Datetime USDateTime)
    {
        return isBusinessDay(USDateTime.date());
    }

    public static Boolean isBusinessDay(Date USDate)
    {
        if (isHoliday(USDate)) {
            return false;
        }

        //jan 1 1900 is known to be a Monday; ergo Jan 7 1900 is a Sunday. we use the # of days between
        //and modulo arithmetic. 0 = Sunday, 6 = Saturday.
        Integer weekday = Math.mod(Date.newInstance(1900, 1, 7).daysBetween(USDate), 7);

        return 1 <= weekday && weekday <= 5;
    }

    Public Map<Date,String> GetHolidays(Date startDate,Date endDate ){

        List<Holiday> holidays = [SELECT ActivityDate, Name, IsRecurrence, RecurrenceType, 
                                          RecurrenceStartDate, recurrencedayofmonth, recurrencedayofweekmask,
                                          RecurrenceInstance, RecurrenceMonthOfYear FROM Holiday 
                                   WHERE RecurrenceType = 'RecursYearly' 
                                      OR RecurrenceType = 'RecursYearlyNth'];
        Date nextHolidayDate;
        Datetime nextHolidayDateTime;
        
        Map<Date,String> MapFEDholidays = new Map<Date,String>();
            
                for (Holiday h : holidays) {
                        
                    for(integer i=startDate.year();i<=endDate.year();i++)
                    {  
                        if ( h.IsRecurrence) 
                        {
                            Integer Month = 0;
                            if (h.RecurrenceMonthOfYear=='January') {
                                Month=1;
                            } else if (h.RecurrenceMonthOfYear=='February') {
                                Month=2;
                            } else if (h.RecurrenceMonthOfYear=='March') {
                                Month=3;
                            } else if (h.RecurrenceMonthOfYear=='April') {
                                Month=4;
                            } else if (h.RecurrenceMonthOfYear=='May') {
                                Month=5;
                            } else if (h.RecurrenceMonthOfYear=='June') {
                                Month=6;
                            } else if (h.RecurrenceMonthOfYear=='July') {
                                Month=7;
                            } else if (h.RecurrenceMonthOfYear=='August') {
                                Month=8;
                            } else if (h.RecurrenceMonthOfYear=='September') {
                                Month=9;
                            } else if (h.RecurrenceMonthOfYear=='October') {
                                Month=10;
                            } else if (h.RecurrenceMonthOfYear=='November') {
                                Month=11;
                            } else if (h.RecurrenceMonthOfYear=='December') {
                                Month=12;
                            } 
                       
                            if (h.RecurrenceType=='RecursYearly') {
                                nextHolidayDateTime = DateTime.newInstance(i, Month, h.recurrencedayofmonth); 
                                if (nextHolidayDateTime.format('EEE')=='Sat') {
                                    nextHolidayDateTime=nextHolidayDateTime.addDays(-1);
                                    nextHolidayDate=date.newInstance(nextHolidayDateTime.year(),nextHolidayDateTime.month(),nextHolidayDateTime.day());
                                    MapFEDholidays.put(nextHolidayDate,h.Name); 
                                } else if (nextHolidayDateTime.format('EEE')=='Sun') {
                                    nextHolidayDateTime=nextHolidayDateTime.addDays(1);    
                                    nextHolidayDate=date.newInstance(nextHolidayDateTime.year(),nextHolidayDateTime.month(),nextHolidayDateTime.day());
                                    MapFEDholidays.put(nextHolidayDate,h.Name);     
                                }
                                else
                                {
                                   nextHolidayDate=date.newInstance(nextHolidayDateTime.year(),nextHolidayDateTime.month(),nextHolidayDateTime.day());
                                   MapFEDholidays.put(nextHolidayDate,h.Name);     
                                }   
                            }
                            else 
                            {  
                                Map<Date, Holiday> MapMonth = new Map<Date, Holiday>();
                                Date lastDayOfMonth;
                                Date calendarDate = Date.newInstance(i, Month, 1);   
                                Integer MONcount=0;
                                Integer TUEcount=0;
                                Integer WEDcount=0;
                                Integer THUcount=0;
                                Integer FRIcount=0;
                                Integer SATcount=0;
                                Integer SUNcount=0;
                                do { 
                                    Holiday cD = new Holiday();
                                    cD.activitydate=calendarDate;
                                    Datetime calendarDatetime = DateTime.newInstance(calendarDate.year(), calendarDate.month(), calendarDate.day()); 
                                    if (calendarDatetime.format('EEE')=='Sun') {
                                        SUNcount++;
                                        cD.recurrenceinterval=SUNcount;
                                        cD.RecurrenceDayOfWeekMask=1;
                                    } if (calendarDatetime.format('EEE')=='Mon') {
                                        MONcount++;
                                        cD.recurrenceinterval=MONcount;
                                        cD.RecurrenceDayOfWeekMask=2;
                                    } if (calendarDatetime.format('EEE')=='Tue') {
                                        TUEcount++;
                                        cD.recurrenceinterval=TUEcount;
                                        cD.RecurrenceDayOfWeekMask=4;
                                    } if (calendarDatetime.format('EEE')=='Wed') {
                                        WEDcount++;
                                        cD.recurrenceinterval=WEDcount;
                                        cD.RecurrenceDayOfWeekMask=8;
                                    } if (calendarDatetime.format('EEE')=='Thu') {
                                        THUcount++;
                                        cD.recurrenceinterval=THUcount;
                                        cD.RecurrenceDayOfWeekMask=16;
                                    } if (calendarDatetime.format('EEE')=='Fri') {
                                        FRIcount++;
                                        cD.recurrenceinterval=FRIcount;
                                        cD.RecurrenceDayOfWeekMask=32;
                                    } if (calendarDatetime.format('EEE')=='Sat') {
                                        SATcount++;
                                        cD.recurrenceinterval=SATcount;
                                        cD.RecurrenceDayOfWeekMask=64;
                                    }
                                    cD.name=calendarDatetime.format('EEE');
                                    cD.recurrencedayofmonth=calendarDate.day();               
                                    MapMonth.put(calendarDate,cD);  // include next year's holiday 
                                    lastDayOfMonth=calendarDate;    // will contain last Day if loop ends
                                    calendarDate=calendarDate.addDays(1);
                                 } while (calendarDate.month()==Month);
                                 if (h.RecurrenceDayOfWeekMask==127) {
                                 } else {
                                    for (Holiday dS : MapMonth.values()) {  
                                        if (h.RecurrenceDayOfWeekMask!=dS.RecurrenceDayOfWeekMask) { 
                                             MapMonth.remove(dS.activitydate); 
                                        } 
                                    }
                                 }
                                 Integer whichInstance = MapMonth.size();  
                                 if (h.RecurrenceInstance=='First') {
                                     whichInstance=1;
                                 } else if (h.RecurrenceInstance=='Second') {
                                     whichInstance=2;
                                 } else if (h.RecurrenceInstance=='Third') {
                                     whichInstance=3;
                                 } else if (h.RecurrenceInstance=='Fourth') {
                                     whichInstance=4;
                                 } 
                                 if (whichInstance>4) { 
                                     MapFEDholidays.put(lastDayOfMonth,h.Name);   
                                 } else {
                                     for (Holiday dS : MapMonth.values()) {
                                         if (whichInstance==dS.recurrenceinterval) { 
                                             MapFEDholidays.put(dS.activitydate,h.Name);  
                                              
                                             break;
                                         } 
                                     }
                                 }
                             }
                        
                           }
                        }
                    }
                    Return MapFEDholidays;
        }
}
