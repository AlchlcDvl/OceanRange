using System.IO;
using UnityEngine;
using OceanRange.Unity.Json;

[CreateAssetMenu(menuName = "OceanRange/Holder/Mailbox")]
public sealed class Mailbox : ArrayHolder<MailData>
{
    public override string Name => "Mailbox";
}