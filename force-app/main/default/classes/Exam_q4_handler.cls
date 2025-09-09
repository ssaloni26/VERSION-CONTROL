/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-07-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/




//On Opportunity insert/update, 
//update a custom field Total_Opportunities__c on the related Account to show the total number of Opportunities for that account.
public class Exam_q4_handler {
    public static void  handlesss(list<Opportunity> oppRecords) {
        if(!oppRecords.isEmpty())
        {
        

        // Count all Opportunities related to this Account
        Integer totalOpps = [
            SELECT COUNT()
            FROM Opportunity
            ];


        for(Opportunity opp: oppRecords)
        {
            opp.Total_Opportunities__c=totalOpps;
        }
        }
    }
}