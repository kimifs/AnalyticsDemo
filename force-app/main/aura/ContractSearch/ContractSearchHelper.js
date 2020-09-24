({
    searchContracts : function(component, event, helper) {
        var selectInput = component.find('select').get('v.value');
        console.log(selectInput);
        if(selectInput == "Tenant"){
            var action = component.get("c.searchByTenant");
            var tenantNameInput = component.get("v.searchInput");
            console.log(tenantNameInput);
            action.setParams({
                "tenantName" : tenantNameInput
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log(state);
                if(state == "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(result);
                    console.log(result.length);
                    if(result.length==0)
                    {
                        console.log("No Such Result Found. Try using some other name");
                        component.set("v.catchEmptyResult","No results were found."); 
                        component.set("v.contractsResult",null); 
                        
                    }
                    else
                    {
                        component.set("v.catchEmptyResult","");      
                        component.set("v.contractsResult", result);   
                        
                    }
                    
                } 
                //else if(state == "RUNNING"){
                  //  component.set("v.loaded", "true");
               // }
                    else{
                    
                    console.log("ERROR");
                }
            });
            $A.enqueueAction(action);
        }
        else
        {
            var action = component.get("c.searchByBuilding");
            var buildingNameInput = component.get("v.searchInput");
            action.setParams({
                "buildingName" : buildingNameInput
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                console.log(state);
                if(state == "SUCCESS") {
                    var result = response.getReturnValue();
                    console.log(result);
                    console.log(result.length);
                    if(result.length==0)
                    {
                        console.log("No Such Result Found. Try using some other name");
                        component.set("v.catchEmptyResult","No results were found."); 
                        component.set("v.contractsResult",null); 
                    }
                    else
                    {
                        component.set("v.catchEmptyResult","");      
                        component.set("v.contractsResult", result);   
                        
                    }
                    
                } else {
                    console.log("ERROR");
                }
            });
            $A.enqueueAction(action);
        }
    },
    
    
})