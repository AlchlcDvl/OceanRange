// ReSharper disable UnassignedField.Global
// ReSharper disable CollectionNeverUpdated.Global

namespace OceanRange.Data;

public sealed class Translations : JsonData
{
    [JsonRequired] public Dictionary<string, Dictionary<string, string>> Additional;
    //                               ^ Bundle           ^ Id    ^ Text

    [JsonRequired] public SlimeLangData[] Slimes;
    [JsonRequired] public HenLangData[] Hens;
    [JsonRequired] public ChickLangData[] Chicks;
    [JsonRequired] public FruitLangData[] Fruits;
    [JsonRequired] public VeggieLangData[] Veggies;
    // [JsonRequired] public CraftLangData[] Crafts;
    // [JsonRequired] public EdibleCraftLangData[] EdibleCrafts;
    [JsonRequired] public RancherLangData[] Ranchers;
    [JsonRequired] public PlortLangData[] Plorts;
    [JsonRequired] public LargoLangData[] Largos;
    [JsonRequired] public GordoLangData[] Gordos;
    // [JsonRequired] public ZoneLangData[] Zones;
    [JsonRequired] public MailLangData[] Mail;

    [JsonIgnore] private LangData[] LangDatas;

    protected override void OnDeserialise() => LangDatas = [.. Slimes, .. Hens, .. Chicks, .. Veggies, .. Fruits, .. Ranchers, .. Gordos, .. Largos, .. Plorts, .. Mail/*, .. Zones, .. Crafts, .. EdibleCrafts */];

    [JsonIgnore] private Dictionary<string, Dictionary<string, string>> TranslatedTexts;

    public Dictionary<string, Dictionary<string, string>> GetTranslations()
    {
        if (TranslatedTexts != null)
            return TranslatedTexts;

        TranslatedTexts = [];

        foreach (var (bundleName, values) in Additional)
        {
            var keyValues = TranslatedTexts.GetBundle(bundleName);

            foreach (var (id, translatedTexts) in values)
                keyValues[id] = translatedTexts;
        }

        foreach (var langData in LangDatas)
            langData.AddTranslations(TranslatedTexts);

        return TranslatedTexts;
    }

    public void OnLanguageChanged()
    {
        foreach (var rancher in Ranchers)
            rancher.OnLanguageChanged();
    }
}

public abstract class LangData : JsonData
{
    [JsonRequired] public string TranslatedName;

    public abstract void AddTranslations(Dictionary<string, Dictionary<string, string>> translations);
}

public sealed class MailLangData : LangData
{
    [JsonRequired] public string Subject;
    [JsonRequired] public string Body;

    [JsonRequired] public string MailKey;

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
    {
        var bundle = translations.GetBundle("mail");
        bundle.AddTranslation("m.from." + MailKey, TranslatedName, "mail");
        bundle.AddTranslation("m.body." + MailKey, Body, "mail");
        bundle.AddTranslation("m.subj." + MailKey, Subject, "mail");
    }
}

public sealed class RancherLangData : LangData
{
    [JsonRequired] public string[] Offers;
    [JsonRequired] public string[] LoadingTexts;

    [JsonRequired] public string SpecialOffer;

    [JsonIgnore] private RancherData Rancher;

    protected override void OnDeserialise()
    {
        Rancher = Contacts.RancherMap[Helpers.ParseEnum<RancherName>(Name.ToUpperInvariant())];
        Rancher.HandleTranslationData(this);
    }

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
    {
        var rancherId = Rancher.RancherId;
        var bundle = translations.GetBundle("exchange");

        for (var i = 0; i < Offers.Length; i++)
            bundle.AddTranslation($"m.offer_{i + 1}.{rancherId}", Offers[i], "exchange");

        bundle.AddTranslation($"m.bonusoffer.{rancherId}", SpecialOffer, "exchange");
        bundle.AddTranslation($"m.rancher.{rancherId}", TranslatedName, "exchange");

        if (!Main.ClsExists)
            return;

        for (var i = 0; i < LoadingTexts.Length; i++)
            bundle.AddTranslation(Translator.LoadingIds[i], LoadingTexts[i], "exchange");
    }

    public void OnLanguageChanged() => Rancher.Rancher.numBlurbs = Offers.Length;
}

public abstract class IdentifiableLangData : LangData
{
    [JsonIgnore] protected IdentifiableId IdentId;

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
        => translations.GetBundle("actor").AddTranslation("l." + IdentId.ToString().ToLowerInvariant(), TranslatedName, "actor");
}

public sealed class PlortLangData : IdentifiableLangData
{
    protected override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name.ToUpperInvariant() + "_PLORT");
}

public sealed class LargoLangData : IdentifiableLangData
{
    protected override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name.ToUpperInvariant().Replace(' ', '_') + "_LARGO");
}

public sealed class GordoLangData : IdentifiableLangData
{
    [JsonIgnore] private bool Exists;

    protected override void OnDeserialise() => Exists = Enum.TryParse(Name.ToUpperInvariant() + "_GORDO", out IdentId);

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
    {
        if (Exists)
            base.AddTranslations(translations);
    }
}

public abstract class PediaLangData(string suffix, PediaCategory category) : LangData
{
    [JsonIgnore] private readonly string Suffix = suffix;
    [JsonIgnore] private readonly PediaCategory Category = category;

    [JsonIgnore] protected PediaId PediaId;
    [JsonIgnore] public string PediaKey;

    [JsonRequired] public string Intro;

    protected override sealed void OnDeserialise()
    {
        var mainPart = Name.ToUpperInvariant() + (Suffix?.Length is > 0 ? ("_" + Suffix) : "");

        var key = mainPart + "_ENTRY";
        PediaId = Helpers.AddEnumValue<PediaId>(key);
        PediaKey = key.ToLowerInvariant();

        OnDeserialisedEvent(mainPart);
    }

    protected virtual void OnDeserialisedEvent(string mainPart) { }

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
    {
        PediaRegistry.SetPediaCategory(PediaId, Category);

        var bundle = translations.GetBundle("pedia");
        bundle.AddTranslation("t." + PediaKey, TranslatedName, "pedia");
        bundle.AddTranslation("m.intro." + PediaKey, Intro, "pedia");
    }
}

// public sealed class ZoneLangData() : PediaLangData(null, PediaCategory.WORLD)
// {
//     [JsonRequired] public string Description;
//     [JsonRequired] public string Presence;

//     [JsonIgnore] public Zone ZoneId;

//     protected override void OnDeserialisedEvent(string mainPart) => ZoneId = Helpers.ParseEnum<Zone>(mainPart);

//     public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
//     {
//         base.AddTranslations(translations);

//         translations.GetBundle("global").AddTranslation("l.presence." + ZoneId.ToString().ToLowerInvariant(), Presence, "global");
//         translations.GetBundle("pedia").AddTranslation("m.desc." + PediaKey, Description, "pedia");
//     }
// }

public abstract class ActorLangData(string suffix, PediaCategory category) : PediaLangData(suffix, category)
{
    [JsonIgnore] protected IdentifiableId ActorId;

    protected override void OnDeserialisedEvent(string mainPart) => ActorId = Helpers.ParseEnum<IdentifiableId>(mainPart);

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(translations);

        PediaRegistry.RegisterIdentifiableMapping(PediaId, ActorId);

        translations.GetBundle("actor").AddTranslation("l." + ActorId.ToString().ToLowerInvariant(), TranslatedName, "actor");
    }
}

public sealed class SlimeLangData() : ActorLangData("SLIME", PediaCategory.SLIMES)
{
    [JsonRequired] public string Risks;
    [JsonRequired] public string Slimeology;
    [JsonRequired] public string Diet;
    [JsonRequired] public string Favourite;
    [JsonRequired] public string Onomics;

    protected override void OnDeserialisedEvent(string mainPart)
    {
        base.OnDeserialisedEvent(mainPart);
        Slimepedia.SlimeDataMap[ActorId].HandleTranslationData(this);
    }

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(translations);

        var bundle = translations.GetBundle("pedia");
        bundle.AddTranslation("m.diet." + PediaKey, Diet, "pedia");
        bundle.AddTranslation("m.risks." + PediaKey, Risks, "pedia");
        bundle.AddTranslation("m.favorite." + PediaKey, Favourite, "pedia");
        bundle.AddTranslation("m.plortonomics." + PediaKey, Onomics, "pedia");
        bundle.AddTranslation("m.slimeology." + PediaKey, Slimeology, "pedia");
    }
}

public abstract class ResourceLangData(string suffix) : ActorLangData(suffix, PediaCategory.RESOURCES)
{
    [JsonRequired] public string Type;
    [JsonRequired] public string Ranch;
    [JsonRequired] public string About;

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(translations);

        var bundle = translations.GetBundle("pedia");
        bundle.AddTranslation("m.desc." + PediaKey, About, "pedia");
        bundle.AddTranslation("m.how_to_use." + PediaKey, Ranch, "pedia");
        bundle.AddTranslation("m.resource_type." + PediaKey, Type, "pedia");
    }
}

// public sealed class CraftLangData() : ResourceLangData("CRAFT");

public abstract class FoodLangData(string suffix) : ResourceLangData(suffix)
{
    [JsonRequired] public string FavouredBy;

    public override sealed void AddTranslations(Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(translations);
        translations.GetBundle("pedia").AddTranslation("m.resource_type." + PediaKey, FavouredBy, "pedia");
    }
}

public sealed class HenLangData() : FoodLangData("HEN");

public sealed class ChickLangData() : FoodLangData("CHICK");

public sealed class FruitLangData() : FoodLangData("FRUIT");

public sealed class VeggieLangData() : FoodLangData("VEGGIE");

// public sealed class EdibleCraftLangData() : FoodLangData("CRAFT");