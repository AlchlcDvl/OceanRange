namespace OceanRange.Data;

public sealed partial class SlimeData : SpawnedActorData
{
    [JsonProperty("favToy"), JsonRequired]
    public string FavToyUnity;

    [JsonProperty("zones"), JsonRequired]
    public string[] ZonesUnity;

    [JsonProperty("favFood")] public string FavFoodUnity;
    [JsonProperty("diet")] public string DietUnity;

    [JsonProperty("baseSlime")] public string BaseSlimeUnity = "PINK_SLIME";
    [JsonProperty("basePlort")] public string BasePlortUnity = "PINK_PLORT";
    [JsonProperty("baseGordo")] public string BaseGordoUnity = "PINK_GORDO";

    [JsonIgnore, Optional] public OptionalData<Color> TopMouthColorUnity;
    [JsonIgnore, Optional] public OptionalData<Color> MiddleMouthColorUnity;
    [JsonIgnore, Optional] public OptionalData<Color> BottomMouthColorUnity;

    [JsonProperty("topMouthColor")]
    public Color? TopMouthColorJson
    {
        get => TopMouthColorUnity;
        set => TopMouthColorUnity = value;
    }

    [JsonProperty("middleMouthColor")]
    public Color? MiddleMouthColorJson
    {
        get => MiddleMouthColorUnity;
        set => MiddleMouthColorUnity = value;
    }


    [JsonProperty("bottomMouthColor")]
    public Color? BottomMouthColorJson
    {
        get => BottomMouthColorUnity;
        set => BottomMouthColorUnity = value;
    }

    [JsonIgnore, Optional] public OptionalData<Color> RedEyeColorUnity;
    [JsonIgnore, Optional] public OptionalData<Color> GreenEyeColorUnity;
    [JsonIgnore, Optional] public OptionalData<Color> BlueEyeColorUnity;

    [JsonProperty("redEyeColor")]
    public Color? RedEyeColorJson
    {
        get => RedEyeColorUnity;
        set => RedEyeColorUnity = value;
    }

    [JsonProperty("greenEyeColor")]
    public Color? GreenEyeColorJson
    {
        get => GreenEyeColorUnity;
        set => GreenEyeColorUnity = value;
    }

    [JsonProperty("blueEyeColor")]
    public Color? BlueEyeColorJson
    {
        get => BlueEyeColorUnity;
        set => BlueEyeColorUnity = value;
    }

    [JsonIgnore, Optional] public OptionalData<Color> TopPaletteColorUnity;
    [JsonIgnore, Optional] public OptionalData<Color> MiddlePaletteColorUnity;
    [JsonIgnore, Optional] public OptionalData<Color> BottomPaletteColorUnity;

    [JsonProperty("topPaletteColor")]
    public Color? TopPaletteColorJson
    {
        get => TopPaletteColorUnity;
        set => TopPaletteColorUnity = value;
    }

    [JsonProperty("middlePaletteColor")]
    public Color? MiddlePaletteColorJson
    {
        get => MiddlePaletteColorUnity;
        set => MiddlePaletteColorUnity = value;
    }

    [JsonProperty("bottomPaletteColor")]
    public Color? BottomPaletteColorJson
    {
        get => BottomPaletteColorUnity;
        set => BottomPaletteColorUnity = value;
    }

    [JsonIgnore, Optional] public OptionalData<Color> PlortAmmoColorUnity;

    [JsonProperty("plortAmmoColor")]
    public Color? PlortAmmoColorJson
    {
        get => PlortAmmoColorUnity;
        set => PlortAmmoColorUnity = value;
    }

    [JsonProperty("gordoZone")] public string GordoZoneUnity;
    [JsonProperty("componentBase")] public string ComponentBaseUnity;

    [JsonProperty("gordoRewards")] public string[] GordoRewardsUnity;
    [JsonProperty("toAdd")] public string[] ComponentsToAddUnity;
    [JsonProperty("toRemove")] public string[] ComponentsToRemoveUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);

        writer.WriteString(FavFoodUnity);
        writer.WriteString(FavToyUnity);
        writer.Write(NightSpawn);
        writer.WriteString(DietUnity);
        writer.WriteString(BaseSlimeUnity);
        writer.WriteString(BasePlortUnity);
        writer.WriteString(BaseGordoUnity);
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
        writer.WriteString(PlortType);
        writer.Write(CanBeRefined);
        writer.WriteArray(ZonesUnity, Helpers.WriteString);
        writer.WriteString(GordoZoneUnity);
        writer.Write(SpawnAmount);
        writer.Write(HasGordo);
        writer.WriteArray(GordoRewardsUnity, Helpers.WriteString);
        writer.WriteOrientation(GordoOrientation);
        writer.WriteString(GordoCell);
        writer.Write(NaturalGordoSpawn);
        writer.Write(PlortExchangeWeight);
        writer.Write(Jiggle);
        writer.WriteArray(SlimeFeatures, Helpers.WriteModData);
        writer.WriteArray(GordoFeatures, Helpers.WriteModData);
        writer.WriteArray(PlortFeatures, Helpers.WriteModData);
        writer.WriteArray(ComponentsToAddUnity, Helpers.WriteString);
        writer.WriteArray(ComponentsToRemoveUnity, Helpers.WriteString);
        writer.WriteArray(ExcludedSpawners, Helpers.WriteString);
        writer.Write(Vaccable);
        writer.Write(GordoEatAmount);
        writer.WriteString(ComponentBaseUnity);
    }
}