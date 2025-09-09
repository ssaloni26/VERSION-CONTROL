public virtual with sharing class xase_trigger_handler extends TriggerHandler {
    public override void beforeInsert()
    {
        Class_Utility.updatecasesubject(trigger.new);
        Class_Utility.createcase(); 
    }
}