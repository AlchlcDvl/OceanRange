using System.Reflection;

namespace OceanRange.Modules;

public sealed class LargoHolder(BinaryReader reader) : Holder(reader)
{
    public LargoData[] Largos;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Largos = reader.ReadArray(Helpers.ReadModData<LargoData>);
    }
}

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

    public LargoProps Props;

    public ModelData BodyStructData;
    public ModelData[] Slime1StructData;
    public ModelData[] Slime2StructData;

    public float? Jiggle;

    public string Slime1;
    public string Slime2;

    public IdentifiableId Slime1Id;
    public IdentifiableId Slime2Id;

    public SlimeData Slime1Data;
    public SlimeData Slime2Data;

    public MethodInfo InitSlime1Details;
    public MethodInfo InitSlime2Details;
    public MethodInfo InitLargoDetails;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Props = reader.ReadArray(Helpers.ReadEnum<LargoProps>).Combine();

        BodyStructData = reader.ReadModData<ModelData>();
        Slime1StructData = reader.ReadArray(Helpers.ReadModData<ModelData>);
        Slime2StructData = reader.ReadArray(Helpers.ReadModData<ModelData>);

        Jiggle = reader.ReadNullable(Helpers.ReadFloat);
    }

    public override void OnDeserialise()
    {
        var parts = Name.TrueSplit(' ');

        Slime1 = parts[0];
        Slime2 = parts[1];

        var slime1Upper = Slime1.ToUpperInvariant();
        var slime2Upper = Slime2.ToUpperInvariant();

        MainId = Helpers.AddEnumValue<IdentifiableId>(slime1Upper + '_' + slime2Upper + "_LARGO");
        Slime1Id = Helpers.ParseEnum<IdentifiableId>(slime1Upper + "_SLIME");
        Slime2Id = Helpers.ParseEnum<IdentifiableId>(slime2Upper + "_SLIME");

        Methods.TryGetValue("Init" + Slime1 + "Details", out InitSlime1Details);
        Methods.TryGetValue("Init" + Slime2 + "Details", out InitSlime2Details);
        Methods.TryGetValue("Init" + Slime1 + Slime2 + "Details", out InitLargoDetails);

        Slimepedia.SlimeDataMap.TryGetValue(Slime1Id, out Slime1Data);
        Slimepedia.SlimeDataMap.TryGetValue(Slime2Id, out Slime2Data);

        Jiggle ??= ((Slime1Data?.JiggleAmount ?? 1f) + (Slime2Data?.JiggleAmount ?? 1f)) / 2f;

        if (BodyStructData != null)
            BodyStructData.IsBody = true;
    }
}