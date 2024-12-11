public class AccountDetailsLwc {
    @AuraEnabled(cacheable=true)
    public static Account getStockDetails(ID recordId) 
    {
        return [SELECT ID, Name FROM Account WHERE ID = :recordId];
    }
}