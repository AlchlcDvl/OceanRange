using System.IO;
using UnityEngine;
using OceanRange.Unity;

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