using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Base Lang")]
public class LangData : JsonData
{
    public Dictionary<string, string> Names;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}