public class CountryPicklistController {

    @AuraEnabled public List<World_Countries__c> worldCountries {get; set;}
    @AuraEnabled public List<US_States__c> usStates {get; set;}

    @AuraEnabled
    public static CountryPicklistController getListData () {
        
        CountryPicklistController geoPicklistValues = new CountryPicklistController();
        
        geoPicklistValues.worldCountries = [
            SELECT ISO_Code__c, Name, Email_Opt_In__c 
            FROM World_Countries__c
            ORDER BY Name ASC
        ];
        
        geoPicklistValues.usStates = [
            SELECT USPS_Code__c, Name 
            FROM US_States__c
            ORDER BY Name ASC
        ];
        
        return geoPicklistValues;
    }

    
}