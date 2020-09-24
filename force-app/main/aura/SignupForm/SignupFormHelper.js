({
	submitResponse : function(component, event, message) {
        
        $('.signup-form').hide();
        $('.signup-form-message').fadeOut(200,
            function () {
                $('.signup-form-message').text(message);
            }).fadeIn();
        
	},
    
    alreadySubmittedResponse: function(component, event, message) {
    
        $('.signup-form').hide();
        $('.signup-form-message').hide();
        $('.signup-form-message').text(message);
        $('.signup-form-message').show();
        
	},
    
    toggleStatePicklist : function(component, event) {
        if (component.find("formCountry").get("v.value") === "US") {
            $A.util.removeClass(component.find("formCountryState"), "toggle");
        } else {
            component.find("formCountryState").set("v.value", "");
            $A.util.addClass(component.find("formCountryState"), "toggle");
        }
	},
    
    showImage : function (component, event) {
        
        var formImage = $A.get('$Resource.FormImage');
        var $imageDiv = $("<div></div>").addClass("placeholder-image");

        $imageDiv.css({
            'background' : 'url("' + formImage + '")',
            'background-size' : 'cover', 
            'background-position' : 'right bottom'
        });

        $('.signup-form').after($imageDiv);
    }
    
    
})