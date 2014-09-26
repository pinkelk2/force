global with sharing class ValidateAccessSupport 
{
    public static Boolean disabled = false;
    
//  *****************************************************************

    private static Boolean isSystemCalculated (SObject o, Schema.DescribeFieldResult dfr)
    {
       if (dfr.type == Schema.DisplayType.Address) return true;       
       if (dfr.getByteLength() == 0 && o.get(dfr.getName()) != null) return true;
        return false;
    }
    
//  *****************************************************************

    global static void validateInsertAccess (list<SObject> newTrigger)
    {
        if (disabled) return;
        
        list<Schema.SObjectField> sofs = trigger.new[0].getSObjectType().getDescribe().fields.getMap().values();
        String objectName = trigger.new[0].getSObjectType().getDescribe().getName();

        if (newTrigger[0].getSObjectType().getDescribe().isCreateable() == false)
        {
            newTrigger[0].addError(objectName + ' cannot be created by the current User');
            return;
        }
                
        for (SObject o : newTrigger)
        {           
            for (Schema.SObjectField sof : sofs)
            {   
                Schema.DescribeFieldResult dfr = sof.getDescribe();
                                
                if (dfr.isPermissionable() == true && 
                    dfr.isCalculated() == false && 
                    dfr.isAutoNumber() == false && 
                    isSystemCalculated(o,dfr) == false)
                {                                                   
                    String fieldName = dfr.getName();
                    try
                    {
                        if (o.get(fieldName) != null && dfr.isCreateable() == false && dfr.isAccessible())   
                        {
                            o.addError(objectName + ' ' + fieldName + ' cannot be created by the current User');
                        }
                    }
                    catch (Exception e)
                    {
                        System.debug('Get field exception for ' + fieldName + ' ' + e.getMessage());
                    }
                }
            }
        }
    }
        
//  *****************************************************************

    global static void validateUpdateAccess (list<SObject> newTrigger, map<Id,SObject> oldMap)
    {
        if (disabled) return;
        
        list<Schema.SObjectField> sofs = trigger.new[0].getSObjectType().getDescribe().fields.getMap().values();
        String objectName = trigger.new[0].getSObjectType().getDescribe().getName();

        if (newTrigger[0].getSObjectType().getDescribe().isUpdateable() == false)
        {
            newTrigger[0].addError(objectName + ' cannot be updated by the current User');
            return;
        }

        for (SObject o : newTrigger)
        {   
            for (Schema.SObjectField sof : sofs)
            {
                Schema.DescribeFieldResult dfr = sof.getDescribe();
                
                if (dfr.isPermissionable() == true && 
                    dfr.isCalculated() == false && 
                    dfr.isAutoNumber() == false && 
                    isSystemCalculated(o,dfr) == false)
                {                               
                    String fieldName = dfr.getName();
                    try
                    {
                        if (o.get(fieldName) != oldMap.get(o.Id).get(fieldName) && dfr.isUpdateable() == false) 
                        {
                            o.addError(objectName + ' ' + fieldName + ' cannot be updated by the current User');
                        }
                    }
                    catch (Exception e)
                    {
                        System.debug('Get field exception for ' + fieldName + ' ' + e.getMessage());
                    }
                }
            }
        }       
    }
}
