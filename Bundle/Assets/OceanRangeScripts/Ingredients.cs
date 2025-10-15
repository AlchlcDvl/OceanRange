using UnityEngine;
using System.IO;
using System.Collections.Generic;

[CreateAssetMenu(menuName = "OceanRange/Holder/Ingredients")]
public sealed class Ingredients : JsonData
{
    public PlantData[] Plants;
    public ChimkenData[] Chimkens;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}