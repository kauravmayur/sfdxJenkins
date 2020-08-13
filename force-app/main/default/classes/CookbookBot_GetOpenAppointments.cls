public with sharing class CookbookBot_GetOpenAppointments {
    @InvocableMethod(label='Get Open Appointments')
    public static List<List<Bot_Appointment__c>> getOpenAppointments(List<String> sEmails)
    {
        String sEmail = sEmails[0];
        // Get the list of new and scheduled appointments
        List<Bot_Appointment__c> appointments = [SELECT Id, Name, JobType__c,
                                                 AppointmentDate__c, AppointmentSlot__c
                                                 FROM Bot_Appointment__c
                                                 WHERE Contact__r.Email =:sEmail
                                                 AND Status__c IN ('New','Scheduled')];
        
            
            // Create a list for the appointments
            // NOTE: This is a list of lists in order to handle bulk calls...
            List<List<Bot_Appointment__c>> appointmentList = new List<List<Bot_Appointment__c>>();
        // Add all the new and scheduled appointments to the list
        appointmentList.add(appointments);
        return appointmentList;
    }
}