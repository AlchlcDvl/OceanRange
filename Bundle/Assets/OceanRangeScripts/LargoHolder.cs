using System.IO;
using UnityEngine;
using OceanRange.Unity;

[CreateAssetMenu(menuName = "OceanRange/Holder/Largopedia")]
public sealed class LargoHolder : JsonData
{
    public LargoData[] Largos;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}