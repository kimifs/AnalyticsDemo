({
	getHide : function(component, event, helper) {

        var action = component.get("c.getHideMessage");
        
        action.setCallback(this, function(response) {
           	var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                component.set("v.hideMessage", storeResponse.hideMessage);
            }
        });
        
        $A.enqueueAction(action);
	}
})