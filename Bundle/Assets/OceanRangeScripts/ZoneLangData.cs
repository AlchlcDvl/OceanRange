using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Zone")]
public sealed class ZoneLangData : PediaLangData
{
    public Dictionary<string, string> Descriptions;
    public Dictionary<string, string> Presences;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}