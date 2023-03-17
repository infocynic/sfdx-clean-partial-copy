@isTest
public with sharing class SandboxSetup_PartialCopyBadFields_Test {
    //this placebo test is to enable rapid deployment of a change to the class under test, which 
    //while it only contains a single static variable, still needs coverage.
    @isTest
    public static void SandboxSetup_PartialCopyBadFields_Test() {
        System.assertNotEquals(null, SandboxSetup_PartialCopyBadFields.MasterList);
    }
}