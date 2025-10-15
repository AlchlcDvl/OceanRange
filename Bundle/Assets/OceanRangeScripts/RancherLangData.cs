using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Rancher")]
public sealed class RancherLangData : LangData
{
    public Dictionary<string, string[]> Offers;
    public Dictionary<string, string> SpecialOffers;
    public Dictionary<string, string[]> LoadingTexts;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}