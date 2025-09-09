public with sharing class AccountTriggerHandler {
    private Boolean isExecuting;
    private Integer batchSize;

    public AccountTriggerHandler(Boolean isExecuting, Integer size) {
        this.isExecuting = isExecuting;
        this.batchSize = size;
    }

    public void OnBeforeInsert(List<Account> newList) {
        System.debug('OnBeforeInsert logic here');
    }

    public void OnAfterInsert(List<Account> newList) {
        System.debug('OnAfterInsert logic here');
    }
    
    public void OnBeforeUpdate(List<Account> newList, List<Account> oldList, 
                               Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        System.debug('OnBeforeUpdate logic here');
    }

    public void OnAfterUpdate(List<Account> newList, List<Account> oldList, 
                              Map<Id, Account> newMap, Map<Id, Account> oldMap) {
        System.debug('OnAfterUpdate logic here');
        AccountHelper.updateRelatedContacts(newList);
    }
}
