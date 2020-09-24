public class SignupFormController {
    
    @AuraEnabled public User relatedUser {get; set;}
    @AuraEnabled public Signup_Form_Settings__c formSettings {get; set;}
    
    @AuraEnabled
    public static SignupFormController getInfo () {

        SignupFormController signupFormData = new SignupFormController();
        signupFormData.formSettings = Signup_Form_Settings__c.getInstance();
        
        signupFormData.relatedUser = [
            SELECT Id, FirstName, LastName, Email, Phone, CompanyName, UserRole.Name 
            FROM User 
            WHERE Id =: UserInfo.getUserId()
        ];
        
        signupFormData.formSettings.Campaign_ID__c += 'BhbQAG';
        
        return signupFormData;
        
    }
    
    @AuraEnabled
    public static Integer sendFormData (String endpoint_url, String body_content) {
        
        System.debug(endpoint_url);
        System.debug(body_content);
        
        HttpRequest httpRequest = new HttpRequest();  

        httpRequest.setMethod('POST');   
        httpRequest.setHeader('Content-Type', 'application/x-www-form-urlencoded');

        httpRequest.setEndpoint(endpoint_url);  
        httpRequest.setBody(body_content);
                
        Http http = new Http();   
        HttpResponse httpResponse = http.send(httpRequest);  
        
        System.debug(httpResponse.getStatusCode());
        return httpResponse.getStatusCode();
        
    }
    
    @AuraEnabled
    public static void formSubmitted () {
        
        Signup_Form_Settings__c formSettings = Signup_Form_Settings__c.getInstance();
        
        formSettings.Is_Submitted__c = TRUE;
        formSettings.Date_Submitted__c = Datetime.now();
        
        try {
	        update formSettings;
        } catch (Exception e) {
            System.debug(e.getMessage());
        }
        
    }
    
}