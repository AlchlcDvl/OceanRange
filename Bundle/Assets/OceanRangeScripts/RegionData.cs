using UnityEngine;
using System.IO;
using System.Collections.Generic;

[CreateAssetMenu(menuName = "OceanRange/Data/Region")]
public sealed class RegionData : JsonData
{
    public float InitialWorldSize;
    public Vector3 InitialWorldPos;
    public float MinNodeSize;
    public float LoosenessVal;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}