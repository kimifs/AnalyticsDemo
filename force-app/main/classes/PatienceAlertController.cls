public class PatienceAlertController {

    @AuraEnabled public Boolean hideMessage {get; set;}
    
    @AuraEnabled 
    public static PatienceAlertController getHideMessage () {
        
        PatienceAlertController controller = new PatienceAlertController();
        
        controller.hideMessage = FALSE;
        
        if (Datetime.now() < [SELECT CreatedDate FROM Organization].CreatedDate.addHours(1))
            controller.hideMessage = TRUE;
        
        return controller;
        
    }
    
}