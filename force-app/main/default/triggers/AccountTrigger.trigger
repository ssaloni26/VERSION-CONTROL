trigger AccountTrigger on Account (before insert, after insert, before update, after update) {
    AccountTriggerHandler handler = new AccountTriggerHandler(Trigger.isExecuting, Trigger.size);

    if (Trigger.isInsert) {
        if (Trigger.isBefore) {
            handler.OnBeforeInsert(Trigger.new);
        } else {
            handler.OnAfterInsert(Trigger.new);
        }
    }
    if (Trigger.isUpdate) {
        if (Trigger.isBefore) {
            handler.OnBeforeUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        } else {
            handler.OnAfterUpdate(Trigger.new, Trigger.old, Trigger.newMap, Trigger.oldMap);
        }
    }
}
