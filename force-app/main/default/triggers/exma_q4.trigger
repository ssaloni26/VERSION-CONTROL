/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-08-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
//On Opportunity insert/update, 
//update a custom field Total_Opportunities__c on the related Account to show the total number of Opportunities for that account.
trigger exma_q4 on Opportunity (before insert,before update ) {
    if(trigger.isupdate && trigger.isinsert && trigger.isbefore)
    {
        Exam_q4_handler.handler();
    }
}