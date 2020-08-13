public class ZomatoAPI{
    private static final string USER_KEY = '4602e198961e8fd72aac3c4e3a3826fb';
    private static final string ZOMATO_HOST ='https://developers.zomato.com/api/v2.1';
    
    private static HttpRequest buildrequest(string queryString){
        HttpRequest httpReq = new HttpRequest();
        httpReq.setheader('Accept','application/json');
        httpReq.setheader('user-key',USER_KEY);
        httpReq.setEndPoint(ZOMATO_HOST + queryString);
        httpReq.setMethod('GET');
        
        return httpReq;
    }
    
    public static List<String> locate(string location){
      system.debug('***locate***'+location);    
        HttpResponse httpRes = new Http().send( buildrequest( '/locations?query='+location) );
        system.debug('httpRes.getBody() : '+httpRes.getBody());
        //ZomatoLocation.Location_suggestions locationres = ( ZomatoLocation.Location_suggestions )JSON.deserialize(httpRes.getBody(), ZomatoLocation.Location_suggestions.class);
        ZomatoLocation locationres = ( ZomatoLocation )JSON.deserialize(httpRes.getBody(), ZomatoLocation.class);
        system.debug('locationres : '+locationres);
        Opportunity newOpp = new Opportunity();
        newOpp.Name = String.valueOf(Datetime.now().getTime());
        newOpp.StageName = 'prospecting';
        newOpp.CloseDate = date.today();
        newOpp.Entity_Id__c = String.valueOf(locationres.location_suggestions[0].entity_Id );
        newOpp.Entity_Type__c = locationres.location_suggestions[0].entity_Type;
        newOpp.City_Id__c = String.valueOf(locationres.location_suggestions[0].city_Id );
        insert newOpp;
        return new List<String>{newOpp.Id};
    }
    
    public static List<String> findCuisines(string reqId){
      system.debug('***findCuisines***'+reqId);    
        Opportunity opp = [SELECT Id, City_Id__c from Opportunity WHERE ID =:reqId ];
        //HttpResponse httpRes = new Http().send( buildrequest( '/locations?query=Toronto') );
        HttpResponse httpRes = new Http().send( buildrequest( '/cuisines?city_id='+opp.City_Id__c) );
    	system.debug('httpRes.getBody() : '+httpRes.getBody());        
        
        
        ZomatoCuisineInfo cuisineres = ( ZomatoCuisineInfo )JSON.deserialize(httpRes.getBody(), ZomatoCuisineInfo.class);
        system.debug('cuisineres : '+cuisineres);        
        List<Available_Cuisine__c> cuisines = new List<Available_Cuisine__c>();
        
        for(ZomatoCuisineInfo.Cuisines cuisi: cuisineres.Cuisines){
            system.debug('cuisi : '+cuisi);
            Available_Cuisine__c newCuisine = new Available_Cuisine__c();
            newCuisine.Cuisine_Id__c = String.valueOf(cuisi.Cuisine.cuisine_id);
            newCuisine.Cuisine_Name__c = cuisi.Cuisine.cuisine_name;
            newCuisine.Opportunity__c = reqId;
                    
            cuisines.add(newCuisine);
        }
    	
        insert cuisines;
		
      
        return new List<String>{reqId};
    }
    
    public static List<String> getCuisines(String reqId){
        List<Available_Cuisine__c> cuisines = [SELECT Cuisine_Id__c,Cuisine_Name__c, ID FROM Available_Cuisine__c WHERE Opportunity__c =: reqId];
        List<String> availableCuisine = new List<String>();
        for(Available_Cuisine__c cuis: cuisines){
            availableCuisine.add(cuis.Cuisine_Name__c);
        }
        return availableCuisine;
    }
}