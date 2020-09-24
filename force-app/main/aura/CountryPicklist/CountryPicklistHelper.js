({
    
    picklistSetup : function (component, list_data, default_iso) {
        
        list_data.worldCountries.forEach( function(country) {
            country.isSelected = false;
            if (country.ISO_Code__c === default_iso) {
                country.isSelected = true;
            }
        });

        component.set("v.countryList", list_data.worldCountries);
        component.set("v.stateList", list_data.usStates);
        
        if (default_iso === "US") {
            $A.util.removeClass(component.find("formCountryState"), "toggle");
        }
        
    },
    
	toggleShowStates : function(component, event) {
        if (component.find("formCountry").get("v.value") === "US") {
            $A.util.removeClass(component.find("formCountryState"), "toggle");
        } else {
            component.find("formCountryState").set("v.value", "");
            $A.util.addClass(component.find("formCountryState"), "toggle");
        }
	},
    
    toggleShowOptIn : function(component, event) {

        var locValue = component.find("formCountry").get("v.value"),
            locList = component.get("v.countryList"),
            isOptIn;
        
        for (let c of locList) {
            if (c.ISO_Code__c == locValue) { 
                isOptIn = c.Email_Opt_In__c; break;
            }
        }

        component.set("v.showOptIn", isOptIn);
    }
    
})