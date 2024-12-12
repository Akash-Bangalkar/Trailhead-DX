@isTest
public class AccountRevenueUpdaterTest {
    @isTest
    static void testUpdateAccountRevenue() {
        // Create a test Account
        Account testAccount = new Account(Name = 'Test Account');
        insert testAccount;

        // Create test Opportunities related to the Account
        Opportunity opp1 = new Opportunity(
            Name = 'Test Opportunity 1',
            StageName = 'Closed Won',
            Amount = 5000,
            AccountId = testAccount.Id,
            CloseDate = Date.today()
        );
        Opportunity opp2 = new Opportunity(
            Name = 'Test Opportunity 2',
            StageName = 'Closed Won',
            Amount = 7000,
            AccountId = testAccount.Id,
            CloseDate = Date.today()
        );
        insert new List<Opportunity>{opp1, opp2};

        // Query the Account to check initial AnnualRevenue
        Account accountBeforeUpdate = [SELECT AnnualRevenue FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(0, accountBeforeUpdate.AnnualRevenue, 'Initial AnnualRevenue should be 0.');

        // Call the method to update the Account's AnnualRevenue
        Test.startTest();
        AccountRevenueUpdater.updateAccountRevenue(testAccount.Id);
        Test.stopTest();

        // Query the Account again after the update
        Account accountAfterUpdate = [SELECT AnnualRevenue FROM Account WHERE Id = :testAccount.Id];

        // Verify that the Account's AnnualRevenue is updated correctly
        System.assertEquals(12000, accountAfterUpdate.AnnualRevenue, 'The Account AnnualRevenue should be updated to the sum of the closed-won Opportunities.');
    }

    @isTest
    static void testAccountWithNoClosedWonOpportunities() {
        // Create a test Account with no related Closed Won Opportunities
        Account testAccount = new Account(Name = 'Test Account No Opportunities');
        insert testAccount;

        // Create Opportunities with a stage other than 'Closed Won'
        Opportunity opp1 = new Opportunity(
            Name = 'Test Opportunity 1',
            StageName = 'Prospecting',
            Amount = 5000,
            AccountId = testAccount.Id,
            CloseDate = Date.today()
        );
        Opportunity opp2 = new Opportunity(
            Name = 'Test Opportunity 2',
            StageName = 'Negotiation',
            Amount = 7000,
            AccountId = testAccount.Id,
            CloseDate = Date.today()
        );
        insert new List<Opportunity>{opp1, opp2};

        // Query the Account to check if the AnnualRevenue is 0 as no 'Closed Won' Opportunities exist
        Account account = [SELECT AnnualRevenue FROM Account WHERE Id = :testAccount.Id];
        System.assertEquals(0, account.AnnualRevenue, 'The AnnualRevenue should remain 0 as no closed-won Opportunities exist.');
    }
}