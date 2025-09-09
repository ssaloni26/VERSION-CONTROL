/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-02-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public with sharing class EmployeeAfterInserthandler {
    public EmployeeAfterInserthandler(List<Employee__c> newList)
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
                        Start_Date__c= this.quarterStart(1, yearVal),
                        End_Date__c = this.quarterEnd(1, yearVal),
                        Target_Amount__c = quarterlyTarget,
                        Status__c = 'Pending',
                        Employee__c = emp.Id
                    ));
                    
                    targetsToInsert.add(new Performance_Target__c(
                        Name = emp.Name + ' - Q2',
                        Quarter__c = 'Q2',
                        Start_Date__c = this.quarterStart(2, yearVal),
                        End_Date__c = this.quarterEnd(2, yearVal),
                        Target_Amount__c = quarterlyTarget,
                        Status__c = 'Pending',
                        Employee__c = emp.Id
                    ));


                    targetsToInsert.add(new Performance_Target__c(
                        Name = emp.Name + ' - Q3',
                        Quarter__c = 'Q3',
                        Start_Date__c = this.quarterStart(3, yearVal),
                        End_Date__c = this.quarterEnd(3, yearVal),
                        Target_Amount__c = quarterlyTarget,
                        Status__c = 'Pending',
                        Employee__c = emp.Id
                    ));

                    targetsToInsert.add(new Performance_Target__c(
                        Name = emp.Name + ' - Q4',
                        Quarter__c = 'Q4',
                        Start_Date__c = this.quarterStart(4, yearVal),
                        End_Date__c = this.quarterEnd(4, yearVal),
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