using System.Reflection;

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
    [JsonRequired] public ModelData[] SlimeFeatures;

    public ModelData[] GordoFeatures;
    public ModelData[] PlortFeatures;

    public bool NightSpawn;

    public IdentifiableId? FavFood;
    public FoodGroup? Diet;

    public IdentifiableId BaseSlime = IdentifiableId.PINK_SLIME;
    public IdentifiableId BasePlort = IdentifiableId.PINK_PLORT;
    public IdentifiableId BaseGordo = IdentifiableId.PINK_GORDO;

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
    public string PlortType = "Pearl";
    public bool CanBeRefined;

    public IdentifiableId? ComponentBase;
    public Zone GordoZone;
    public float SpawnAmount = 0.25f;
    public bool HasGordo = true;
    public IdentifiableId[] GordoRewards;

    public bool Vaccable = true;
    public string GordoCell;

    [JsonProperty("gordoOri")] public Orientation GordoOrientation;
    [JsonProperty("natGordoSpawn")] public bool NaturalGordoSpawn = true;

    public int PlortExchangeWeight = 16;
    public float Jiggle = 1f;

    [JsonProperty("toAdd")] public Type[] ComponentsToAdd;
    [JsonProperty("toRemove")] public Type[] ComponentsToRemove;

    [JsonProperty("spawners")] public string[] ExcludedSpawners;

    [JsonProperty("gordoEat")] public int GordoEatAmount = 25;

    [JsonIgnore] public bool IsPopped;

    [JsonIgnore] public IdentifiableId GordoId;
    [JsonIgnore] public IdentifiableId PlortId;

    [JsonIgnore] public MethodInfo InitSlimeDetails;
    [JsonIgnore] public MethodInfo InitPlortDetails;
    [JsonIgnore] public MethodInfo InitGordoDetails;

    protected override void OnDeserialise()
    {
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

        if (SlimeFeatures.Length > 0)
        {
            var matData = SlimeFeatures[0];
            matData.IsBody = true;

            if (!TopPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.TopColor, out var topColor))
                TopPaletteColor = topColor;

            if (!MiddlePaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.MiddleColor, out var middleColor))
                MiddlePaletteColor = middleColor;

            if (!BottomPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.BottomColor, out var bottomColor))
                BottomPaletteColor = bottomColor;
        }

        PlortAmmoColor ??= MainAmmoColor;

        Progress ??= [];

        if (PlortFeatures?.Length is null or 0 || GordoFeatures?.Length is null or 0)
        {
            var copy = SlimeFeatures.Select(x => new ModelData(x, false)).ToArray();

            PlortFeatures ??= copy;
            GordoFeatures ??= copy;
        }

        Vaccable |= Slimepedia.MvExists;
    }
}