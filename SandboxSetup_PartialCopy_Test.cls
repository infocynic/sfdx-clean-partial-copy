@isTest
public with sharing class SandboxSetup_PartialCopy_Test {
    @isTest
    static void CanConstructForAllDefinedConfigurations() {
        Test.startTest();
        for (SObjectType sType : SandboxSetup_PartialCopyBadFields.MasterList.keyset()) {
            SandboxSetup_PartialCopy pc = new SandboxSetup_PartialCopy(
                sType,
                SandboxSetup_PartialCopyBadFields.MasterList.get(sType)
            );
            AssertHelper.ContainsInsensitive(pc.query, 'FROM ' + string.valueOf(sType));
            List<SObject> queryResults = Database.query(pc.query);
            System.assertNotEquals(null, queryResults);
        }
        Test.stopTest();
    }

    @isTest
    static void CanFindABadAccountIdInAContact() {
        //we need bad data, let's go abuse the fact that test.getStandardPricebookId() only returns a 'valid-looking' ID, not an actual ID
        //to a pricebook that doesn't really exist.

        //we need a product id
        Product2 p1 = new Product2(Name = 'Test', IsActive = false);
        insert p1;

        //create but do not insert the pricebookentry (we don't actually need it inserted)
        PricebookEntry pbe = new PricebookEntry(
            Product2Id = p1.Id,
            Pricebook2Id = Test.getStandardPricebookId(),
            UnitPrice = 0
        );

        //create an instance of the batch class specifically coded for this field
        SandboxSetup_PartialCopy pc = new SandboxSetup_PartialCopy(
            PricebookEntry.SObjectType,
            new Set<SObjectField>{ PricebookEntry.Pricebook2Id }
        );

        Test.startTest();
        List<SObject> badPbes = pc.checkForInvalidReferences(new List<PricebookEntry>{ pbe });
        Test.stopTest();

        System.assertEquals(1, badPbes.size());
        System.assertEquals(null, ((PricebookEntry) badPbes[0]).Pricebook2Id);
    }

    @isTest
    static void ThisTestIsARealBatch() {
        SandboxSetup_PartialCopy pc = new SandboxSetup_PartialCopy(
            Contact.SObjectType,
            new Set<SObjectField>{ Contact.AccountId }
        );

        Test.startTest();
        Database.executeBatch(pc);
        Test.stopTest();

        //just getting coverage for all the batch methods that we need to invoke.
    }
}