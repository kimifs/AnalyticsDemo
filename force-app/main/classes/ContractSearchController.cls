public class ContractSearchController {
    @AuraEnabled
    public static List<Lease_Contract__c> searchByTenant(String tenantName){
        String tName = '%' + tenantName + '%';
        List<Lease_Contract__c> contractListByTenant = [select id, Name, Tenant_Contact__r.Name, Flat__r.Name, Status__c,
                                                        Building__r.Name,Contract_Term__c, Days_Remaining_In_Contract__c
                                                        from Lease_Contract__c
                                                        where Tenant_Contact__r.Name like :tName];
        System.debug(contractListByTenant);
        return contractListByTenant;
    }
    @AuraEnabled
    public static List<Lease_Contract__c> searchByBuilding(String buildingName){
        String bName = '%' + buildingName + '%';
        List<Lease_Contract__c> contractListByTenant = [select id, Name, Tenant_Contact__r.Name, Flat__r.Name, Status__c,
                                                        Building__r.Name,Contract_Term__c, Days_Remaining_In_Contract__c
                                                        from Lease_Contract__c
                                                        where Building__r.Name like :bName];
        System.debug(contractListByTenant);
        return contractListByTenant;
        
    }

}