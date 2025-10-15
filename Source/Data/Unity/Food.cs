namespace OceanRange.Data;

public sealed partial class ChimkenData : SpawnedActorData
{
    [JsonProperty("zones"), JsonRequired] public string[] ZonesUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.Write(SpawnAmount);
        writer.Write(ChickSpawnAmount);
        writer.WriteArray(ZonesUnity, Helpers.WriteString);
    }
}

public sealed partial class PlantData : SpawnedActorData
{
    [JsonProperty("spawnLocations"), JsonRequired] public List<NestedStringVector3ArrayDictEntry> SpawnLocationsUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.WriteString(Type);
        writer.WriteString(ResourceIdSuffix);
        writer.Write(IsVeggie);

        // Cursed, I know
        writer.WriteDictionary(SpawnLocationsUnity,
            (writer1, x) =>
                writer1.WriteDictionary(x,
                    (writer2, y) =>
                        writer2.WriteArray(y, Helpers.WriteVector3)));
    }
}