using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Food")]
public sealed class FoodLangData : ResourceLangData
{
    public Dictionary<string, string> FavouredBy;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}