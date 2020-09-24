({
	
    doInit : function(component, event, helper) {
        var action = component.get("c.getInfo");
        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                if (storeResponse.formSettings.Is_Submitted__c) {
                                    
                    helper.alreadySubmittedResponse(
                        component, 
                        event, 
                        'Thank you for your interest in Einstein Analytics! A member of our sales team will contact you shortly to complete your transaction.'
                    );
                    
                    helper.showImage(component, event);
                    
                } else {
                    component.set("v.controllerData", storeResponse);
                    component.set("v.endpointURL", storeResponse.formSettings.Endpoint_URL__c); 
                }
            } else {
                console.log('Error in Signup Form Lightning Component. Failed to retrieve user data.');
            }
        });
        $A.enqueueAction(action);
                
	},   
    
    submitForm : function (component, event, helper) {

        var formData = {};
        var formElement = component.find("signupForm");

		// ADD USER INPUT FIELDS --        
		var lightningInputFields = formElement.find({instancesOf : "lightning:input"});
        
        for (var i = 0; i < lightningInputFields.length; i++)
            formData[lightningInputFields[i].get('v.name')] = lightningInputFields[i].get('v.value');
        
        // ADD SELECT VALUES --
		var lightningSelectFields = formElement.find({instancesOf : "lightning:select"});

        for (var i = 0; i < lightningSelectFields.length; i++)
            formData[lightningSelectFields[i].get('v.name')] = lightningSelectFields[i].get('v.value');
        
        // ADD HIDDEN FIELD VALUES --
        $("#signupForm input").each(function() {
            formData[$(this).attr('name')] = $(this).val();
        });
        
        
        // ENCODE AND SEND TO BACKEND --
        var encodedFormContents = $.param(formData);
        
        var action = component.get("c.sendFormData");
        var updateBackend = component.get("c.formSubmitted");
        
        action.setParams({  
            endpoint_url : component.get("v.endpointURL"),
            body_content : encodedFormContents
        });
        
        // ON SUCCESS OR FAILURE, MANIPULATE FRONTEND --
        
        action.setCallback(this, function(response) {
            var status = response.getReturnValue();
            
            helper.showImage(component, event);
            
            if (status === 302) {
                
				helper.submitResponse(
                    component, 
                    event, 
                    'Thank you for your interest in Einstein Analytics! A member of our sales team will contact you shortly to complete your transaction.'
                );
                
                $A.enqueueAction(updateBackend);
                
                
            } else {
                
				helper.submitResponse(
                    component, 
                    event, 
                    'Seems like something went wrong. Please refresh the page and try again.'
                );
                
            }
        });
        
        $A.enqueueAction(action);
        
    }
   
})