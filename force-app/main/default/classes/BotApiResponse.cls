public without sharing class BotApiResponse {
    public class PrechatOutput{
        
        @InvocableVariable
        public String sFirstName;
        @InvocableVariable
        public String sLastName;
        @InvocableVariable
        public Contact sContact;
        
    }
    public class PrechatInput{
    }
    @InvocableMethod(label='Get contact data')
    public static List<PrechatOutput> getSnapInsPrechatData()
    {
        System.debug('######## Input Parameters: ');
        
        List<prechatoutput> outputParameters = new List<prechatoutput>();
        PrechatOutput outputParameter = new PrechatOutput();
        
        List<Contact> contacts = [SELECT Id, FirstName,AccountId, Account.Name, LastName, Email FROM Contact limit 1];
                       
        if (contacts.size()>0)
        {
            outputParameter.sFirstName = contacts[0].FirstName;
            outputParameter.sLastName = contacts[0].LastName;
            outputParameter.sContact = contacts[0];
        }
        
        outputParameters.add(outputParameter);
        return outputParameters;
    }
}