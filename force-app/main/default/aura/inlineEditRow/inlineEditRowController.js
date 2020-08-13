({
    inlineEditTax : function(component,event,helper){   
        // show the name edit field popup 
        component.set("v.taxEditMode", true); 
        // after the 100 millisecond set focus to input field   
        setTimeout(function(){ 
            component.find("inputId").focus();
        }, 100);
    },
    
    
    closeTaxBox : function (component, event, helper) {
      // on focus out, close the input section by setting the 'taxEditMode' att. as false   
        component.set("v.taxEditMode", false); 
      
    }, 
    
    
   
})