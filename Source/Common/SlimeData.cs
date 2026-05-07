// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global
// ReSharper disable MemberCanBePrivate.Global

using OceanRange.Saves;

namespace OceanRange.Data;

using System;
using System.Collections.Generic;
using System.Reflection; // For Type.GetType, may be needed
using OceanRange.Data;   // Adjust namespace as needed

#if !UNITY
using HarmonyLib;        // For AccessTools – runtime only
#endif

public sealed class SlimeData : SpawnedActorData
{
#if !UNITY
    // ------------------------------------------------------------------
    // Runtime‑only static cache and delegate maps (from Slimepedia)
    // ------------------------------------------------------------------
    private static readonly Dictionary<string, Action<SlimeAppearance, SlimeAppearanceData>> AppearanceMethods = new();
    private static readonly Dictionary<string, Action<GameObject, SlimeDefinition>> DefinitionMethods = new();

    static SlimeData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Slimepedia)))
        {
            if (method.Name.EndsWith("AppearanceDetails", StringComparison.Ordinal))
                AppearanceMethods[method.Name] = Helpers.CompileAction<SlimeAppearance, SlimeAppearanceData>(method);
            else if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                DefinitionMethods[method.Name] = Helpers.CompileAction<GameObject, SlimeDefinition>(method);
        }
    }

    // Runtime‑only fields (JsonIgnore)
    [JsonIgnore] public IdentifiableId GordoId;
    [JsonIgnore] public IdentifiableId PlortId;
    [JsonIgnore] public PediaId PediaId;

    [JsonIgnore] public Action<GameObject, SlimeDefinition> InitSlimeDetails;
    [JsonIgnore] public Action<GameObject, SlimeDefinition> InitPlortDetails;
    [JsonIgnore] public Action<GameObject, SlimeDefinition> InitGordoDetails;
    [JsonIgnore] public Action<SlimeAppearance, SlimeAppearanceData> InitAppearanceDetails;
#endif

    [JsonRequired] public SlimeAppearanceData NormalAppearance;
    public SlimeAppearanceData SSAppearance;

    public bool NightSpawn;
    public bool CanBeRefined;
    public float SpawnAmount = 0.25f;
    public bool HasGordo = true;

    public bool Vaccable = true;
    public bool Exchangeable = true;
    public string GordoCell;

    public Orientation GordoOrientation;
    public bool NaturalGordoSpawn = true;

    public int PlortExchangeWeight = 16;
    public float Jiggle = 1f;

    private string OnomicsType = "pearls";

    public int GordoEatAmount = 25;

#if UNITY
    [JsonRequired] public string FavToy;
    [JsonRequired] public string[] Zones;

    public string FavFood;
    public string Diet;

    public string BaseSlime = "PINK_SLIME";
    public string BasePlort = "PINK_PLORT";
    public string BaseGordo = "PINK_GORDO";

    public string ComponentBase;
    public string GordoZone;
    public string[] GordoRewards;

    public string[] ComponentsToAdd;
    public string[] ComponentsToRemove;
#else
    // Runtime side – actual enum/Type fields, no defaults on enums
    [JsonRequired] public IdentifiableId FavToy;
    [JsonRequired] public Zone[] Zones;

    public IdentifiableId? FavFood;
    public FoodGroup? Diet;

    public IdentifiableId BaseSlime;
    public IdentifiableId BasePlort;
    public IdentifiableId BaseGordo;

    public IdentifiableId? ComponentBase;
    public Zone GordoZone;
    public IdentifiableId[] GordoRewards;

    public Type[] ComponentsToAdd;
    public Type[] ComponentsToRemove;
#endif

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);

        writer.PoolString(FavToy);
        writer.PoolStrings(Zones);
        writer.PoolString(FavFood);
        writer.PoolString(Diet);
        writer.PoolString(BaseSlime);
        writer.PoolString(BasePlort);
        writer.PoolString(BaseGordo);
        writer.PoolString(ComponentBase);
        writer.PoolString(GordoZone);
        writer.PoolStrings(GordoRewards);
        writer.PoolString(GordoCell);

        writer.PoolString(OnomicsType);

        writer.PoolStrings(ComponentsToAdd);
        writer.PoolStrings(ComponentsToRemove);

        NormalAppearance.FindStrings(writer);
        SSAppearance?.FindStrings(writer);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteString(FavToy);
        writer.WriteArray(Zones, (w, s) => w.WriteString(s));
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
        writer.WriteArray(GordoRewards, (w, s) => w.WriteString(s));

        writer.WriteBool(Vaccable);
        writer.WriteBool(Exchangeable);
        writer.WriteString(GordoCell);

        writer.WriteOrientation(GordoOrientation);
        writer.WriteBool(NaturalGordoSpawn);

        writer.WritePackedUInt((uint)PlortExchangeWeight);
        writer.WritePackedFloat(Jiggle);

        writer.WriteString(OnomicsType);

        writer.WriteArray(ComponentsToAdd, (w, s) => w.WriteString(s));
        writer.WriteArray(ComponentsToRemove, (w, s) => w.WriteString(s));

        writer.WritePackedUInt((uint)GordoEatAmount);

        NormalAppearance.WriteTo(writer);
        bool hasSS = SSAppearance != null;

        writer.WriteBool(hasSS);

        if (hasSS)
            SSAppearance.WriteTo(writer);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        FavToy = Helpers.ParseEnum<IdentifiableId>(reader.ReadString());
        Zones = reader.ReadArray(r => Helpers.ParseEnum<Zone>(r.ReadString()), false);
        FavFood = reader.ReadNullableEnum<IdentifiableId>();
        Diet = reader.ReadNullableEnum<FoodGroup>();
        BaseSlime = Helpers.ParseEnum<IdentifiableId>(reader.ReadString());
        BasePlort = Helpers.ParseEnum<IdentifiableId>(reader.ReadString());
        BaseGordo = Helpers.ParseEnum<IdentifiableId>(reader.ReadString());

        CanBeRefined = reader.ReadBool();

        ComponentBase = reader.ReadNullableEnum<IdentifiableId>();
        GordoZone = Helpers.ParseEnum<Zone>(reader.ReadString());
        SpawnAmount = reader.ReadPackedFloat();
        HasGordo = reader.ReadBool();
        GordoRewards = reader.ReadArray(r => Helpers.ParseEnum<IdentifiableId>(r.ReadString()), false);

        Vaccable = reader.ReadBool();
        Exchangeable = reader.ReadBool();
        GordoCell = reader.ReadString();

        GordoOrientation = reader.ReadOrientation();
        NaturalGordoSpawn = reader.ReadBool();

        PlortExchangeWeight = (int)reader.ReadPackedUInt();
        Jiggle = reader.ReadPackedFloat();

        OnomicsType = reader.ReadString();

        ComponentsToAdd = reader.ReadArray(r => r.ReadType());
        ComponentsToRemove = reader.ReadArray(r => r.ReadType());

        GordoEatAmount = (int)reader.ReadPackedUInt();

        NormalAppearance = new SlimeAppearanceData();
        NormalAppearance.ReadFrom(reader);

        if (!reader.ReadBool())
            return;

        SSAppearance = new SlimeAppearanceData();
        SSAppearance.ReadFrom(reader);
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        var upper = Name.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(upper + "_SLIME");
        PlortId = Helpers.AddEnumValue<IdentifiableId>(upper + "_PLORT");

        var init = "Init" + Name;
        DefinitionMethods.TryGetValue(init + "SlimeDetails", out InitSlimeDetails);
        DefinitionMethods.TryGetValue(init + "PlortDetails", out InitPlortDetails);
        AppearanceMethods.TryGetValue(init + "AppearanceDetails", out InitAppearanceDetails);

        HasGordo |= Slimepedia.MgExists && upper == "SAND";
        NaturalGordoSpawn &= HasGordo;

        if (HasGordo)
        {
            GordoId = Helpers.AddEnumValue<IdentifiableId>(upper + "_GORDO");
            DefinitionMethods.TryGetValue(init + "GordoDetails", out InitGordoDetails);

            if (NaturalGordoSpawn)
                GordoSaveDataV02.AddGordo(GordoId);
        }

        NormalAppearance.SetJiggle(Jiggle);

        if (SSAppearance != null)
        {
            SSAppearance.SetJiggle(Jiggle);
            SSAppearance.IsSS = true;
        }

        Vaccable |= Slimepedia.MvExists;
    }

    public void HandleTranslationData(SlimeLangData data)
    {
        Translator.SlimeToOnomicsMap[data.PediaKey] = OnomicsType;
        PediaId = data.PediaId;
        data.SsExists = SSAppearance != null;
    }
#endif
}

public sealed class SlimeAppearanceData : JsonData
{
    [JsonRequired] public ModelData[] SlimeFeatures;
    [JsonRequired] public ModelData[] GordoFeatures;
    [JsonRequired] public ModelData[] PlortFeatures;

#if UNITY
    [JsonRequired] public string MainAmmoColor;

    public string TopMouthColor;
    public string MiddleMouthColor;
    public string BottomMouthColor;
    public string RedEyeColor;
    public string GreenEyeColor;
    public string BlueEyeColor;
    public string TopPaletteColor;
    public string MiddlePaletteColor;
    public string BottomPaletteColor;
    public string PlortAmmoColor;

    public float? Jiggle;
#else
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
    public bool HasMouthColors;
    public bool HasEyeColors;
    public bool ChangedFace;
#endif

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);

        PoolColor(writer, MainAmmoColor);
        PoolColor(writer, TopMouthColor);
        PoolColor(writer, MiddleMouthColor);
        PoolColor(writer, BottomMouthColor);
        PoolColor(writer, RedEyeColor);
        PoolColor(writer, GreenEyeColor);
        PoolColor(writer, BlueEyeColor);
        PoolColor(writer, TopPaletteColor);
        PoolColor(writer, MiddlePaletteColor);
        PoolColor(writer, BottomPaletteColor);
        PoolColor(writer, PlortAmmoColor);

        foreach (var feature in SlimeFeatures)
            feature.FindStrings(writer);

        foreach (var feature in GordoFeatures)
            feature.FindStrings(writer);

        foreach (var feature in PlortFeatures)
            feature.FindStrings(writer);
    }

    private static void PoolColor(DataWriter writer, string colorHex)
    {
        if (!string.IsNullOrEmpty(colorHex))
            writer.PoolString(colorHex.Replace("#", string.Empty));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer); // writes Name

        WriteColor(writer, MainAmmoColor);
        WriteColor(writer, TopMouthColor);
        WriteColor(writer, MiddleMouthColor);
        WriteColor(writer, BottomMouthColor);
        WriteColor(writer, RedEyeColor);
        WriteColor(writer, GreenEyeColor);
        WriteColor(writer, BlueEyeColor);
        WriteColor(writer, TopPaletteColor);
        WriteColor(writer, MiddlePaletteColor);
        WriteColor(writer, BottomPaletteColor);
        WriteColor(writer, PlortAmmoColor);

        WriteModelArray(writer, SlimeFeatures);
        WriteModelArray(writer, GordoFeatures);
        WriteModelArray(writer, PlortFeatures);

        writer.WriteBool(Jiggle.HasValue);

        if (Jiggle.HasValue)
            writer.WritePackedFloat(Jiggle.Value);
    }

    private static void WriteColor(DataWriter writer, string colorHex)
    {
        writer.WriteString(colorHex?.Replace("#", string.Empty) ?? string.Empty);
    }

    private static void WriteModelArray(DataWriter writer, ModelData[] array)
    {
        writer.WritePackedUInt((uint)array.Length);

        foreach (var model in array)
            model.WriteTo(writer);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        MainAmmoColor = ReadColorNonNull(reader);
        TopMouthColor = ReadColorNullable(reader);
        MiddleMouthColor = ReadColorNullable(reader);
        BottomMouthColor = ReadColorNullable(reader);
        RedEyeColor = ReadColorNullable(reader);
        GreenEyeColor = ReadColorNullable(reader);
        BlueEyeColor = ReadColorNullable(reader);
        TopPaletteColor = ReadColorNullable(reader);
        MiddlePaletteColor = ReadColorNullable(reader);
        BottomPaletteColor = ReadColorNullable(reader);
        PlortAmmoColor = ReadColorNullable(reader);

        SlimeFeatures = ReadModelArray(reader);
        GordoFeatures = ReadModelArray(reader);
        PlortFeatures = ReadModelArray(reader);

        if (reader.ReadBool())
            Jiggle = reader.ReadPackedFloat();
    }

    private static Color ReadColorNonNull(DataReader reader)
    {
        var col = reader.ReadString();
        return string.IsNullOrEmpty(col) ? Color.white : ("#" + col).HexToColor();
    }

    private static Color? ReadColorNullable(DataReader reader)
    {
        var col = reader.ReadString();
        return string.IsNullOrEmpty(col) ? null : ("#" + col).HexToColor();
    }

    private static ModelData[] ReadModelArray(DataReader reader)
    {
        var count = reader.ReadPackedUInt();
        var array = new ModelData[count];

        for (var i = 0; i < count; i++)
        {
            // Assumes ModelData has a parameterless constructor
            array[i] = new ModelData();
            array[i].ReadFrom(reader);
        }

        return array;
    }

    public override void OnDeserialise()
    {
        var modelData = SlimeFeatures[0];
        modelData.MeshData.IsBody = true;
        var matData = modelData.MatData;

        if (!TopPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.TopColor, out var topColor))
            TopPaletteColor = topColor;

        if (!MiddlePaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.MiddleColor, out var middleColor))
            MiddlePaletteColor = middleColor;

        if (!BottomPaletteColor.HasValue && matData.ColorProps.TryGetValue(Slimepedia.BottomColor, out var bottomColor))
            BottomPaletteColor = bottomColor;

        PlortAmmoColor ??= MainAmmoColor;

        HasMouthColors = TopMouthColor.HasValue || MiddleMouthColor.HasValue || BottomMouthColor.HasValue;
        HasEyeColors = RedEyeColor.HasValue || GreenEyeColor.HasValue || BlueEyeColor.HasValue;
        ChangedFace = HasMouthColors || HasEyeColors;
    }

    public void SetJiggle(float jiggle)
    {
        Jiggle ??= jiggle;

        foreach (var feature in SlimeFeatures)
            feature.MeshData.Jiggle ??= Jiggle;

        foreach (var feature in GordoFeatures)
            feature.MeshData.Jiggle ??= Jiggle;
    }
#endif
}