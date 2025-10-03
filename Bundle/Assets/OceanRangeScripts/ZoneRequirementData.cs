using UnityEngine;
using System.IO;
using System.Collections.Generic;

[CreateAssetMenu(menuName = "OceanRange/Data/Zone Req")]
public sealed class ZoneRequirementData : JsonData
{
    public int CorporateLevelMin = 0;
    public int CorporateLevelMax = int.MaxValue;
    public int ExchangeProgress;
    public string PathToGameObject;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}