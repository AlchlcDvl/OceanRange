namespace OceanRange.Unity.Json;

[Serializable]
public sealed class SlimeData : SpawnedActorData
{
    [JsonProperty("favFood")]
    public string FavFood;

    [JsonProperty("favToy"), JsonRequired]
    public string FavToy;

    [JsonProperty("nightSpawn")]
    public bool NightSpawn;

    [JsonProperty("diet")]
    public string Diet;

    [JsonProperty("baseSlime")]
    public string BaseSlime = "PINK_SLIME";

    [JsonProperty("basePlort")]
    public string BasePlort = "PINK_PLORT";

    [JsonProperty("baseGordo")]
    public string BaseGordo = "PINK_GORDO";

    [JsonProperty("topMouthColor")]
    public Color? TopMouthColorJson
    {
        get => TopMouthColorUnity;
        set => TopMouthColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> TopMouthColorUnity;

    [JsonProperty("middleMouthColor")]
    public Color? MiddleMouthColorJson
    {
        get => MiddleMouthColorUnity;
        set => MiddleMouthColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> MiddleMouthColorUnity;

    [JsonProperty("bottomMouthColor")]
    public Color? BottomMouthColorJson
    {
        get => BottomMouthColorUnity;
        set => BottomMouthColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> BottomMouthColorUnity;

    [JsonProperty("redEyeColor")]
    public Color? RedEyeColorJson
    {
        get => RedEyeColorUnity;
        set => RedEyeColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> RedEyeColorUnity;

    [JsonProperty("greenEyeColor")]
    public Color? GreenEyeColorJson
    {
        get => GreenEyeColorUnity;
        set => GreenEyeColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> GreenEyeColorUnity;

    [JsonProperty("blueEyeColor")]
    public Color? BlueEyeColorJson
    {
        get => BlueEyeColorUnity;
        set => BlueEyeColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> BlueEyeColorUnity;

    [JsonProperty("topPaletteColor")]
    public Color? TopPaletteColorJson
    {
        get => TopPaletteColorUnity;
        set => TopPaletteColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> TopPaletteColorUnity;

    [JsonProperty("middlePaletteColor")]
    public Color? MiddlePaletteColorJson
    {
        get => MiddlePaletteColorUnity;
        set => MiddlePaletteColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> MiddlePaletteColorUnity;

    [JsonProperty("bottomPaletteColor")]
    public Color? BottomPaletteColorJson
    {
        get => BottomPaletteColorUnity;
        set => BottomPaletteColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> BottomPaletteColorUnity;

    [JsonProperty("plortAmmoColor")]
    public Color? PlortAmmoColorJson
    {
        get => PlortAmmoColorUnity;
        set => PlortAmmoColorUnity = value;
    }

    [JsonIgnore, Optional]
    public OptionalData<Color> PlortAmmoColorUnity;

    [JsonProperty("plortType")]
    public string PlortType = "Pearl";

    [JsonProperty("canBeRefined")]
    public bool CanBeRefined;

    [JsonProperty("zones"), JsonRequired]
    public string[] Zones;

    [JsonProperty("gordoZone")]
    public string GordoZone;

    [JsonProperty("spawnAmount")]
    public float SpawnAmount = 0.25f;

    [JsonProperty("hasGordo")]
    public bool HasGordo = true;

    [JsonProperty("gordoRewards")]
    public string[] GordoRewards;

    [JsonProperty("gordoOri")]
    public Orientation GordoOrientation;

    [JsonProperty("gordoLoc")]
    public string GordoCell;

    [JsonProperty("natGordoSpawn")]
    public bool NaturalGordoSpawn = true;

    [JsonProperty("plortExchangeWeight")]
    public int PlortExchangeWeight = 16;

    [JsonProperty("jiggle")]
    public float JiggleAmount = 1f;

    [JsonProperty("slimeFeatures"), JsonRequired]
    public ModelData[] SlimeFeatures;

    [JsonProperty("gordoFeatures")]
    public ModelData[] GordoFeatures;

    [JsonProperty("plortFeatures")]
    public ModelData[] PlortFeatures;

    [JsonProperty("toAdd")]
    public string[] ComponentsToAdd;

    [JsonProperty("toRemove")]
    public string[] ComponentsToRemove;

    [JsonProperty("spawners")]
    public string[] ExcludedSpawners;

    [JsonProperty("vaccable")]
    public bool Vaccable = true;

    [JsonProperty("gordoEat")]
    public int GordoEatAmount = 25;

    [JsonProperty("componentBase")]
    public string ComponentBase;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.WriteNullableString(FavFood);
        writer.Write(FavToy);
        writer.Write(NightSpawn);
        writer.WriteNullableString(Diet);
        writer.Write(BaseSlime);
        writer.Write(BasePlort);
        writer.Write(BaseGordo);
        writer.WriteNullable(TopMouthColorJson, Helpers.WriteColor);
        writer.WriteNullable(MiddleMouthColorJson, Helpers.WriteColor);
        writer.WriteNullable(BottomMouthColorJson, Helpers.WriteColor);
        writer.WriteNullable(RedEyeColorJson, Helpers.WriteColor);
        writer.WriteNullable(GreenEyeColorJson, Helpers.WriteColor);
        writer.WriteNullable(BlueEyeColorJson, Helpers.WriteColor);
        writer.WriteNullable(TopPaletteColorJson, Helpers.WriteColor);
        writer.WriteNullable(MiddlePaletteColorJson, Helpers.WriteColor);
        writer.WriteNullable(BottomPaletteColorJson, Helpers.WriteColor);
        writer.WriteNullable(PlortAmmoColorJson, Helpers.WriteColor);
        writer.Write(PlortType);
        writer.Write(CanBeRefined);
        writer.WriteArray(Zones, Helpers.WriteString);
        writer.WriteNullableString(GordoZone);
        writer.Write(SpawnAmount);
        writer.Write(HasGordo);
        writer.WriteArray(GordoRewards, Helpers.WriteString);
        writer.WriteOrientation(GordoOrientation);
        writer.WriteNullableString(GordoCell);
        writer.Write(NaturalGordoSpawn);
        writer.Write(PlortExchangeWeight);
        writer.Write(JiggleAmount);
        writer.WriteArray(SlimeFeatures, Helpers.WriteJsonData);
        writer.WriteArray(GordoFeatures, Helpers.WriteJsonData);
        writer.WriteArray(PlortFeatures, Helpers.WriteJsonData);
        writer.WriteArray(ComponentsToAdd, Helpers.WriteString);
        writer.WriteArray(ComponentsToRemove, Helpers.WriteString);
        writer.WriteArray(ExcludedSpawners, Helpers.WriteString);
        writer.Write(Vaccable);
        writer.Write(GordoEatAmount);
        writer.WriteNullableString(ComponentBase);
    }
}