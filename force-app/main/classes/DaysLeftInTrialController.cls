public class DaysLeftInTrialController {

    @AuraEnabled Integer DaysLeft {get; set;}
    
    @AuraEnabled public static DaysLeftInTrialController getDaysLeft () {
        
        DaysLeftInTrialController controller = new DaysLeftInTrialController();
        
        Datetime expireDate = [SELECT TrialExpirationDate FROM Organization].TrialExpirationDate;
		controller.DaysLeft = (System.Today()).daysBetween(Date.valueOf(expireDate)) - 1;
        
        return controller;
    }
    
}