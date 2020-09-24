public class LeaseContractPathComponentController {
    
    @AuraEnabled
    public static String getStage(Id recId)
    {
        Lease_Contract__c record = [SELECT  Status__c FROM  Lease_Contract__c WHERE Id =:recId];
        System.debug(record.Status__c);
        return record.Status__c;
        
        
    }
    
}