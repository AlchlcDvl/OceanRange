// ReSharper disable UnassignedField.Global
// ReSharper disable MemberCanBePrivate.Global

namespace OceanRange.Data;

[Serializable]
public sealed partial class LargoData : ActorData
{
    protected override bool SerialiseName => true;

    [JsonRequired] public LargoAppearanceData[] Appearances;
}

[Serializable]
public sealed partial class LargoAppearanceData : JsonData
{
    public ModelData[]? Slime1Structs;
    public ModelData[]? Slime2Structs;
}
