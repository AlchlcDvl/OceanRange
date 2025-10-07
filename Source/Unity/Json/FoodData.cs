namespace OceanRange.Unity.Json;

[Serializable]
public sealed class Ingredients : JsonData
{
    [JsonProperty("plants")]
    public PlantData[] Plants;

    [JsonProperty("chimkens")]
    public ChimkenData[] Chimkens;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.WriteArray(Plants, Helpers.WriteJsonData);
        writer.WriteArray(Chimkens, Helpers.WriteJsonData);
    }
}

[Serializable]
public sealed class ChimkenData : SpawnedActorData
{
    [JsonProperty("zones"), JsonRequired]
    public string[] Zones;

    [JsonProperty("spawnAmount")]
    public float SpawnAmount = 1f;

    [JsonProperty("chickSpawnAmount")]
    public float ChickSpawnAmount = 1f;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.Write(SpawnAmount);
        writer.Write(ChickSpawnAmount);
        writer.WriteArray(Zones, Helpers.WriteString);
    }
}

[Serializable]
public sealed class PlantData : SpawnedActorData
{
    [JsonProperty("type"), JsonRequired]
    public string Type;

    [JsonProperty("resource"), JsonRequired]
    public string ResourceIdSuffix;

    [JsonProperty("spawnLocations"), JsonRequired]
    public List<SerializableStringStringVector3ArrayPairListPair> SpawnLocations;

    [JsonProperty("isVeggie"), JsonRequired]
    public bool IsVeggie;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.Write(Type);
        writer.Write(ResourceIdSuffix);
        writer.Write(IsVeggie);

        // Cursed, I know
        writer.WriteDictionary(SpawnLocations,
            Helpers.WriteString,
            (writer, x) =>
                writer.WriteDictionary(x,
                    Helpers.WriteString,
                    (writer2, y) =>
                        writer2.WriteArray(y, Helpers.WriteVector3)));
    }
}