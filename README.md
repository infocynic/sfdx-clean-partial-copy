# sfdx-clean-partial-copy
Janky Apex to use to clean bad lookups from partial copies

Modify SandboxSetup_PartialCopyBadFields by following the pattern started there.
Invoke the batch using something like this

```java
for (
      SObjectType oType : SandboxSetup_PartialCopyBadFields.MasterList.keySet()
    ) {
  SandboxSetup_PartialCopy pc = new SandboxSetup_PartialCopy(
    oType,
    SandboxSetup_PartialCopyBadFields.MasterList.get(oType)
  );
  database.executeBatch(pc);
}
```
