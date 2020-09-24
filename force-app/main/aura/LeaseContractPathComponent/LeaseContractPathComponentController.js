({
    doInit: function(component,event,helper) {
        
        var action = component.get("c.getStage");
        var rId = component.get("v.recordId");
        action.setParams({
            "recId":rId
        })
        action.setCallback(this, function(response){
            var state = response.getState(); 
            console.log(state);
            if(state == "SUCCESS") {
                console.log(state);
                var result = response.getReturnValue();
                console.log(result);
             	component.set("v.currentStage", result);
            } 
            
            else{
                
                console.log("ERROR");
            }
        });
        $A.enqueueAction(action);
    }
    
})