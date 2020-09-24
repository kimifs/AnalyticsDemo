({
	getTaskList : function(component, event, helper) {

        var action = component.get("c.queryRecords");
        
        action.setCallback(this, function(response) {
           	var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                
                storeResponse.taskList.forEach (function (task) {
                    if (task.Is_Completed__c) {
                        task.iconName = "action:approval";
                        task.crossOut = "crossOut";
                    } else {
                        task.iconName = "action:check";
                        task.crossOut = "";
                    }
                });
                
                component.set("v.taskList", storeResponse.taskList);
            }
        });
        
        $A.enqueueAction(action);
        
	},
    
    taskClick : function(component, event, helper) {
        
        var currentElement = event.currentTarget;
        var taskId = event.currentTarget.dataset.taskId;
        var markCompleted = event.currentTarget.dataset.isChecked == "true" ? false : true;
        var actionLink = event.currentTarget.dataset.actionUrl;
        
        if (actionLink != null && markCompleted == true) {
            var win = window.open(actionLink, '_blank');
            win.focus();
        }

        var action = component.get("c.toggleStatus");
        
        action.setParams({
            taskId : taskId,
            status : markCompleted
        });

        action.setCallback(this, function(response) {
           	var state = response.getState();
            if (state === "SUCCESS") {
                var storeResponse = response.getReturnValue();
                $A.enqueueAction(component.get("c.getTaskList"));
            }
        });
        
        $A.enqueueAction(action);

        
    }

    
})