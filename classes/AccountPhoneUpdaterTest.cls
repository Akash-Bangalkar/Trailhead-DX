@isTest
public class AccountPhoneUpdaterTest {
    @isTest
    static void testUpdateAccountPhone() {
        // Create dummy Account data
        Account testAccount = new Account(Name = 'Test Account', Phone = '123-456-7890');
        insert testAccount;

        // Create dummy Contact data related to the Account
        Contact testContact1 = new Contact(
            FirstName = 'John',
            LastName = 'Doe',
            AccountId = testAccount.Id,
            Phone = '987-654-3210'
        );
        Contact testContact2 = new Contact(
            FirstName = 'Jane',
            LastName = 'Smith',
            AccountId = testAccount.Id,
            Phone = '555-555-5555'
        );
        insert new List<Contact>{testContact1, testContact2};

        // Update the Phone field on one of the Contacts
        testContact1.Phone = '111-222-3333';
        update testContact1;

        // Now run the trigger and handler
        // This will invoke the logic to update the Account's Phone field
        Test.startTest();
        testContact2.Phone = '444-444-4444';  // Update the second Contact's Phone
        update testContact2;
        Test.stopTest();
    }
}