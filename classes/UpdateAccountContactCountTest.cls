@isTest
public class UpdateAccountContactCountTest {
    @isTest
    static void testContactCountUpdate() {
        // Create a test account
        Account acc = new Account(Name = 'Test Account');
        insert acc;
        
        // Dummy Method Call
        ApexUtilSalesforce.checkName(acc.Name);
        
        // Create test contacts linked to the account
        List<Contact> contacts = new List<Contact>{
            new Contact(FirstName = 'John', LastName = 'Doe', AccountId = acc.Id),
            new Contact(FirstName = 'Jane', LastName = 'Doe', AccountId = acc.Id)
        };

        Test.startTest();
        // Insert contacts
        insert contacts;
        Test.stopTest();

        // Retrieve the account and verify the contact count
        acc = [SELECT Id, NumberOfEmployees FROM Account WHERE Id = :acc.Id];
        System.assertEquals(2, acc.NumberOfEmployees, 'Contact count should be 2.');

        // Delete a contact
        Test.startTest();
        delete contacts[0];
        Test.stopTest();
    }
}