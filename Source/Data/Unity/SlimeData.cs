#if UNITY
namespace OceanRange.Data;

public sealed partial class SlimeData
{
    [JsonRequired] public string FavToy;
    [JsonRequired] public string[] Zones;

    public Optional<string> FavFood;
    public Optional<string> Diet;

    public string BaseSlime = "PINK_SLIME";
    public string BasePlort = "PINK_PLORT";
    public string BaseGordo = "PINK_GORDO";

    public Optional<string> ComponentBase;
    public Optional<string> GordoZone;
    public string[] GordoRewards;

    [JsonProperty("toAdd")] public string[] ComponentsToAdd;
    [JsonProperty("toRemove")] public string[] ComponentsToRemove;

    [JsonRequired] public SlimeAppearanceData NormalAppearance;
    public Optional<SlimeAppearanceData> SSAppearance;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolString(FavToy);
        pooler.PoolStrings(Zones);
        pooler.PoolString(FavFood);
        pooler.PoolString(Diet);
        pooler.PoolString(BaseSlime);
        pooler.PoolString(BasePlort);
        pooler.PoolString(BaseGordo);
        pooler.PoolString(ComponentBase);
        pooler.PoolString(GordoZone);
        pooler.PoolStrings(GordoRewards);
        pooler.PoolString(GordoCell);

        pooler.PoolString(OnomicsType);

        pooler.PoolStrings(ComponentsToAdd);
        pooler.PoolStrings(ComponentsToRemove);

        NormalAppearance.FindStrings(pooler);

        if (SSAppearance.HasValue)
            SSAppearance.Value.FindStrings(pooler);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(FavToy);
        writer.WriteStringArray(Zones);
        writer.WriteString(FavFood);
        writer.WriteString(Diet);

        writer.WriteString(BaseSlime);
        writer.WriteString(BasePlort);
        writer.WriteString(BaseGordo);

        writer.WriteBool(CanBeRefined);

        writer.WriteString(ComponentBase);
        writer.WriteString(GordoZone);
        writer.WritePackedFloat(SpawnAmount);
        writer.WriteBool(HasGordo);
        writer.WriteStringArray(GordoRewards);

        writer.WriteBool(Vaccable);
        writer.WriteBool(Exchangeable);
        writer.WriteString(GordoCell);

        writer.WriteOrientation(GordoOrientation);
        writer.WriteBool(NaturalGordoSpawn);

        writer.WritePackedUInt((uint)PlortExchangeWeight);
        writer.WritePackedFloat(Jiggle);

        writer.WriteString(OnomicsType);

        writer.WriteStringArray(ComponentsToAdd);
        writer.WriteStringArray(ComponentsToRemove);

        writer.WritePackedUInt((uint)GordoEatAmount);

        NormalAppearance.WriteTo(writer);

        var hasSS = SSAppearance.HasValue;
        writer.WriteBool(hasSS);

        if (hasSS)
            SSAppearance.Value.WriteTo(writer);
    }
}

public sealed partial class SlimeAppearanceData
{
    [JsonRequired] public Color32 MainAmmoColor;

    public Optional<Color32> TopMouthColor;
    public Optional<Color32> MiddleMouthColor;
    public Optional<Color32> BottomMouthColor;

    public Optional<Color32> RedEyeColor;
    public Optional<Color32> GreenEyeColor;
    public Optional<Color32> BlueEyeColor;

    public Optional<Color32> TopPaletteColor;
    public Optional<Color32> MiddlePaletteColor;
    public Optional<Color32> BottomPaletteColor;

    public Optional<Color32> PlortAmmoColor;

    public Optional<string> EyesOrigin;
    public Optional<string> MouthOrigin;

    public Optional<float> Jiggle;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolString(MainAmmoColor.ToHex());

        pooler.PoolString(TopMouthColor.ToHex());
        pooler.PoolString(MiddleMouthColor.ToHex());
        pooler.PoolString(BottomMouthColor.ToHex());

        pooler.PoolString(RedEyeColor.ToHex());
        pooler.PoolString(GreenEyeColor.ToHex());
        pooler.PoolString(BlueEyeColor.ToHex());

        pooler.PoolString(TopPaletteColor.ToHex());
        pooler.PoolString(MiddlePaletteColor.ToHex());
        pooler.PoolString(BottomPaletteColor.ToHex());

        pooler.PoolString(PlortAmmoColor.ToHex());

        pooler.PoolString(EyesOrigin);
        pooler.PoolString(MouthOrigin);

        Array.ForEach(SlimeFeatures, f => f.FindStrings(pooler));
        Array.ForEach(GordoFeatures, f => f.FindStrings(pooler));
        Array.ForEach(PlortFeatures, f => f.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(MainAmmoColor.ToHex());

        writer.WriteString(TopMouthColor.ToHex());
        writer.WriteString(MiddleMouthColor.ToHex());
        writer.WriteString(BottomMouthColor.ToHex());

        writer.WriteString(RedEyeColor.ToHex());
        writer.WriteString(GreenEyeColor.ToHex());
        writer.WriteString(BlueEyeColor.ToHex());

        writer.WriteString(TopPaletteColor.ToHex());
        writer.WriteString(MiddlePaletteColor.ToHex());
        writer.WriteString(BottomPaletteColor.ToHex());

        writer.WriteString(PlortAmmoColor.ToHex());

        writer.WriteArray(SlimeFeatures, (w, f) => f.WriteTo(w));
        writer.WriteArray(GordoFeatures, (w, f) => f.WriteTo(w));
        writer.WriteArray(PlortFeatures, (w, f) => f.WriteTo(w));

        writer.WriteNullablePackedFloat(Jiggle);

        writer.WriteString(EyesOrigin);
        writer.WriteString(MouthOrigin);
    }
}
#endif
