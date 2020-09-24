({
    handleSearchClick : function(component, event, helper) {
        helper.searchContracts(component, event, helper);
        
    },
    showSpinner: function(component, event, helper) {
        component.set("v.Spinner", true); 
    },
    
    hideSpinner : function(component,event,helper){
        component.set("v.Spinner", false);
    },
    print: function(component,event,helper){
        var myWindow=window.open('','','width=1000,height=1000');
        myWindow.focus();
        //   myWindow.close();
        //     var hasFocus = myWindow.hasFocus();
        //     console.log(hasFocus);
           window.print();
        
      //  myWindow.print();
        //    myWindow.close();
        //     myWindow.document.close(); 
              
    },
    
      
    })