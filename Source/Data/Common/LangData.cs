// ReSharper disable UnassignedField.Global
// ReSharper disable CollectionNeverUpdated.Global
// ReSharper disable GrammarMistakeInComment

namespace OceanRange.Data;

[Serializable]
public sealed partial class Translations : JsonData
{
    protected override bool SerialiseName => true;

    [JsonRequired, SerializeField] public Dictionary<string, Dictionary<string, string>> Additional;

    [JsonRequired] public SlimeLangData[] Slimes;
    [JsonRequired] public HenLangData[] Hens;
    [JsonRequired] public ChickLangData[] Chicks;
    [JsonRequired] public FruitLangData[] Fruits;
    [JsonRequired] public VeggieLangData[] Veggies;
    [JsonRequired] public RancherLangData[] Ranchers;
    [JsonRequired] public PlortLangData[] Plorts;
    [JsonRequired] public LargoLangData[] Largos;
    [JsonRequired] public GordoLangData[] Gordos;
    [JsonRequired] public MailLangData[] Mail;

    [SerializeField] public Dictionary<string, Dictionary<string, string>> AdditionalExotic;
}

public abstract partial class LangData : JsonData
{
    protected override bool SerialiseName => true;

    [JsonRequired, JsonProperty] protected string TranslatedName;
}

[Serializable]
public sealed partial class MailLangData : LangData
{
    [JsonRequired] public string Subject;
    [JsonRequired] public string Body;

    [JsonRequired] public string MailKey;
}

[Serializable]
public sealed partial class RancherLangData : LangData
{
    [JsonRequired] public string[] Offers;
    [JsonRequired] public string[] LoadingTexts;

    [JsonRequired] public string SpecialOffer;
}

public abstract partial class IdentifiableLangData : LangData;

[Serializable]
public sealed partial class PlortLangData : IdentifiableLangData;

[Serializable]
public sealed partial class LargoLangData : IdentifiableLangData;

[Serializable]
public sealed partial class GordoLangData : IdentifiableLangData;

public abstract partial class PediaLangData
{
    [JsonRequired, JsonProperty] public string Intro;
}

public abstract partial class ActorLangData;

[Serializable]
public sealed partial class SlimeLangData
{
    [JsonRequired, JsonProperty] public string Risks;
    [JsonRequired, JsonProperty] public string Slimeology;
    [JsonRequired, JsonProperty] public string Diet;
    [JsonRequired, JsonProperty] public string Favourite;
    [JsonRequired, JsonProperty] public string Onomics;

    public string Exotic;
    public bool SsExists;
}

public abstract partial class ResourceLangData
{
    [JsonRequired, JsonProperty] public string Type;
    [JsonRequired, JsonProperty] public string Ranch;
    [JsonRequired, JsonProperty] public string About;
}

public sealed partial class CraftLangData;

public abstract partial class FoodLangData
{
    [JsonRequired, JsonProperty] public string FavouredBy;
}

[Serializable]
public sealed partial class HenLangData;

[Serializable]
public sealed partial class ChickLangData;

[Serializable]
public sealed partial class FruitLangData;

[Serializable]
public sealed partial class VeggieLangData;

public abstract partial class GadgetLangData : LangData
{
    public string CustomDescription;
}

[Serializable]
public sealed partial class LampLangData : GadgetLangData;

[Serializable]
public sealed partial class WarpLangData : GadgetLangData;

[Serializable]
public sealed partial class TeleporterLangData : GadgetLangData;
