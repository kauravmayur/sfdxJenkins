public class JournalEntryLineTaxCalculation{
    //this method is used to contain values of journal entry line,journalEntryTaxWrapper, tax__c, default tax type, Map<Id, tax__c>
    
    @AuraEnabled public static id accounId{get;set;}
    @AuraEnabled
    public static taxWrapper getJournalEntryDetails(Id journalEntryId){
        System.debug('***Start getJournalEntryDetails***');
        string errorMesaage = '';
        String country='';
        String accountName='';
        Journal_Entry__c journalEntries= getJournalEntries(journalEntryId);
        string journalEntryName = journalEntries.name;
        
        if(journalEntries.Accounting_Period__r.Status__c == 'Closed'){//System.Label.Closed_Account_Status){
            errorMesaage = 'Account period is closed';//System.Label.Closed_Accounting_Period;
        }

        
        List<Journal_Entry_Line__c> journalEntryLine = getJournalEntriesLines(journalEntryId); 
        for(Journal_Entry_Line__c je: journalEntryLine){
            if(je.Account__c != null){
                country = je.Account__r.BillingCountry;
                if(je.Tax__c == null){
                    accountName = je.Account__r.name;
                    accounId = je.Account__r.Id;
                }
                
            }
            else{
                if(String.isBlank(errorMesaage)){
                    errorMesaage = 'Empty Account Error';//System.Label.Empty_Account_Error;
                }
            }
            System.debug('accounId : '+accounId);
        }
        

        List<journalEntryTaxWrapper> journalEntryTaxWrapper = fetchJournalEntryTaxWrapper(journalEntryId);
        Map<Id, tax__c> journalEntrieTaxes =  new Map<Id, tax__c>([ SELECT Country__c,GL_Account__c,GST_HST__c,Id,Name,toLabel(Province__c),PST3__c,QST2__c,
                                                                                                 Sales_Tax_Type__c,Total_Tax__c ,Tax_Type__c,Tax_Name__c,GL_Account_QST__c, GL_Account_PST__c
                                                                                                 FROM tax__c 
                                                                                                 WHERE Country__c =: country]);
        List<tax__c> taxesBasedOnCountry = journalEntrieTaxes.values();
        
        Id defaultTaxesBasedOnCountry = getDefaultTaxesBasedOnCountry(journalEntryId);
        if(defaultTaxesBasedOnCountry == null){
            if(String.isBlank(errorMesaage)){
                errorMesaage = 'Account not found for given address';//System.Label.Not_Found_Account+' '+accountName;
            }
        }
        taxWrapper taxWrapper = new taxWrapper(journalEntryName,journalEntryTaxWrapper,taxesBasedOnCountry,defaultTaxesBasedOnCountry,journalEntrieTaxes,errorMesaage);
         System.debug('***End getJournalEntryDetails***');
        return taxWrapper;
    }
    
    //this method is used to create list of journalEntryTaxWrapper on button click
    @AuraEnabled
    public static List<journalEntryTaxWrapper> fetchJournalEntryTaxWrapper(Id journalEntryId){     
        List<journalEntryTaxWrapper> taxWrapperList = new List<journalEntryTaxWrapper>();
        // query entry item records and create 'journalEntryTaxWrapper' class instance for each record. 
        List<Journal_Entry_Line__c> journalEntryLines = new List<Journal_Entry_Line__c>();
        
        journalEntryLines = getJournalEntriesLinesWithTax(journalEntryId);
        
        Map<String, tax__c> journalEntrieTaxes = new Map<String, tax__c>();
        journalEntrieTaxes = getCountryVsJournalEntrieTaxes();
        
        
        Map<Id, tax__c> mapIdJournalEntrieTaxes = new Map<Id, tax__c>();
        mapIdJournalEntrieTaxes = getJournalEntrieTaxes();
        
        String countryState = ''; 
        string entryLineName = '';
        string amountType = '';
        decimal totalAmount = 0;
        decimal taxAmount = 0;
        if(journalEntryLines.size() > 0){
            for(Journal_Entry_Line__c jei :journalEntryLines){
                countryState = jei.Account__r.BillingCountry+'-'+jei.Account__r.BillingState; 
                entryLineName = jei.Name;
                if(journalEntrieTaxes.ContainsKey(countryState)!= null){
                    if(jei.Debit__c != null){
                        amountType       =  'Dr';//System.Label.Tax_Type_Dr;
                        taxWrapperList.addAll(createJournalEntryTaxWrapper(entryLineName,jei.Journal_Entry__r.Total_Debits__c,journalEntrieTaxes.get(countryState),taxAmount,amountType));
                    }else{
                        amountType       =  'Cr';//System.Label.Tax_Type_Cr;
                        taxWrapperList.addAll(createJournalEntryTaxWrapper(entryLineName,jei.Journal_Entry__r.Total_Credits__c,journalEntrieTaxes.get(countryState),taxAmount,amountType));
                    }
                }
            }
        }
        return taxWrapperList; 
    }
    
    //this nmethod is used to calculate tax onchange tax type picklist
    @AuraEnabled
    public static List<journalEntryTaxWrapper> onChangefetchTaxes(String taxWrapString, Id taxRecordId, Id journalEntryId){     
        List<journalEntryTaxWrapper> taxWrapList = (List<journalEntryTaxWrapper>)JSON.deserialize(taxWrapString, List<journalEntryTaxWrapper>.class);
        List<journalEntryTaxWrapper> taxWrapperList = new List<journalEntryTaxWrapper>();
        Map<Id, tax__c> mapIdJournalEntrieTaxes = new Map<Id, tax__c>();
        mapIdJournalEntrieTaxes = getJournalEntrieTaxes();
        decimal taxAmount = 0;
        List<Journal_Entry_Line__c> journalEntryLines = new List<Journal_Entry_Line__c>();
        
        journalEntryLines = getJournalEntriesLinesWithTax(journalEntryId);
        System.debug('journalEntryLines : '+journalEntryLines);
        if(journalEntryLines.size() > 0){
            
            for(Journal_Entry_Line__c entryLine: journalEntryLines){
                if(mapIdJournalEntrieTaxes.ContainsKey(taxRecordId)){
                    System.debug('entryLine : '+entryLine);
                    if(entryLine.Debit__c != null){
                        taxWrapperList.addAll(createJournalEntryTaxWrapper(entryLine.Name,entryLine.Journal_Entry__r.Total_Debits__c,mapIdJournalEntrieTaxes.get(taxRecordId),taxAmount,'Dr'));//System.Label.Tax_Type_Dr));
                    }
                    if(entryLine.Credit__c != null){
                        taxWrapperList.addAll(createJournalEntryTaxWrapper(entryLine.Name,entryLine.Journal_Entry__r.Total_Credits__c,mapIdJournalEntrieTaxes.get(taxRecordId),taxAmount,'Cr'));//System.Label.Tax_Type_Cr));
                    }
                }
            }
        }
        System.debug('taxWrapperList : '+taxWrapperList);
        return taxWrapperList; 
    }
    
    //this method is used to create journalEntryTaxWrapper wrapper
    public static List<journalEntryTaxWrapper> createJournalEntryTaxWrapper(string entryLineName, decimal totalAmount, tax__c taxDetail,decimal taxAmount, string amountType){
        List<journalEntryTaxWrapper> taxWrapperList = new List<journalEntryTaxWrapper>();
        taxAmount = 0;
        if(taxDetail!= null){
            if(taxDetail.Tax_Type__c == 'Single'){//System.Label.Single_Tax){
                taxAmount = (totalAmount*taxDetail.Total_Tax__c)/100;
                taxWrapperList.add(new journalEntryTaxWrapper(entryLineName,totalAmount,taxDetail.Total_Tax__c,taxAmount,amountType));
            }else{
                if(taxDetail.GST_HST__c != null){
                    taxAmount = (totalAmount*taxDetail.GST_HST__c)/100;
                    taxWrapperList.add(new journalEntryTaxWrapper(entryLineName,totalAmount,taxDetail.GST_HST__c,taxAmount,amountType));
                }
                if(taxDetail.QST2__c != null){
                    taxAmount = (totalAmount*taxDetail.QST2__c)/100;
                    taxWrapperList.add(new journalEntryTaxWrapper(entryLineName,totalAmount,taxDetail.QST2__c,taxAmount,amountType));
                }
                if(taxDetail.PST3__c != null){
                    taxAmount = (totalAmount*taxDetail.PST3__c)/100;
                    taxWrapperList.add(new journalEntryTaxWrapper(entryLineName,totalAmount,taxDetail.PST3__c,taxAmount,amountType));
                }
            }
        }
        
        return taxWrapperList;
    }
    
    //this wrapper class is used to caontain values of journal entry line name, journalEntryTaxWrapper, list of tax__c, taxType and map of tax__c
    public class taxWrapper{
        @AuraEnabled public List<journalEntryTaxWrapper> journalEntryWapperList {get;set;}
        @AuraEnabled public List<tax__c> entryTax {get;set;}
        @AuraEnabled public string taxType {get;set;}
        @AuraEnabled public string journalEntryName {get;set;}
        @AuraEnabled public Map<Id, tax__c> journalEntrieTaxes{get; set;}
        @AuraEnabled public string errorMesaage{get; set;}
        public taxWrapper(string journalEntryName, List<journalEntryTaxWrapper> journalEntryWapperList, List<tax__c> entryTax, string taxType, Map<Id, tax__c> journalEntrieTaxes, string errorMesaage){
            this.journalEntryWapperList =journalEntryWapperList;
            this.entryTax = entryTax;
            this.taxType = taxType;
            this.journalEntryName = journalEntryName;
            this.journalEntrieTaxes = journalEntrieTaxes;
            this.errorMesaage = errorMesaage;
        }
    }
    
   //this wrapper class is used to caontain values of journal entry line, tatal debit/credit, tax percentage and tax amount
   public class journalEntryTaxWrapper {
        @AuraEnabled public string entryLineName {get;set;}
        @AuraEnabled public decimal totalAmount {get;set;}
        @AuraEnabled public decimal taxPercentage{get;set;}
        @AuraEnabled public decimal taxAmount{get;set;}
        @AuraEnabled public string amountType{get;set;}
        public journalEntryTaxWrapper(string entryLineName, decimal totalAmount, decimal taxPercentage,decimal taxAmount, string amountType){
            this.entryLineName  = entryLineName;
            this.totalAmount    = totalAmount;
            this.taxPercentage  = taxPercentage;
            this.taxAmount      = taxAmount;
            this.amountType     = amountType;
            
        }
    }
    
    //Used to query tax__c and create map of tax__c
    @AuraEnabled
    public static Map<Id, tax__c> getJournalEntrieTaxes(){
        Map<Id, tax__c> journalEntriesTaxeMap = new Map<Id, tax__c>([ SELECT Country__c,GL_Account__c,GST_HST__c,Id,Name,toLabel(Province__c),PST3__c,QST2__c,
                                                                                                 Sales_Tax_Type__c,Total_Tax__c ,Tax_Type__c,Tax_Name__c,GL_Account_QST__c, GL_Account_PST__c
                                                                                                 FROM tax__c ]);
        
        return journalEntriesTaxeMap;
    }
    

    //Used to get default Sales Tax type on basis of countries
    @AuraEnabled
    public static Id getDefaultTaxesBasedOnCountry(id journalEntryId){
        Id taxType ;
        Map<String, tax__c> journalEntrieTaxTypeMap = getCountryVsJournalEntrieTaxes();
        Map<String, String> countriesVsTaxmap = new Map<String, String>();
        // queried all journal entries line items records based on ids
        List<Journal_Entry_Line__c> entryLineList = getJournalEntriesLines(journalEntryId);
        String countryState = ''; 
        for(tax__c tax: journalEntrieTaxTypeMap.values()){
            countriesVsTaxmap.put(tax.Country__c+'-'+tax.Province__c, tax.Sales_Tax_Type__c);
        }
        
        for(Journal_Entry_Line__c jeli: entryLineList){
            countryState = jeli.Account__r.BillingCountry+'-'+jeli.Account__r.BillingState;
            if(String.isBlank(taxType) && jeli.Tax__c == null && journalEntrieTaxTypeMap.containsKey(countryState)){
                taxType = journalEntrieTaxTypeMap.get(countryState).Id;
            }
        }
        return taxType;
    }
    
    //Used to query all journal entries
    public static Journal_Entry__c getJournalEntries(Id journalEntryId){
        Journal_Entry__c journalEntries = [ SELECT Accounting_Period__c, Accounting_Period__r.Status__c, 
                                                     posting_Status__c,Total_Credits__c,
                                                     Total_Debits__c,Id,Name
                                                     FROM Journal_Entry__c WHERE Id =: journalEntryId];
        return journalEntries;
    }
    
    //Used to query all journal entries Line items
    public static List<Journal_Entry_Line__c> getJournalEntriesLines(Id journalEntryId){
        List<Journal_Entry_Line__c> journalEntryLineList = [ SELECT Account__c,Credit__c,Debit__c,GL_Account__c,Journal_Entry__c,Id,Tax__c,
                                                            		  Journal_Entry__r.Total_Credits__c,Journal_Entry__r.Total_Debits__c,
                                                                      Account__r.BillingCountry,Account__r.BillingState, Name,Account__r.name
                                                                      FROM Journal_Entry_Line__c
                                                                      WHERE   Journal_Entry__c =: journalEntryId];
        return journalEntryLineList;
    }

    //Used to query all journal entries Line items where Tax equals to null
    public static List<Journal_Entry_Line__c> getJournalEntriesLinesWithTax(Id journalEntryId){
        List<Journal_Entry_Line__c> journalEntryLineList = [ SELECT Account__c,Credit__c,Debit__c,GL_Account__c,Journal_Entry__c,Id,Tax__c,
                                                            		  Journal_Entry__r.Total_Credits__c,Journal_Entry__r.Total_Debits__c,
                                                                      Account__r.BillingCountry,Account__r.BillingState, Name,Account__r.name
                                                                      FROM Journal_Entry_Line__c
                                                                      WHERE   Journal_Entry__c =: journalEntryId 
                                                                      AND  Tax__c = null];
        return journalEntryLineList;
    }

    
    //Used to query all journal entries taxes and create map to use it
    public static Map<String, tax__c> getCountryVsJournalEntrieTaxes(){
        Map<String, tax__c> journalEntriesTaxeMap = new Map<String, tax__c>();
        List<tax__c> journalEntriesTaxes = [ SELECT Country__c,GL_Account__c,GST_HST__c,Id,Name,toLabel(Province__c),PST3__c,QST2__c,
                                                          Sales_Tax_Type__c,Total_Tax__c ,Tax_Type__c,Tax_Name__c
                                                          FROM tax__c ];
        for(tax__c taxes: journalEntriesTaxes){
            journalEntriesTaxeMap.put(taxes.Country__c+'-'+taxes.Province__c, taxes);
        }
        return journalEntriesTaxeMap;
    }    

    @AuraEnabled
    public static Id getAllJournalEntryLine(){
        System.debug('***getAllJournalEntryLine***');
        System.debug('accounId : '+accounId);
        return accounId;
    }
}