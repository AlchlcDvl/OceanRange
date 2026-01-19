// ReSharper disable UnassignedField.Global

using System.Reflection;
using OceanRange.Saves;

namespace OceanRange.Data;

public sealed class SlimeData : SpawnedActorData
{
    private static readonly Dictionary<string, MethodInfo> Methods = [];

    static SlimeData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Slimepedia)))
        {
            if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                Methods[method.Name] = method;
        }
    }

    [JsonRequired] public IdentifiableId FavToy;
    [JsonRequired] public Zone[] Zones;
    [JsonRequired] public SlimeAppearanceData NormalAppearance;

    public SlimeAppearanceData SSAppearance;

    public bool NightSpawn;

    public IdentifiableId? FavFood;
    public FoodGroup? Diet;

    public IdentifiableId BaseSlime = IdentifiableId.PINK_SLIME;
    public IdentifiableId BasePlort = IdentifiableId.PINK_PLORT;
    public IdentifiableId BaseGordo = IdentifiableId.PINK_GORDO;

    public bool CanBeRefined;

    public IdentifiableId? ComponentBase;
    public Zone GordoZone;
    public float SpawnAmount = 0.25f;
    public bool HasGordo = true;
    public IdentifiableId[] GordoRewards;

    public bool Vaccable = true;
    public bool Exchangeable = true;
    public string GordoCell;

    [JsonProperty("gordoOri")] public Orientation GordoOrientation;
    [JsonProperty("natGordoSpawn")] public bool NaturalGordoSpawn = true;

    public int PlortExchangeWeight = 16;
    public float Jiggle = 1f;

    [JsonProperty] private string OnomicsType = "pearls";

    [JsonProperty("toAdd")] public Type[] ComponentsToAdd;
    [JsonProperty("toRemove")] public Type[] ComponentsToRemove;

    [JsonProperty("gordoEat")] public int GordoEatAmount = 25;

    [JsonIgnore] public IdentifiableId GordoId;
    [JsonIgnore] public IdentifiableId PlortId;

    [JsonIgnore] public MethodInfo InitSlimeDetails;
    [JsonIgnore] public MethodInfo InitPlortDetails;
    [JsonIgnore] public MethodInfo InitGordoDetails;

    protected override void OnDeserialise()
    {
        base.OnDeserialise();

        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_SLIME");
        PlortId = Helpers.AddEnumValue<IdentifiableId>(upper + "_PLORT");

        var init = "Init" + Name;
        Methods.TryGetValue(init + "SlimeDetails", out InitSlimeDetails);
        Methods.TryGetValue(init + "PlortDetails", out InitPlortDetails);

        HasGordo |= Slimepedia.MgExists && upper == "SAND";

        if (HasGordo)
        {
            GordoId = Helpers.AddEnumValue<IdentifiableId>(upper + "_GORDO");
            Methods.TryGetValue(init + "GordoDetails", out InitGordoDetails);
        }

        if (NaturalGordoSpawn)
            NaturalGordoSpawn &= HasGordo;

        NormalAppearance.SetJiggle(Jiggle);
        SSAppearance?.SetJiggle(Jiggle);

        Vaccable |= Slimepedia.MvExists;

        if (HasGordo && NaturalGordoSpawn)
            GordoSaveDataV02.Lookup[GordoId] = false;
    }

    public void HandleTranslationData(SlimeLangData data) => Translator.SlimeToOnomicsMap[data.PediaKey] = OnomicsType;
}

public sealed class SlimeAppearanceData : JsonData
{
    [JsonRequired] public ModelData[] SlimeFeatures;
    [JsonRequired] public ModelData[] GordoFeatures;
    [JsonRequired] public ModelData[] PlortFeatures;

    [JsonRequired] public Color MainAmmoColor;

    public Color? TopMouthColor;
    public Color? MiddleMouthColor;
    public Color? BottomMouthColor;

    public Color? RedEyeColor;
    public Color? GreenEyeColor;
    public Color? BlueEyeColor;

    public Color? TopPaletteColor;
    public Color? MiddlePaletteColor;
    public Color? BottomPaletteColor;

    public Color? PlortAmmoColor;

    public float? Jiggle;

    public bool IsSS;

    protected override void OnDeserialise()
    {
        base.OnDeserialise();

        if (!SlimeFeatures.IsNullOrEmpty())
        {
            var matData = SlimeFeatures[0];
            matData.IsBody = true;

            if (!TopPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.TopColor, out var topColor))
                TopPaletteColor = topColor;

            if (!MiddlePaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.MiddleColor, out var middleColor))
                MiddlePaletteColor = middleColor;

            if (!BottomPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.BottomColor, out var bottomColor))
                BottomPaletteColor = bottomColor;

            // foreach (var feature in SlimeFeatures)
            //     feature.Mesh ??= "slime_default";
        }

        PlortAmmoColor ??= MainAmmoColor;

        foreach (var feature in GordoFeatures)
            feature.Jiggle ??= Jiggle;
    }

    public void SetJiggle(float jiggle)
    {
        Jiggle ??= jiggle;

        foreach (var feature in SlimeFeatures)
            feature.Jiggle ??= Jiggle;

        foreach (var feature in GordoFeatures)
            feature.Jiggle ??= Jiggle;
    }
}

public abstract class AppearanceHandle(string name)
{
    private readonly string Name = name;

    protected bool Initialised;
    protected GameObject Holder;

    protected abstract void InitialiseAppearance(GameObject obj);

    protected abstract void ApplyAppearance(GameObject obj);

    public void HandleAppearance(GameObject obj)
    {
        if (!Initialised)
        {
            Holder = new GameObject(Name + "_AppearanceHolder");
            InitialiseAppearance(obj);
            Initialised = true;
        }

        ApplyAppearance(obj);
    }
}