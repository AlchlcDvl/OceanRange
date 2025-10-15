using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Slime")]
public sealed class SlimeLangData : PediaLangData
{
    public Dictionary<string, string> Risks;
    public Dictionary<string, string> Slimeologies;
    public Dictionary<string, string> Diets;
    public Dictionary<string, string> Favourites;
    public Dictionary<string, string> Onomics;
    public string OnomicsType = "pearls";

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}