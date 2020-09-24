public class MyCustomTaskController {

    @AuraEnabled public List<Analytics_Trial_Task__c> taskList {get; set;}

    @AuraEnabled
    public static MyCustomTaskController queryRecords () {
	
		MyCustomTaskController controller = new MyCustomTaskController();
        
        controller.taskList = [
            SELECT Id, Name, Task_Title__c, Task_Order__c, Is_Completed__c, Completed_Date__c, Actionable_Link__c, Subtitle__c 
            FROM Analytics_Trial_Task__c
            ORDER BY Task_Order__c ASC
        ]; 
        
        return controller;
    }
    
    @AuraEnabled 
    public static String toggleStatus (Id taskId, Boolean status) {
        
        Analytics_Trial_Task__c att = [
            SELECT Id, Is_Completed__c, Completed_Date__c 
            FROM Analytics_Trial_Task__c 
            WHERE Id =: taskId
        ];
        
        att.Is_Completed__c = status;
        
        if (status == TRUE) {
            att.Completed_Date__c = Date.Today();
        } else {
            att.Completed_Date__c = NULL;
        }
        
        try {
	        update att;      
            return 'Success';
        } catch (Exception e) {
            return e.getMessage();
        } 


        
    }

}