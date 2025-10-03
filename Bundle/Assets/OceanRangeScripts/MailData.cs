using System.IO;
using UnityEngine;
using OceanRange.Unity;

[CreateAssetMenu(menuName = "OceanRange/Holder/Mailbox")]
public sealed class Mailbox : JsonData
{
    public MailData[] Mail;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Mail")]
public sealed class MailData : JsonData
{
    public string Id;
    public OptionalDouble UnlockAfter;

    public override void SerialiseTo(BinaryWriter writer)
    {
        // Not yet implemented
    }
}