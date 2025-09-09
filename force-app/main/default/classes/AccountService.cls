/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : 
 * @last modified on  : 09-08-2025
 * @last modified by  : ChangeMeIn@UserSettingsUnder.SFDoc
 * 
**/
public class AccountService {
    private fflib_UnitOfWork uow;

    public AccountService(fflib_UnitOfWork uow) {
        this.uow = uow;
    }

    public void createAccountWithContact(String accName, String conName) {
        // Create Account
        Account acc = new Account(Name = accName);
        uow.registerNew(acc);

        // Create Contact (related)
        Contact con = new Contact(LastName = conName, Account = acc);
        uow.registerNew(con);
    }
}
