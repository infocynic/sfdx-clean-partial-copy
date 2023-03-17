public with sharing class SandboxSetup_PartialCopy implements Database.Batchable<SObject>, Database.Stateful {
    @testVisible
    private string query;
    private SObjectType objType;
    private Set<SObjectField> badFields;

    public SandboxSetup_PartialCopy(SObjectType oType, Set<SObjectField> fields) {
        query = 'SELECT Id,';
        string whereClause = ' WHERE';
        for (SObjectField oField : fields) {
            string fieldName = string.valueOf(oField);
            string relField = oField.getDescribe().getRelationshipName() + '.Id';
            query += ' ' + fieldName + ', ' + relField + ',';
            whereClause += ' (' + fieldName + ' != null AND ' + relField + ' = null) OR';
        }
        whereClause = whereClause.removeEnd(' OR');
        query = query.removeEnd(',');
        query += ' FROM ' + string.valueOf(oType) + whereClause;
        System.debug(query);

        objType = oType;
        badFields = fields;
    }

    public Database.QueryLocator start(Database.BatchableContext context) {
        return Database.getQueryLocator(query);
    }

    public void execute(Database.BatchableContext context, List<SObject> objects) {
        List<SObject> toUpdate = checkForInvalidReferences(objects);
        if (toUpdate.size() > 0) {
            //DebugHelper.debug('Datahelper', 'partialcopy', string.valueOf(oType), toUpdate);
            Database.update(toUpdate, false);
        }
    }

    public void finish(Database.BatchableContext param1) {
    }

    @testVisible
    private List<SObject> checkForInvalidReferences(List<SObject> objects) {
        List<SObject> toUpdate = new List<SObject>();
        for (SObject so : objects) {
            for (SObjectField oField : badFields) {
                string fieldName = string.valueOf(oField);
                object lookupValue = so.get(fieldName);
                object lookupObject = so.getSObject(oField.getDescribe().getRelationshipName());
                if (lookupValue != null && lookupObject == null) {
                    //we have an ID but the related record Id is null; this can only happen b/c of partial copy shenanigans
                    so.put(fieldName, null);
                    toUpdate.add(so);
                }
            }
        }
        return toUpdate;
    }
}