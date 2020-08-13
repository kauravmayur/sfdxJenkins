public class DynamicTableController {
    List<SelectOption> allSobjects{get; set;}
    public DynamicTableController(){
        Map<String, Schema.SObjectType> gd = Schema.getGlobalDescribe();
        set<String> sObjects = gd.KeySet();
        for(Schema.SObjectType so: ProcessInstance.TargetObjectId.getDescribe().getReferenceTo()) {
            
        }
    }
}