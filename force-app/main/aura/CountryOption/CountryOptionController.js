({
	fireEvent : function(component, event, helper) {
		var p = component.getEvent("push");
        console.log(component.get("v.label"), " : ", component.get("v.opt_in"));
        if (component.get("v.is_selected") === true) {
            p.setParams({
                optInStatus: component.get("v.opt_in")
            }).fire();
        }
    }
})