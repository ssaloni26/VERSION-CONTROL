/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-09-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

string tempvar = 'saloni';
System.debug('Hello World!');
System.debug('My name is ' + tempvar);


inheritanceDemo d = new inheritanceDemo();
d.run();


Implementer obj = new Implementer();
obj.run();



//ABSTRACT 
circle c = new circle(5);
System.debug('Area: ' + c.area());
c.describe();


//ENCAPSULATION
BankAccount acc = new BankAccount();
acc.deposit(500);
System.debug(acc.getBalance());  // ✅ Safe
acc.withdraw(1000);              // ❌ Won’t happen if not enough balance


BankManager.simulate();

Got it 👍 This is a **Salesforce automation assignment**.
We need to build logic that, when an **Employee\_\_c** record is created (with an Annual Target), the system automatically:

1. **Splits Annual Target into 4 quarters** (equal split).

   * Example: 120000 → 30000 each quarter.
2. **Creates 4 Performance\_Target\_\_c records** for that employee (Q1, Q2, Q3, Q4).
3. **Populates Start/End dates for each quarter** (based on year).
4. Sets **Status = "Pending"** by default.

---

### 📌 Step 1: Schema Design

**Employee\_\_c**

* Name (Text)
* Annual\_Target\_\_c (Currency)

**Performance\_Target\_\_c**

* Name (Text)
* Quarter\_\_c (Picklist: Q1, Q2, Q3, Q4)
* Start\_Date\_\_c (Date)
* End\_Date\_\_c (Date)
* Target\_Amount\_\_c (Currency)
* Status\_\_c (Picklist → default "Pending")
* Employee\_\_c (Lookup → Employee\_\_c)

---

### 📌 Step 2: Automation (Options)

You can implement using:

1. **Apex Trigger** (preferred: flexible, handles custom logic).
2. **Flow (Record-Triggered Flow)** – if assignment requires declarative.

I’ll give you the **Apex Trigger solution** 👇

---

### 📌 Step 3: Apex Trigger Code

```apex
trigger EmployeeAfterInsert on Employee__c (after insert) {
    List<Performance_Target__c> targetsToInsert = new List<Performance_Target__c>();

    for(Employee__c emp : Trigger.New){
        if(emp.Annual_Target__c != null && emp.Annual_Target__c > 0){
            Decimal quarterlyTarget = emp.Annual_Target__c / 4;
            Integer yearVal = Date.today().year(); 

            // Quarter 1
            targetsToInsert.add(new Performance_Target__c(
                Name = emp.Name + ' - Q1',
                Quarter__c = 'Q1',
                Start_Date__c = Date.newInstance(yearVal, 1, 1),
                End_Date__c = Date.newInstance(yearVal, 3, 31),
                Target_Amount__c = quarterlyTarget,
                Status__c = 'Pending',
                Employee__c = emp.Id
            ));

            // Quarter 2
            targetsToInsert.add(new Performance_Target__c(
                Name = emp.Name + ' - Q2',
                Quarter__c = 'Q2',
                Start_Date__c = Date.newInstance(yearVal, 4, 1),
                End_Date__c = Date.newInstance(yearVal, 6, 30),
                Target_Amount__c = quarterlyTarget,
                Status__c = 'Pending',
                Employee__c = emp.Id
            ));

            // Quarter 3
            targetsToInsert.add(new Performance_Target__c(
                Name = emp.Name + ' - Q3',
                Quarter__c = 'Q3',
                Start_Date__c = Date.newInstance(yearVal, 7, 1),
                End_Date__c = Date.newInstance(yearVal, 9, 30),
                Target_Amount__c = quarterlyTarget,
                Status__c = 'Pending',
                Employee__c = emp.Id
            ));

            // Quarter 4
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

    if(!targetsToInsert.isEmpty()){
        insert targetsToInsert;
    }
}
```

---

### 📌 Step 4: Flow Alternative (Declarative)

If you want to use **Flow** instead of Apex:

1. Create a **Record-Triggered Flow** on Employee\_\_c → When record is created.
2. Use **Assignment** to calculate `AnnualTarget / 4`.
3. Create **4 Create Records elements** (for Q1–Q4) with proper Start/End dates.
4. Default **Status = Pending**.

---

✅ This way, whenever an **Employee\_\_c** record is inserted, the system will **auto-generate 4 quarterly Performance\_Target\_\_c records**.

---

Do you want me to also prepare a **Test Class** for this trigger (for deployment in Salesforce)?







//LWC//


git config --global user.name "Saloni Swami"
git config --global user.email "saloniswami26   072003@gmail.com"