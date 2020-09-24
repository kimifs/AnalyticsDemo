public class LeaseContractDataUtil {
    
   /* public static void createLeaseContract(Date startDate){
        
        List<Contact> conList = [Select Id, Name, FirstName, LastName, AccountId from Contact where RecordTypeId = '0122w000000J7IKAA0'];
        List<Id> accountIdList = new List<Id>();
        for(Contact con: conList){
            accountIdList.add(con.AccountId);
        }
        List<Account> acList = [Select Id, Name from Account where Id in :accountIdList];
        List<Building__c> buildingList = [Select Id, Name from Building__c];
        List<Id> buildingIdList = new List<Id>();
        for(Building__c b: buildingList){
            buildingIdList.add(b.Id);
        }
        Map<Id, Id> flatBuildingMap = new Map<Id, Id>();
        List<Flat__c> flatList = [Select Id, Name, building__c from Flat__c where building__c in :buildingIdList];
        for(Flat__c f:flatList){
            flatBuildingMap.put(f.Id, f.building__c);
        }
        List<Lease_Contract__c> lcList = new List<Lease_Contract__c>();
        
        Integer buildingListSize = buildingList.size() - 1;
        Integer flatListSize = flatList.size() - 1;
        Set<Integer> usedNumberSet = new Set<Integer>();
        //startDate = Date.newInstance(200, 06, 26);
        for(Contact con:conList){
            Integer randomNumberFirst = Integer.valueof((Math.random() * 9));
            Integer randomNumberSecond = Integer.valueof((Math.random() * flatListSize));
            Lease_Contract__c lc = new Lease_Contract__c();
            lc.start_Date__c = startDate.addDays(randomNumberSecond);
            lc.Revenue__c = randomNumberFirst * 1000;
            lc.end_Date__c = startDate.addDays(randomNumberFirst * 90);
            lc.Tenant_Contact__c = con.Id;
            lc.Status__c = 'Approved';
            if(!usedNumberSet.contains(randomNumberSecond) && usedNumberSet.size() < buildingList.size()){
                 lc.Flat__c = flatList[randomNumberSecond].Id;
                if(flatBuildingMap != null && flatBuildingMap.containsKey(lc.Flat__c)){
                    usedNumberSet.add(randomNumberSecond);
                    lc.Building__c = flatBuildingMap.get(lc.Flat__c);
                    flatList.remove(randomNumberSecond);
                    flatListSize = flatListSize - 1;
                    lcList.add(lc);
                }
                
            }
            
        }
        System.debug('usedNumberSet = '  + usedNumberSet.size());
        if(lcList.size() > 0){
            upsert lcList;
        }
    }
    
    public static void updatedLeaseContract(){
        List<Lease_Contract__c> lcList = [Select Id, Revenue__c, end_date__c from Lease_Contract__c];
        
        for(Lease_Contract__c lc:lcList){
            //Integer randomNumberFirst = Integer.valueof((Math.random() * lcList.size()));
            //lc.Revenue__c = randomNumberFirst * 100;
            //lc.End_Date__c = lc.End_Date__c.addDays(randomNumberFirst);        
            lc.Status__c = 'Approved';    
        }
        update lcList;
        
    }
    
    public static void createTenantContacts(){
        List<String> firstNameList = new List<String>{'Michael','Angela','Bruce','Edward','Anna', 'Steve', 'Mark', 'Veronica', 'Bella'};
            List<String> lastNameList = new List<String>{'Connor','Hills','Bill','Gates','Clinton', 'Grey', 'Jobs', 'Klayton'};
                
                List<Account> acList = new List<Account>();
        for(Integer i = 0; i <100; i++){
            Integer firstlistSize = firstNameList.size() - 1;
            Integer secondlistSize = lastNameList.size() - 1;
            Integer randomNumberFirst = Integer.valueof((Math.random() * firstlistSize));
            Integer randomNumberSecond = Integer.valueof((Math.random() * secondlistSize));
            String randomFirsString= firstNameList[randomNumberFirst];
            String randomSecondString= lastNameList[randomNumberSecond];
            System.debug('randomString is'+randomFirsString + ' ' + randomSecondString);
            Account ac = new Account();
            ac.Name = randomFirsString + ' ' + randomSecondString;
            //ac.FirstName = randomFirsString;
            //ac.LastName = randomNumberSecond;
            acList.add(ac);
        }
        System.debug('acList = ' + acList.size());
        insert acList;
        
        
        acList = [Select Id, Name from Account limit 100];
        List<Contact> conList = new List<Contact>();
        System.debug(acList.size());
        for(Account ac:acList){
            String name = ac.Name;
            Contact con = new Contact();
            con.AccountId = ac.Id;
            
            con.RecordTypeId = Id.valueOf('0122w000000J7IKAA0');
            //con.Name = ac.Name;
            if(name.subStringAfter(' ') != null){
                con.FirstName= name.subStringBefore(' ');
                con.LastName = name.subStringAfter(' ');
                conList.add(con);
            }
        }
        insert conList;
        
    }*/
    
}