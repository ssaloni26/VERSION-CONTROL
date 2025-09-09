/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-05-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
**/
public class AccountTrigger {
    public static void handleBeforeInsert(List<Account> newAccounts) {
        fflib_UnitOfWork uow = new fflib_SObjectUnitOfWork(
            Schema.getGlobalDescribe().Values()
        );

        AccountService service = new AccountService(uow);

        for (Account acc : newAccounts) {
            service.createAccountWithContact(acc.Name, 'Default Contact');
        }

        // Only one DML commit!
        uow.commitWork();
    }
}
