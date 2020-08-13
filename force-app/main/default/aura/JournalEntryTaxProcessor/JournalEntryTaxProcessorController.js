({
   doinit: function(component, event, helper) {
       helper.doInitHelper(component, event);
   },
   
   closeModel: function(component, event, helper) {
       // Close the action panel 
       var dismissActionPanel = $A.get("e.force:closeQuickAction"); 
       dismissActionPanel.fire(); 
   },
   
   taxCalculationCtr: function(component, event, helper) {
       console.log('taxCalculation...');
       helper.taxCalculationHelper(component, event);
   },
   
   onChange: function(component, event,helper){
       console.log('onChange...');
       helper.onChangeHelper(component, event);
   },
   
   inlineEditTax : function(component,event,helper){   
       // show the name edit field popup 
       component.set("v.taxEditMode", true); 
       // after the 100 millisecond set focus to input field   
       setTimeout(function(){ 
           component.find("inputId").focus();
       }, 100);
   },
   closeTaxBox : function (component, event, helper) {
       //component.set("v.taxEditMode", false); 
       if(event.getSource().get("v.value").trim() == ''){
           component.set("v.showErrorClass",true);
       }else{
           component.set("v.showErrorClass",false);
       }
   }, 
   // function automatic called by aura:waiting event  
   showSpinner: function(component, event, helper) {
       // make Spinner attribute true for displaying loading spinner 
       component.set("v.spinner", true); 
   },
   
   // function automatic called by aura:doneWaiting event 
   hideSpinner : function(component,event,helper){
       // make Spinner attribute to false for hiding loading spinner    
       component.set("v.spinner", false);
   },
   showInBulk : function(component,event,helper){
        // make Spinner attribute to false for hiding loading spinner    
        console.log('showInBulk...');
        helper.showInBulkHelper(component, event);
    },
})