trigger ClosedOpportunityTrigger on Opportunity (before insert, before update) {
	List<Task> tskList = new List<Task>();
    for(Opportunity opp: Trigger.New){
        if(opp.StageName == 'Closed Won'){
            task tsk = new task();
            tsk.subject = 'Follow Up Test Task';
            tsk.whatId = opp.Id;
            tskList.add(tsk);
        }
    }
    insert tskList;
}