using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Resource")]
public class ResourceLangData : PediaLangData
{
    public Dictionary<string, string> Ranch;
    public Dictionary<string, string> Types;
    public Dictionary<string, string> About;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}