public with sharing class SandboxSetup_PartialCopyBadFields {
    public static Map<SObjectType, Set<SObjectField>> MasterList = new Map<SObjectType, Set<SObjectField>>{
        Account.SObjectType => new Set<SObjectField>{
            Account.AccountManager__c,
            Account.ParentId,
            Account.Customer_Service_Account_Team__c
        },
        Opportunity.SObjectType => new Set<SObjectField>{
            Opportunity.SoldToAccount__c,
            Opportunity.SyncedQuoteId,
            Opportunity.CapacityForecast__c
        }
    };
}