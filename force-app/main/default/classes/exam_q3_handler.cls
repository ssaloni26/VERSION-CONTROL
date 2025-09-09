/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-04-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class exam_q3_handler {
    //Write a trigger on Account that auto-creates a Contact with FirstName = 'Default' and LastName = Account.Name when a new Account is created.
    public static void handler(list<account> accRecords) {
        if(!accRecords.isEmpty())
        {
            

            

            list<contact> contactsToInsert= new list<contact>();
            
            for(account ac : accRecords)
            {
            Contact con = new Contact(
                FirstName = 'oooooooo',
                LastName = 'kkkkkkkk',
                AccountId = ac.Id
            );


            contactsToInsert.add(con);
            }
            if (!contactsToInsert.isEmpty()) {
            insert contactsToInsert;
            }
        }
    }
}