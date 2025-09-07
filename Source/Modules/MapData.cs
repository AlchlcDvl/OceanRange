namespace OceanRange.Modules;

public sealed class ZoneData : JsonData
{
    [JsonProperty("zone"), JsonRequired]
    public Zone Zone;

    [JsonProperty("cells"), JsonRequired]
    public CellData[] Cells;
}

public sealed class CellData : JsonData
{
    [JsonProperty("slimeSpawners")]
    public SpawnerData[] Slimes;
}

public sealed class SpawnerData
{
    [JsonProperty("orientation"), JsonRequired]
    public Orientation Orientation;

    [JsonProperty("commonMembers"), JsonRequired]
    public SpawnerMember[] CommonMembers;

    [JsonProperty("constraints"), JsonRequired]
    public SpawnConstraint[] Constraints;
}

public sealed class SpawnerMember
{
    [JsonProperty("id"), JsonRequired]
    public IdentifiableId Id;

    [JsonProperty("weight"), JsonRequired]
    public float Weight;
}

public sealed class SpawnConstraint
{
    [JsonProperty("window"), JsonRequired]
    public TimeMode Window;

    [JsonProperty("start")]
    public float Start;

    [JsonProperty("end")]
    public float End;

    [JsonProperty("feral")]
    public bool Feral;

    [JsonProperty("members")]
    public SpawnerMember[] Members;
}