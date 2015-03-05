@isTest(SeeAllData=true) 
private class TestfasHolidayHelper {
    public static testMethod void testfasHolidays() {
    
        LIST<Holiday> hL = new LIST<Holiday>();
        Holiday h1 = new Holiday();
        h1.name='New Year\'s Day';  
        h1.description=h1.name;
        h1.isallday=true;
        h1.activitydate=Date.parse('01/01/2012');
        h1.isrecurrence=true;
        h1.recurrencestartdate=Date.parse('01/01/2012');   
        h1.recurrencetype='RecursYearly';   
        h1.recurrencedayofweekmask=null;
        h1.recurrencedayofmonth=1;  
        h1.recurrenceinstance=null; 
        h1.recurrencemonthofyear='January';
        hL.add(h1);
        h1 = new Holiday();
        h1.name='Martin Luther King, Jr Day';
        h1.description=h1.name;
        h1.isallday=true;
        h1.activitydate=Date.parse('01/06/2012');
        h1.isrecurrence=true;
        h1.recurrencestartdate=Date.parse('01/06/2012');   
        h1.recurrencetype='RecursYearlyNth';   
        h1.recurrencedayofweekmask=2;
        h1.recurrencedayofmonth=null;  
        h1.recurrenceinstance='Third'; 
        h1.recurrencemonthofyear='January';
        hL.add(h1);
        h1 = new Holiday();
        h1.name='Washington\'s Birthday';
        h1.description=h1.name;
        h1.isallday=true;
        h1.isrecurrence=true;
        h1.activitydate=Date.parse('2/20/2012');
        h1.recurrencestartdate=Date.parse('02/20/2012');   
        h1.recurrencetype='RecursYearlyNth';   
        h1.recurrencedayofweekmask=2;
        h1.recurrencedayofmonth=null;  
        h1.recurrenceinstance='Third'; 
        h1.recurrencemonthofyear='February';
        hL.add(h1);
        h1 = new Holiday();
        h1.name='Independence Day';
        h1.description=h1.name;
        h1.isallday=true;
        h1.isrecurrence=true;
        h1.activitydate=Date.parse('07/04/2012');
        h1.recurrencestartdate=Date.parse('07/04/2012');   
        h1.recurrencetype='RecursYearly';   
        h1.recurrencedayofweekmask=null;
        h1.recurrencedayofmonth=4;  
        h1.recurrenceinstance=null; 
        h1.recurrencemonthofyear='July';
        hL.add(h1);
        h1 = new Holiday();
        h1.name='Veteran\'s Day';
        h1.description=h1.name;
        h1.isallday=true;
        h1.isrecurrence=true;
        h1.activitydate=Date.parse('09/27/2012');  
        h1.recurrencestartdate=Date.parse('11/11/2012');    
        h1.recurrencetype='RecursYearly';   
        h1.recurrencedayofweekmask=null;
        h1.recurrencedayofmonth=11;  
        h1.recurrenceinstance=null; 
        h1.recurrencemonthofyear='November';
        hL.add(h1);
        h1 = new Holiday();
        h1.name='Christmas Day';
        h1.description=h1.name;
        h1.isallday=true;
        h1.isrecurrence=true;
        h1.activitydate=Date.parse('09/27/2012'); 
        h1.recurrencestartdate=Date.parse('12/25/2011');    
        h1.recurrencetype='RecursYearly';   
        h1.recurrencedayofweekmask=null;
        h1.recurrencedayofmonth=25;  
        h1.recurrenceinstance=null; 
        h1.recurrencemonthofyear='December';
        hL.add(h1);        
        h1 = new Holiday();
        h1.name='Memorial Day';
        h1.description=h1.name;
        h1.isallday=true;
        h1.isrecurrence=true;
        h1.activitydate=Date.parse('09/28/2012'); 
        h1.recurrencestartdate=Date.parse('05/28/2011');    
        h1.recurrencetype='RecursYearlyNth';   
        h1.recurrencedayofweekmask=2;
        h1.recurrencedayofmonth=null;  
        h1.recurrenceinstance='Last'; 
        h1.recurrencemonthofyear='May';
        hL.add(h1);
        h1 = new Holiday();
        h1.name='Thanksgiving Day';
        h1.description=h1.name;
        h1.isallday=true;
        h1.isrecurrence=true;
        h1.activitydate=Date.parse('09/28/2012'); 
        h1.recurrencestartdate=Date.parse('11/22/2012');    
        h1.recurrencetype='RecursYearlyNth';   
        h1.recurrencedayofweekmask=16;
        h1.recurrencedayofmonth=null;  
        h1.recurrenceinstance='Fourth'; 
        h1.recurrencemonthofyear='November';
        hL.add(h1);
        h1 = new Holiday();
        h1.name='Columbus Day';
        h1.description=h1.name;
        h1.isallday=true;
        h1.isrecurrence=true;
        h1.activitydate=Date.parse('10/08/2012'); 
        h1.recurrencestartdate=Date.parse('10/08/2012');    
        h1.recurrencetype='RecursYearlyNth';   
        h1.recurrencedayofweekmask=2;
        h1.recurrencedayofmonth=null;  
        h1.recurrenceinstance='Second'; 
        h1.recurrencemonthofyear='October';
        hL.add(h1);
        h1 = new Holiday();
        h1.name='Labor Day';
        h1.description=h1.name;
        h1.isallday=true;
        h1.isrecurrence=true;
        h1.activitydate=Date.parse('09/03/2012'); 
        h1.recurrencestartdate=Date.parse('09/03/2012');    
        h1.recurrencetype='RecursYearlyNth';   
        h1.recurrencedayofweekmask=2;
        h1.recurrencedayofmonth=null;  
        h1.recurrenceinstance='First'; 
        h1.recurrencemonthofyear='September';
        hL.add(h1);   
        insert hL;     
                
        test.StartTest();
        Datetime CheckDateTime = system.now();
        Boolean results = fasHolidayHelper.isHoliday(CheckDateTime);
        system.debug('holiday test'+CheckDateTime+results);

        Date CheckDate = Date.newInstance(2012, 12, 25);
        results = fasHolidayHelper.isHoliday(CheckDate);
        system.debug('holiday test'+CheckDate+results);
        System.assertEquals(true, results);
        
        CheckDate = Date.newInstance(2013, 10, 15);
        results = fasHolidayHelper.isHoliday(CheckDate);
        system.debug('holiday test'+CheckDate+results);
        System.assertEquals(false, results);

        CheckDateTime = DateTime.newInstance(2012, 5, 28);
        results = fasHolidayHelper.isHoliday(CheckDateTime);
        system.debug('holiday test'+CheckDateTime+results);
        System.assertEquals(true, results);  // memorial day
        
        CheckDate = Date.newInstance(2012, 5, 28);
        results = fasHolidayHelper.isHoliday(CheckDate);
        system.debug('holiday test'+CheckDateTime+results);
        System.assertEquals(true, results);  // memorial day

        CheckDateTime = DateTime.newInstance(2012, 11, 22);
        results = fasHolidayHelper.isHoliday(CheckDateTime);
        system.debug('holiday test'+CheckDateTime+results);
        System.assertEquals(true, results);  // thanksgiving day
        
        CheckDate = Date.newInstance(2012, 11, 22);
        results = fasHolidayHelper.isHoliday(CheckDate);
        system.debug('holiday test'+CheckDateTime+results);
        System.assertEquals(true, results);  // thanksgiving day

        CheckDateTime = DateTime.newInstance(2012, 5, 28);
        results = fasHolidayHelper.isBusinessDay(CheckDateTime);
        system.debug('businessday test'+CheckDateTime+results);
        System.assertEquals(false, results);  // memorial day

        CheckDate = Date.newInstance(2012, 5, 28);
        results = fasHolidayHelper.isBusinessDay(CheckDate);
        system.debug('businessday test'+CheckDateTime+results);
        System.assertEquals(false, results);  // memorial day
        
        CheckDate = Date.newInstance(2013,10,12);
        results = fasHolidayHelper.isBusinessDay(CheckDate);
        system.debug('businessday test'+CheckDateTime+results);
        System.assertEquals(false, results);  // saturday
        
        CheckDateTime = DateTime.newInstance(2013,10,12);
        results = fasHolidayHelper.isBusinessDay(CheckDateTime);
        system.debug('businessday test'+CheckDateTime+results);
        System.assertEquals(false, results);  // saturday
        
        CheckDate = Date.newInstance(2013,10,15);
        results = fasHolidayHelper.isBusinessDay(CheckDate);
        system.debug('businessday test'+CheckDateTime+results);
        System.assertEquals(true, results);  // Tuesday
        
        CheckDateTime = DateTime.newInstance(2013,10,15);
        results = fasHolidayHelper.isBusinessDay(CheckDateTime);
        system.debug('businessday test'+CheckDateTime+results);
        System.assertEquals(true, results);  // Tuesday
        
        DATE startDate = Date.newInstance(2013,01,01);
        DATE endDate = Date.newInstance(2013,12,31);
        
        fasHolidayHelper holidayUtil =new fasHolidayHelper();   
        MAP<Date,String> offdays = holidayUtil.getholidays(startDate, endDate);
        
        test.StopTest(); //
    }
}