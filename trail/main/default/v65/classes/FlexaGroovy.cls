public class FlexaGroovy
{
    public void main(String accName)
    {
        System.debug(ApexUtilSalesforce.getRating(accName));
        List<Group> allGroups = [SELECT Id FROM Group];
    }
    
    public static void setTickerSymbol()
    {
        List<Account> allAccounts = [SELECT Id, Name, TickerSymbol FROM Account];
        
        for (Account acc : allAccounts)
        {
            String accRating = ApexUtilSalesforce.getRating(acc.Name);
            // String accRating = 'Hot';
            
            if (accRating == 'Hot')
            {
                acc.TickerSymbol = 'H'; // setter
            }
            else if (accRating == 'Warm')
            {
                acc.TickerSymbol = 'W';
            }
            else if (accRating == 'Cold')
            {
                acc.TickerSymbol = 'C';
            }
        }
        
        if (allAccounts.size() > 0)
        {
            Update allAccounts;
        }
    }
    
    public static void setContactActive(List<Account> accList, Map<Id, Account> oldMap)
    {
        Set<Id> accId = new Set<Id>();
        
        for (Account acc : accList)
        {
            Account oldRec = oldMap.get(acc.Id);
            
            if (acc.Rating == 'Hot' && acc.Rating != oldMap.get(acc.Id).Rating)
            {
                accId.add(acc.Id);
            }
        }
        
        if (!accId.isEmpty()) // accId.size() > 0
        {
            List<Contact> subContacts = [SELECT Id, Active__c FROM Contact WHERE AccountId IN :accId];
            
            if (!subContacts.isEmpty()) // subContacts.size() > 0
            {
                for (Contact c : subContacts)
                {
                    c.Active__c = true;
                }
                
                Update subContacts;
            }
        }
    }
}