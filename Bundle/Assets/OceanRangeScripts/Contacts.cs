using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Holder/Contacts")]
public sealed class Contacts : JsonData
{
    public RancherData[] Ranchers;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}