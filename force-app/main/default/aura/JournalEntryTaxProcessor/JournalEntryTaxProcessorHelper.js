({
    /* doInitHelper funcation to fetch all records, and set attributes value on component load */
    doInitHelper : function(component, event, helper) {
        console.log('doInit Helper...');
        //var recordId = component.get("v.recordId");
        var recordId = "a067F00000VbSFT";
        var action = component.get("c.getJournalEntryDetails");
        console.log('recordId...'+recordId);
        action.setParams({"journalEntryId":recordId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var oRes = response.getReturnValue();
            console.log('state...'+state);
            console.log('response : '+oRes.errorMesaage);
            if(state === "SUCCESS"){
                if(oRes.errorMesaage ==''){
                    component.set("v.showError",false);
                }
                console.log('doInitHelper response.getReturnValue()----'+response.getReturnValue());
                console.log('Component has been set here...');
                
                component.set("v.taxWrapper", oRes);
                component.set("v.journalEntry", oRes.journalEntryWapperList);
                var taxwrap = component.get("v.taxWrapper", oRes);
                
                
                
                window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                        component.find("tax").set("v.value",component.get("v.taxWrapper").taxType);
                    }));
            }
            
        });
        $A.enqueueAction(action);
    },
    taxCalculationHelper : function(component, event) {
        console.log('taxCalculation Helper...');
        
        
        var wrapper = component.get("v.taxWrapper");
        //var recordId = component.get("v.recordId");
        var recordId = "a067F00000VbSFT";
        var values = component.get("v.values");
        
        var action = component.get("c.taxCalculation");
        var message = '';
        var totalDebit = 0;
        var totalCredit = 0;
        
        console.log('values : '+values);
        for(var i in wrapper.journalEntryWapperList){
            
            if(wrapper.journalEntryWapperList[i].amountType == 'Cr'){
                totalCredit = parseInt(totalCredit)+ parseInt(wrapper.journalEntryWapperList[i].taxAmount);
                console.log("totalCredit : "+totalCredit);
                console.log("total Amount : "+wrapper.journalEntryWapperList[i].totalAmount);
                if(totalCredit > wrapper.journalEntryWapperList[i].totalAmount){
                    if(!message.includes('Less Credit amount')){
                        message = message+  '\n'+'Less Credit amount';
                    }
                }
            }
            if (wrapper.journalEntryWapperList[i].amountType == 'Dr'){
                totalDebit = parseInt(totalDebit)+ parseInt(wrapper.journalEntryWapperList[i].taxAmount);
                console.log("totalDebit : "+totalDebit);
                console.log("total Amount : "+wrapper.journalEntryWapperList[i].totalAmount);
                if(totalDebit > wrapper.journalEntryWapperList[i].totalAmount){
                    if(!message.includes('Less Debit amount')){
                        message = message+  '\n'+'Less Debit amount';
                    }
                }
            }
            
            
        }
        console.log("message : "+message);
        if(message !==''){
            component.find('notifLib').showNotice({
                "variant": "error",
                "header": "Something has gone wrong!",
                "message": message
                
            });
        }else{
            action.setParams({
                "entryId":recordId,
                "entryTaxWrapper" : JSON.stringify(wrapper.journalEntryWapperList),
                "taxrecordId":values
            });
            action.setCallback(this, function(response){
                var state = response.getState();
                var toastEvent = $A.get("e.force:showToast");
                var title = '';
                var type = '';
                var message = '';
                if(state === "SUCCESS"){
                    var oRes = response.getReturnValue();
                    if(oRes != ''){
                        title = 'Error!';
                        type = 'error';
                        message = oRes;
                    }
                    else{
                        title = 'Success!';
                        type = 'success';
                        message = 'Updated Successfully'
                    }
                }else{
                    toastEvent.setParams({
                        "title": "Error!",
                        "type":"error",
                        "message": 'Contact Admin Support'
                    });
                }
                toastEvent.fire();
                $A.get("e.force:closeQuickAction").fire();
                $A.get('e.force:refreshView').fire();
            });
            $A.enqueueAction(action);
        }
        
        
        
    },
    onChangeHelper: function(component, event) {
        console.log('onChange Helper...');
        
        var values = component.get("v.values");
        var taxWrapper = component.get("v.taxWrapper");
        var taxWrapList = taxWrapper.journalEntryWapperList;
        var action = component.get("c.onChangefetchTaxes");
        var recordId = component.get("v.recordId");
        action.setParams(
            {"taxWrapString":JSON.stringify(component.get("v.journalEntry")),
             "taxRecordId" : values,
             "journalEntryId":recordId 
            });
        
        action.setCallback(this, function(response){
            var state = response.getState();
            if(state === "SUCCESS"){
                var state = response.getState();
                var oRes = response.getReturnValue();
                component.set("v.taxWrapper.journalEntryWapperList", oRes);
            }
            
        });
        $A.enqueueAction(action);
    },
    showToast : function(component, event, title, type, message) {
        var toastEvent = $A.get("e.force:showToast");
        toastEvent.setParams({
            "title": title,
            "type":type,
            "message": message
        });
        toastEvent.fire();
    },
    showInBulkHelper : function(component, event, helper) {
        console.log('showInBulk Helper...');
        //var recordId = "a067F00000VbSFT";
        var action = component.get("c.getAllJournalEntryLine");
        //console.log('recordId...'+recordId);
        //action.setParams({"journalEntryId":recordId});
        
        action.setCallback(this, function(response){
            var state = response.getState();
            var oRes = response.getReturnValue();
            console.log('state...'+state);
            console.log('response : '+oRes);
            if(state === "SUCCESS"){
                console.log('doInitHelper response.getReturnValue()----'+response.getReturnValue());
                console.log('Component has been set here...');
                /*
                component.set("v.taxWrapper", oRes);
                component.set("v.journalEntry", oRes.journalEntryWapperList);
                var taxwrap = component.get("v.taxWrapper", oRes);
                
                
                
                window.setTimeout(
                    $A.getCallback( function() {
                        // Now set our preferred value
                        component.find("tax").set("v.value",component.get("v.taxWrapper").taxType);
                    }));
                */
            }
            
        });
        $A.enqueueAction(action);
    }
})