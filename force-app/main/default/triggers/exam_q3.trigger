/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-04-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
trigger exam_q3 on Account (after insert) {
//Write a trigger on Account that auto-creates a Contact with FirstName = 'Default' and LastName = Account.Name when a new Account is created.
    if(trigger.isinsert && trigger.isafter)
    {
        exam_q3_handler.handler(trigger.new);
    }




}