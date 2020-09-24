@isTest
public with sharing class ContractSearchControllerTest {
    
    @testSetup
    public static void setup(){
        String tName = 'Penny';
        Building__c testBuilding = new Building__c(Name = 'ABC Test Heights', Maximum_Number_of_Flats__c = 50, Building_Code__c='ABC');
        insert testBuilding;
        Flat__c testFlat = new Flat__c(Name = '12', Building__c = testBuilding.id, Status__c = 'Vacant');
        insert testFlat;
        Id contactRecordType = Schema.SObjectType.Contact.getRecordTypeInfosByName().get('Tenant').getRecordTypeId();
        Contact testTenant = new Contact(FirstName = 'Diksha',LastName = 'Mehta', Email = 'diksha@fs.com');
        testTenant.RecordTypeId = contactRecordType;
        insert testTenant;
        Lease_Contract__c testContract = new Lease_Contract__c(Tenant_Contact__c = testTenant.ID, Building__c = testBuilding.ID, Flat__c = testFlat.ID);
        insert testContract;
    }
    @isTest
    public static void testContractSearchByTenant(){
        
        Test.startTest();
        List<Lease_Contract__c> contractListForTest = ContractSearchController.searchByTenant('Mehta');
        Test.stopTest();   
        
        System.assertEquals('Diksha Mehta', contractListForTest[0].Tenant_Contact__r.Name);
        
    }
    @isTest
    public static void testContractSearchByBuilding(){
        
        Test.startTest();
        List<Lease_Contract__c> buildingListForTest = ContractSearchController.searchByBuilding('ABC');
        Test.stopTest();   
        
        System.assertEquals('ABC Test Heights', buildingListForTest[0].Building__r.Name);
        
    }
}