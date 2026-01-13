trigger AccountTrigger on Account (before insert, after update)
{
	if (trigger.isBefore)
    {
        if (trigger.isInsert)
        {
            ApexUtilSalesforce.checkDuplicateAccByName(trigger.new);
        }
    }
    else if (trigger.isAfter)
    {
        if (trigger.isUpdate)
        {
            FlexaGroovy.setContactActive(trigger.new, trigger.oldMap);
        }
    }
}