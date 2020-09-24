@isTest
public class LeaseContractPathComponentControllerTest {

    @isTest
    public static void testMethod1(){
        
        Test.startTest();
        Account a = new Account();
        a.Name = 'Test';
        insert a;
        
        Contact c = new Contact();
        c.Firstname = 'Test1';
        c.LastName = 'Test2';
        c.RecordTypeId = '0122w000000J7IKAA0';
        c.AccountId = a.Id;
        insert c;
        
        Building__c b = new Building__c();
        b.Building_Code__c = 'BT';
        b.Name = 'test';
        insert b;
        
        Flat__c f = new Flat__c();
        f.Name = 'testFlat';
        f.Building__c = b.Id;
        insert f;
        
        Lease_Contract__c lc = new Lease_Contract__c();
        lc.Building__c = b.Id;
        lc.Flat__c = f.Id;
        lc.Tenant_Contact__c = c.Id;
        insert lc;
       
        System.assertEquals(null, LeaseContractPathComponentController.getStage(lc.Id));
        Test.stopTest();
    }
}