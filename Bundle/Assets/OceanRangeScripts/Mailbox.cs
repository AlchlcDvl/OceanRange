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