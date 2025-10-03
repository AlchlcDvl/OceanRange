using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Holder/Largopedia")]
public sealed class LargoHolder : JsonData
{
    public LargoData[] Largos;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Largo")]
public sealed class LargoData : SpawnedActorData
{
    public LargoProps Props;
    public ModelData BodyStructData;
    public ModelData[] Slime1StructData;
    public ModelData[] Slime2StructData;
    public OptionalFloat Jiggle;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}