#if !UNITY
namespace OceanRange.Data;

public sealed partial class Translations
{
    [JsonIgnore] private LangData[] langDatas;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        Additional = reader.ReadStringToStringDictionary()!;

        Slimes = reader.ReadArray(r => { var x = new SlimeLangData(); x.ReadFrom(r); return x; })!;
        Hens = reader.ReadArray(r => { var x = new HenLangData(); x.ReadFrom(r); return x; })!;
        Chicks = reader.ReadArray(r => { var x = new ChickLangData(); x.ReadFrom(r); return x; })!;
        Fruits = reader.ReadArray(r => { var x = new FruitLangData(); x.ReadFrom(r); return x; })!;
        Veggies = reader.ReadArray(r => { var x = new VeggieLangData(); x.ReadFrom(r); return x; })!;
        Ranchers = reader.ReadArray(r => { var x = new RancherLangData(); x.ReadFrom(r); return x; })!;
        Plorts = reader.ReadArray(r => { var x = new PlortLangData(); x.ReadFrom(r); return x; })!;
        Largos = reader.ReadArray(r => { var x = new LargoLangData(); x.ReadFrom(r); return x; })!;
        Gordos = reader.ReadArray(r => { var x = new GordoLangData(); x.ReadFrom(r); return x; })!;
        Mail = reader.ReadArray(r => { var x = new MailLangData(); x.ReadFrom(r); return x; })!;

        AdditionalExotic = reader.ReadNullableStringToStringDictionary()!;
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        langDatas = [
            .. Slimes, .. Hens, .. Chicks,
            .. Veggies, .. Fruits, .. Ranchers,
            .. Gordos, .. Largos, .. Plorts,
            .. Mail,
        ];

        Array.ForEach(langDatas, x => x.OnDeserialise());
    }

    [JsonIgnore] private Dictionary<string, Dictionary<string, string>>? translatedTexts;

    public Dictionary<string, Dictionary<string, string>> GetTranslations(Language lang)
    {
        if (translatedTexts != null)
            return translatedTexts;

        translatedTexts = new(StringComparer.Ordinal);
        Translator.BeginGatherPhase();

        foreach (var (bundleName, values) in Additional)
        {
            var keyValues = translatedTexts.GetBundle(bundleName);

            foreach (var (id, translatedText) in values)
                keyValues.AddTranslation(id, translatedText, bundleName);
        }

        foreach (var langData in langDatas)
            langData.AddTranslations(translatedTexts, lang);

        var deferredItems = Translator.EndGatherPhase();
        var isFallback = lang == Config.FALLBACK_LANGUAGE;

        foreach (var item in deferredItems)
            item.AddComplexTranslation(translatedTexts, lang, isFallback);

        deferredItems.Clear();
        return translatedTexts;
    }

    [JsonIgnore] private bool exoticTranslationsHandled;

    public void AddExoticTranslations(Language lang)
    {
        if (exoticTranslationsHandled)
            return;

        Translator.BeginGatherPhase();

        if (AdditionalExotic != null!)
        {
            foreach (var (bundleName, values) in AdditionalExotic)
            {
                var keyValues = translatedTexts!.GetBundle(bundleName);

                foreach (var (id, translatedText) in values)
                    keyValues.AddTranslation(id, translatedText, bundleName);
            }
        }

        foreach (var langData in langDatas)
            langData.AddExoticTranslations(translatedTexts!, lang);

        var deferredItems = Translator.EndGatherPhase();
        var isFallback = lang == Config.FALLBACK_LANGUAGE;

        foreach (var item in deferredItems)
            item.AddComplexTranslation(translatedTexts!, lang, isFallback);

        deferredItems.Clear();
        exoticTranslationsHandled = true;
    }

    public void OnLanguageChanged(Language lang)
    {
        foreach (var rancher in Ranchers)
            rancher.OnLanguageChanged(lang);
    }

    public void WhenFallback()
    {
        foreach (var langData in langDatas)
            langData.WhenFallback();
    }
}

public abstract partial class LangData
{
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        TranslatedName = reader.ReadString()!;
    }

    public abstract void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang);

    public virtual void AddExoticTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang) { }

    public virtual void WhenFallback() { }
}

public sealed partial class MailLangData
{
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Subject = reader.ReadString()!;
        Body = reader.ReadString()!;
        MailKey = reader.ReadString()!;
    }

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        var bundle = translations.GetBundle("mail");
        bundle.AddTranslation("m.from." + MailKey, TranslatedName, "mail");
        bundle.AddTranslation("m.body." + MailKey, Body, "mail");
        bundle.AddTranslation("m.subj." + MailKey, Subject, "mail");
    }
}

public sealed partial class RancherLangData
{
    [JsonIgnore] private RancherData rancher;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Offers = reader.ReadStringArray()!;
        LoadingTexts = reader.ReadStringArray()!;
        SpecialOffer = reader.ReadString()!;
    }

    public override void OnDeserialise() => rancher = Contacts.RancherMap[Helpers.ParseEnum<RancherName>(Name!.ToUpperInvariant())];

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        var rancherId = rancher.RancherId;
        var bundle = translations.GetBundle("exchange");

        for (var i = 0; i < Offers.Length; i++)
            bundle.AddTranslation($"m.offer_{i + 1}.{rancherId}", Offers[i], "exchange");

        bundle.AddTranslation($"m.bonusoffer.{rancherId}", SpecialOffer, "exchange");
        bundle.AddTranslation($"m.rancher.{rancherId}", TranslatedName, "exchange");

        if (!Main.ClsExists || !Translator.LoadingIds.TryGetValue(lang, out var ids))
            return;

        var bundle2 = translations.GetBundle("ui");

        for (var i = 0; i < LoadingTexts.Length; i++)
            bundle2.AddTranslation(ids[i], LoadingTexts[i], "ui");
    }

    public void OnLanguageChanged(Language lang) => rancher.HandleTranslationData(this, lang);
}

public abstract partial class IdentifiableLangData
{
    [JsonIgnore] protected IdentifiableId IdentId;

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang) =>
        translations.GetBundle("actor").AddTranslation("l." + IdentId.ToString().ToLowerInvariant(), TranslatedName, "actor");
}

public sealed partial class PlortLangData
{
    public override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name!.ToUpperInvariant() + "_PLORT");
}

public sealed partial class LargoLangData
{
    public override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name!.ToUpperInvariant().Replace(' ', '_') + "_LARGO");
}

public sealed partial class GordoLangData
{
    [JsonIgnore] private bool exists;

    public override void OnDeserialise() => exists = Enum.TryParse(Name!.ToUpperInvariant() + "_GORDO", out IdentId);

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        if (exists)
            base.AddTranslations(translations, lang);
    }
}

public abstract partial class PediaLangData(string suffix, PediaCategory category) : LangData
{
    [JsonIgnore] private readonly string suffix = suffix;
    [JsonIgnore] private readonly PediaCategory category = category;

    [JsonIgnore] public PediaId PediaId;
    [JsonIgnore] public string PediaKey;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Intro = reader.ReadString()!;
    }

    public sealed override void OnDeserialise()
    {
        var mainPart = Name!.ToUpperInvariant() + (string.IsNullOrEmpty(suffix) ? string.Empty : ("_" + suffix));

        var key = mainPart + "_ENTRY";
        PediaId = Helpers.AddEnumValue<PediaId>(key);
        PediaKey = key.ToLowerInvariant();

        OnDeserialisedEvent(mainPart);
    }

    protected virtual void OnDeserialisedEvent(string mainPart) { }

    public override void WhenFallback() => PediaRegistry.SetPediaCategory(PediaId, category);

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        var bundle = translations.GetBundle("pedia");
        bundle.AddTranslation("t." + PediaKey, TranslatedName, "pedia");
        bundle.AddTranslation("m.intro." + PediaKey, Intro, "pedia");
    }
}

public abstract partial class ActorLangData(string suffix, PediaCategory category) : PediaLangData(suffix, category)
{
    [JsonIgnore] protected IdentifiableId ActorId;

    protected override void OnDeserialisedEvent(string mainPart) => ActorId = Helpers.ParseEnum<IdentifiableId>(mainPart);

    public override void WhenFallback()
    {
        base.WhenFallback();
        PediaRegistry.RegisterIdentifiableMapping(PediaId, ActorId);
    }

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        base.AddTranslations(translations, lang);
        translations.GetBundle("actor").AddTranslation("l." + ActorId.ToString().ToLowerInvariant(), TranslatedName, "actor");
    }
}

public sealed partial class SlimeLangData() : ActorLangData("SLIME", PediaCategory.SLIMES)
{
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Risks = reader.ReadString()!;
        Slimeology = reader.ReadString()!;
        Diet = reader.ReadString()!;
        Favourite = reader.ReadString()!;
        Onomics = reader.ReadString()!;
        Exotic = reader.ReadString()!;
        SsExists = reader.ReadBool();
    }

    public override void WhenFallback()
    {
        base.WhenFallback();
        Slimepedia.SlimeDataMap[ActorId].HandleTranslationData(this);
    }

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        base.AddTranslations(translations, lang);

        var bundle = translations.GetBundle("pedia");
        bundle.AddTranslation("m.diet." + PediaKey, Diet, "pedia");
        bundle.AddTranslation("m.risks." + PediaKey, Risks, "pedia");
        bundle.AddTranslation("m.favorite." + PediaKey, Favourite, "pedia");
        bundle.AddTranslation("m.plortonomics." + PediaKey, Onomics, "pedia");
        bundle.AddTranslation("m.slimeology." + PediaKey, Slimeology, "pedia");
    }

    public override void AddExoticTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        if (SsExists)
            translations.GetBundle("actor").AddTranslation("t.secret_style_" + PediaKey, Exotic, "actor");
    }
}

public abstract partial class ResourceLangData(string suffix) : ActorLangData(suffix, PediaCategory.RESOURCES)
{
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Type = reader.ReadString()!;
        Ranch = reader.ReadString()!;
        About = reader.ReadString()!;
    }

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        base.AddTranslations(translations, lang);

        var bundle = translations.GetBundle("pedia");
        bundle.AddTranslation("m.desc." + PediaKey, About, "pedia");
        bundle.AddTranslation("m.how_to_use." + PediaKey, Ranch, "pedia");
        bundle.AddTranslation("m.resource_type." + PediaKey, Type, "pedia");
    }
}

public sealed partial class CraftLangData() : ResourceLangData("CRAFT");

public abstract partial class FoodLangData(string suffix) : ResourceLangData(suffix)
{
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        FavouredBy = reader.ReadString()!;
    }

    public sealed override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        base.AddTranslations(translations, lang);
        translations.GetBundle("pedia").AddTranslation("m.favored_by." + PediaKey, FavouredBy, "pedia");
    }
}

public sealed partial class HenLangData() : FoodLangData("HEN");

public sealed partial class ChickLangData() : FoodLangData("CHICK");

public sealed partial class FruitLangData() : FoodLangData("FRUIT");

public sealed partial class VeggieLangData() : FoodLangData("VEGGIE");

public abstract partial class GadgetLangData
{
    protected virtual string Prefix => string.Empty;
    protected virtual string DescId => string.Empty;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        CustomDescription = reader.ReadString()!;
    }

    public override sealed void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        var pedia = translations.GetBundle("pedia");

        var part = Prefix + (string.IsNullOrEmpty(Prefix) ? string.Empty : "_") + Name!.ToLowerInvariant();
        pedia.AddTranslation("m.gadget.name." + part, TranslatedName, "pedia");

        var descText = string.IsNullOrEmpty(CustomDescription) ? $"@m.gadget.desc.{DescId}" : CustomDescription;
        pedia.AddTranslation("m.gadget.desc." + part, descText, "pedia");
    }
}

public sealed partial class LampLangData
{
    protected override string DescId => "lamp_pink";
    protected override string Prefix => "lamp";
}

public sealed partial class WarpLangData
{
    protected override string DescId => "warp_depot_pink";
    protected override string Prefix => "warp_depot";
}

public sealed partial class TeleporterLangData
{
    protected override string DescId => "teleporter_pink";
    protected override string Prefix => "teleporter";
}
#endif
