public with sharing class SandboxSetup_PartialCopyBadFields {
    public static Map<SObjectType, Set<SObjectField>> MasterList = new Map<SObjectType, Set<SObjectField>>{
        Account.SObjectType => new Set<SObjectField>{
            //Account.AccountManager__c,
            Account.ParentId
        },
        Opportunity.SObjectType => new Set<SObjectField>{
            Opportunity.SyncedQuoteId
        }
        //add more objects and fields as needed
    };
}
