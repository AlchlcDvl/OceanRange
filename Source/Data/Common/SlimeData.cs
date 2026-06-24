// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global
// ReSharper disable MemberCanBePrivate.Global

namespace OceanRange.Data;

[Serializable]
public sealed partial class SlimeData : SpawnedActorData
{
    protected override bool SerialiseName => true;

    public bool NightSpawn;
    public bool CanBeRefined;
    public float SpawnAmount = 0.25f;
    public bool HasGordo = true;

    public bool Vaccable = true;
    public bool Exchangeable = true;
    public string GordoCell;

    [JsonProperty("gordoOri")] public Orientation GordoOrientation;
    [JsonProperty("natGordoSpawn")] public bool NaturalGordoSpawn = true;

    public int PlortExchangeWeight = 16;
    public float Jiggle = 1f;

    [JsonProperty] public string OnomicsType = "pearls";

    [JsonProperty("gordoEat")] public int GordoEatAmount = 25;
}

[Serializable]
public sealed partial class SlimeAppearanceData : JsonData
{
    [JsonRequired] public ModelData[] SlimeFeatures;
    [JsonRequired] public ModelData[] GordoFeatures;
    [JsonRequired] public ModelData[] PlortFeatures;
}
