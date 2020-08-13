@isTest
public class TestVerifyDate {
    @isTest static void check30DaysTest(){
        VerifyDate.CheckDates(system.today(), system.today() +20);
    }
    @isTest static void SetEndOfMonthDateTest(){
        VerifyDate.CheckDates(system.today(), system.today() +140);
    }
}