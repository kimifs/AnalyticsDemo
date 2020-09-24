({
	getDaysLeftInTrial : function(component, event, helper) {
		
        var action = component.get("c.getDaysLeft");
        
        action.setCallback(this, function(response) {
           	var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.daysLeft", storeResponse.DaysLeft);
            }
        });
        
        $A.enqueueAction(action);
        
	}
})