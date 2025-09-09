/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 08-01-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class exam {
    //naming conventions for exam both class and method
    //public void exam {
public static void exam() {

    DateTime thresholdDate = System.now().addDays(-30);
// Should be under null loop
//naming conventions for casess
list<case> casess=[SELECT Id, Status, Reason,
                   (SELECT Id FROM Tasks),
                   (SELECT Id FROM Events)
            FROM Case
            WHERE Status != 'Closed'
              AND LastModifiedDate <= :thresholdDate
        ];

//list<task> taskss = new list<>();
list<case> taskss = new list<case>();
//naming conventions for c
for(case c : casess){
    // && is WRONG and it should be ||
if (c.Tasks.isEmpty() && c.Events.isEmpty())
    {
    c.status ='closed';
    c.reason = 'no activity ';
    taskss.add(c);
    }
}
// Should be under null loop
update taskss;}
}