namespace OceanRange.Data;

public sealed partial class LangHolder : Holder
{
    [JsonProperty("hens"), JsonRequired] public List<NestedStringStringDictEntryLayer2> AdditionalUnity;

    [JsonProperty("hens"), JsonRequired] public FoodLangData[] HensUnity;
    [JsonProperty("chicks"), JsonRequired] public FoodLangData[] ChicksUnity;
    [JsonProperty("fruits"), JsonRequired] public FoodLangData[] FruitsUnity;
    [JsonProperty("veggies"), JsonRequired] public FoodLangData[] VeggiesUnity;
    // [JsonProperty("crafts"), JsonRequired] public ResourceLangData[] CraftsUnity;
    // [JsonProperty("edibleCrafts"), JsonRequired] public FoodLangData[] EdibleCraftsUnity;
    [JsonProperty("plorts"), JsonRequired] public LangData[] PlortsUnity;
    [JsonProperty("largos"), JsonRequired] public LangData[] LargosUnity;
    [JsonProperty("gordos"), JsonRequired] public LangData[] GordosUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteArray(Slimes, Helpers.WriteModData);
        writer.WriteArray(HensUnity, Helpers.WriteModData);
        writer.WriteArray(ChicksUnity, Helpers.WriteModData);
        writer.WriteArray(FruitsUnity, Helpers.WriteModData);
        writer.WriteArray(VeggiesUnity, Helpers.WriteModData);
        // writer.WriteArray(CraftsUnity, Helpers.WriteModData);
        // writer.WriteArray(EdibleCraftsUnity, Helpers.WriteModData);
        writer.WriteArray(Ranchers, Helpers.WriteModData);
        writer.WriteArray(PlortsUnity, Helpers.WriteModData);
        writer.WriteArray(LargosUnity, Helpers.WriteModData);
        writer.WriteArray(GordosUnity, Helpers.WriteModData);
        writer.WriteArray(Zones, Helpers.WriteModData);
        writer.WriteArray(Mail, Helpers.WriteModData);

        // Oh god
        writer.WriteDictionary(AdditionalUnity,
            (writer1, x) => writer1.WriteDictionary(x,
                (writer2, y) => writer2.WriteDictionary(y, Helpers.WriteString)));

        writer.WriteString(Fallback);
    }
}

public partial class LangData : ModData
{
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> NamesUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(NamesUnity, Helpers.WriteString);
    }
}

public sealed partial class MailLangData : LangData
{
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> SubjectsUnity;
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> BodiesUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteString(MailKey);
        writer.WriteDictionary(SubjectsUnity, Helpers.WriteString);
        writer.WriteDictionary(BodiesUnity, Helpers.WriteString);
    }
}

public sealed partial class RancherLangData : LangData
{
    [JsonProperty, JsonRequired] public List<StringStringArrayDictEntry> OffersUnity;
    [JsonProperty, JsonRequired] public List<StringStringArrayDictEntry> LoadingTextsUnity;

    [JsonProperty, JsonRequired] public List<StringStringDictEntry> SpecialOffersUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(SpecialOffersUnity, Helpers.WriteString);
        writer.WriteDictionary(OffersUnity, (writer, x) => writer.WriteArray(x, Helpers.WriteString));
        writer.WriteDictionary(LoadingTextsUnity, (writer, x) => writer.WriteArray(x, Helpers.WriteString));
    }
}

// Other pairs of (string, string) are Lang -> Translation

public abstract partial class PediaLangData : LangData
{
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> IntrosUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(IntrosUnity, Helpers.WriteString);
    }
}

public sealed partial class ZoneLangData : PediaLangData
{
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> DescriptionsUnity;
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> PresencesUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(DescriptionsUnity, Helpers.WriteString);
        writer.WriteDictionary(PresencesUnity, Helpers.WriteString);
    }
}

public sealed partial class SlimeLangData
#if UNITY
    : PediaLangData
#endif
{
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> RisksUnity;
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> SlimeologiesUnity;
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> DietsUnity;
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> FavouritesUnity;
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> OnomicsUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(RisksUnity, Helpers.WriteString);
        writer.WriteDictionary(SlimeologiesUnity, Helpers.WriteString);
        writer.WriteDictionary(DietsUnity, Helpers.WriteString);
        writer.WriteDictionary(FavouritesUnity, Helpers.WriteString);
        writer.WriteDictionary(OnomicsUnity, Helpers.WriteString);
        writer.WriteString(OnomicsType);
    }
}

public partial class ResourceLangData
#if UNITY
    : PediaLangData
#endif
{
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> RanchUnity;
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> TypesUnity;
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> AboutUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(RanchUnity, Helpers.WriteString);
        writer.WriteDictionary(TypesUnity, Helpers.WriteString);
        writer.WriteDictionary(AboutUnity, Helpers.WriteString);
    }
}

public partial class FoodLangData : ResourceLangData
{
    [JsonProperty, JsonRequired] public List<StringStringDictEntry> FavouredByUnity;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(FavouredByUnity, Helpers.WriteString);
    }
}