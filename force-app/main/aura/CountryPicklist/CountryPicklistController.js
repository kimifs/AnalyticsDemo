({
    
    initializePicklists : function (component, event, helper) {

        var action = component.get("c.getListData");

        action.setCallback(this, function(response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                helper.picklistSetup(component, storeResponse, "US");                  
            }   
        });
        
        $A.enqueueAction(action);
        
    },
    
	countryUpdated : function(component, event, helper) {
		helper.toggleShowStates(component, event);
		helper.toggleShowOptIn(component, event);
    }
    
})