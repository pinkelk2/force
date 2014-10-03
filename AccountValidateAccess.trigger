trigger AccountValidateAccess on Account (after insert, after update) 
{
    if (trigger.isInsert) ValidateAccessSupport.validateInsertAccess (trigger.new);
    if (trigger.isUpdate) ValidateAccessSupport.validateUpdateAccess (trigger.new, trigger.oldMap);
}
