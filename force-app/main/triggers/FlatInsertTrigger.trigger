trigger FlatInsertTrigger on Flat__c (before insert) {
    
for(Flat__c objFlat:Trigger.new)
    {
        ID bName =objFlat.Building__c;  
        Building__c bList = [Select Id , Name, Building_Code__c FROM Building__c WHERE Id = :bName LIMIT 1];
        String buildingCode = bList.Building_Code__c;
        System.debug(bList.Building_Code__c);
        String flatName = objFlat.Name;
        objFlat.Name = (buildingCode + flatName).toUppercase();
    }
}