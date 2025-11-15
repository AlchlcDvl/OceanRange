// ReSharper disable UnassignedField.Global

using System.Reflection;

namespace OceanRange.Data;

public sealed class LargoData : ActorData
{
    private static readonly Dictionary<string, MethodInfo> Methods = [];

    static LargoData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Largopedia)))
        {
            if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                Methods[method.Name] = method;
        }
    }

    [JsonRequired] public LargoProps Props;

    public ModelData BodyStruct;

    public ModelData[] Slime1Structs;
    public ModelData[] Slime2Structs;

    public float? Jiggle;

    [JsonIgnore] public string Slime1;
    [JsonIgnore] public string Slime2;

    [JsonIgnore] public IdentifiableId Slime1Id;
    [JsonIgnore] public IdentifiableId Slime2Id;

    [JsonIgnore] public SlimeData Slime1Data;
    [JsonIgnore] public SlimeData Slime2Data;

    [JsonIgnore] public MethodInfo InitSlime1Details;
    [JsonIgnore] public MethodInfo InitSlime2Details;
    [JsonIgnore] public MethodInfo InitLargoDetails;

    protected override void OnDeserialise()
    {
        var parts = Name.TrueSplit(' ');

        Slime1 = parts[0];
        Slime2 = parts[1];

        var slime1Upper = Slime1.ToUpperInvariant();
        var slime2Upper = Slime2.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(slime1Upper + "_" + slime2Upper + "_LARGO");
        Slime1Id = Helpers.ParseEnum<IdentifiableId>(slime1Upper + "_SLIME");
        Slime2Id = Helpers.ParseEnum<IdentifiableId>(slime2Upper + "_SLIME");

        Methods.TryGetValue("Init" + Slime1 + "Details", out InitSlime1Details);
        Methods.TryGetValue("Init" + Slime2 + "Details", out InitSlime2Details);
        Methods.TryGetValue("Init" + Slime1 + Slime2 + "Details", out InitLargoDetails);

        Slimepedia.SlimeDataMap.TryGetValue(Slime1Id, out Slime1Data);
        Slimepedia.SlimeDataMap.TryGetValue(Slime2Id, out Slime2Data);

        Jiggle ??= ((Slime1Data?.Jiggle ?? 1f) + (Slime2Data?.Jiggle ?? 1f)) / 2f;

        if (BodyStruct != null)
        {
            BodyStruct.IsBody = true;
            // BodyStruct.Jiggle ??= Jiggle;
            // BodyStruct.Mesh ??= "slime_default";
        }

        // if (Slime1Structs != null)
        // {
        //     foreach (var feature in Slime1Structs)
        //         feature.Jiggle ??= Jiggle;
        // }

        // if (Slime2Structs != null)
        // {
        //     foreach (var feature in Slime2Structs)
        //         feature.Jiggle ??= Jiggle;
        // }
    }
}