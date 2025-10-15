using System.IO;
using UnityEngine;
using OceanRange.Unity;

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