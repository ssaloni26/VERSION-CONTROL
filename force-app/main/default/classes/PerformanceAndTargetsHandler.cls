/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-02-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class EmployeeAfterInsert {
    public handler(List<Employee__c> newList)
    {

        if(!newList.isEmpty() && newList!=null)
        {
            List<Performance_Target__c> targetsToInsert = new List<Performance_Target__c>();
            
            for(Employee__c emp : newList){

                if(Annual_Target__c!=null && Annual_Target__c > 0){
                    
                    Decimal quarterlyTarget = emp.Annual_Target__c / 4;
                    Integer yearVal = Date.today().year(); 

                    
                    targetsToInsert.add(new Performance_Target__c(
                        Name = emp.Name + ' - Q1',
                        Quarter__c = 'Q1',
                        Start_Date__c = Date.newInstance(yearVal, 1, 1),
                        End_Date__c = Date.newInstance(yearVal, 3, 31),
                        Target_Amount__c = quarterlyTarget,
                        Status__c = 'Pending',
                        Employee__c = emp.Id
                    ));
                    
                    targetsToInsert.add(new Performance_Target__c(
                        Name = emp.Name + ' - Q2',
                        Quarter__c = 'Q2',
                        Start_Date__c = Date.newInstance(yearVal, 4, 1),
                        End_Date__c = Date.newInstance(yearVal, 6, 31),
                        Target_Amount__c = quarterlyTarget,
                        Status__c = 'Pending',
                        Employee__c = emp.Id
                    ));


                    targetsToInsert.add(new Performance_Target__c(
                        Name = emp.Name + ' - Q3',
                        Quarter__c = 'Q3',
                        Start_Date__c = Date.newInstance(yearVal, 7, 1),
                        End_Date__c = Date.newInstance(yearVal, 9, 31),
                        Target_Amount__c = quarterlyTarget,
                        Status__c = 'Pending',
                        Employee__c = emp.Id
                    ));

                    targetsToInsert.add(new Performance_Target__c(
                        Name = emp.Name + ' - Q4',
                        Quarter__c = 'Q4',
                        Start_Date__c = Date.newInstance(yearVal, 10, 1),
                        End_Date__c = Date.newInstance(yearVal, 12, 31),
                        Target_Amount__c = quarterlyTarget,
                        Status__c = 'Pending',
                        Employee__c = emp.Id
                    ));
                
                }


            }
            If(!targetsToInsert.isEmpty())
            {
                insert targetsToInsert;
            }
        }
    }
}