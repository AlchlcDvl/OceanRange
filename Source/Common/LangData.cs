// ReSharper disable UnassignedField.Global
// ReSharper disable CollectionNeverUpdated.Global
// ReSharper disable GrammarMistakeInComment

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
    // [JsonRequired] public LampLangData[] Lamps;
    // [JsonRequired] public WarpLangData[] Warps;
    // [JsonRequired] public TeleporterLangData[] Teleporters;

    public Dictionary<string, Dictionary<string, string>> AdditionalExotic;

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);

        writer.PoolStrings(Additional.Keys);

        foreach (var dict in Additional.Values)
        {
            writer.PoolStrings(dict.Keys);
            writer.PoolStrings(dict.Values);
        }

        if (!AdditionalExotic.IsNullOrEmpty())
        {
            writer.PoolStrings(AdditionalExotic.Keys);

            foreach (var dict in AdditionalExotic.Values)
            {
                writer.PoolStrings(dict.Keys);
                writer.PoolStrings(dict.Values);
            }
        }

        Array.ForEach(Slimes, x => x.FindStrings(writer));
        Array.ForEach(Hens, x => x.FindStrings(writer));
        Array.ForEach(Chicks, x => x.FindStrings(writer));
        Array.ForEach(Fruits, x => x.FindStrings(writer));
        Array.ForEach(Veggies, x => x.FindStrings(writer));
        // Array.ForEach(Crafts, x => x.FindStrings(writer));
        // Array.ForEach(EdibleCrafts, x => x.FindStrings(writer));
        Array.ForEach(Ranchers, x => x.FindStrings(writer));
        Array.ForEach(Plorts, x => x.FindStrings(writer));
        Array.ForEach(Largos, x => x.FindStrings(writer));
        Array.ForEach(Gordos, x => x.FindStrings(writer));
        // Array.ForEach(Zones, x => x.FindStrings(writer));
        Array.ForEach(Mail, x => x.FindStrings(writer));
        // Array.ForEach(Lamps, x => x.FindStrings(writer));
        // Array.ForEach(Warps, x => x.FindStrings(writer));
        // Array.ForEach(Teleporters, x => x.FindStrings(writer));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteStringToStringDictionary(Additional);

        writer.WriteArray(Slimes, (w, x) => x.WriteTo(w));
        writer.WriteArray(Hens, (w, x) => x.WriteTo(w));
        writer.WriteArray(Chicks, (w, x) => x.WriteTo(w));
        writer.WriteArray(Fruits, (w, x) => x.WriteTo(w));
        writer.WriteArray(Veggies, (w, x) => x.WriteTo(w));
        // writer.WriteArray(Crafts, (w, x) => x.WriteTo(w));
        // writer.WriteArray(EdibleCrafts, (w, x) => x.WriteTo(w));
        writer.WriteArray(Ranchers, (w, x) => x.WriteTo(w));
        writer.WriteArray(Plorts, (w, x) => x.WriteTo(w));
        writer.WriteArray(Largos, (w, x) => x.WriteTo(w));
        writer.WriteArray(Gordos, (w, x) => x.WriteTo(w));
        // writer.WriteArray(Zones, (w, x) => x.WriteTo(w));
        writer.WriteArray(Mail, (w, x) => x.WriteTo(w));
        // writer.WriteArray(Lamps, (w, x) => x.WriteTo(w));
        // writer.WriteArray(Warps, (w, x) => x.WriteTo(w));
        // writer.WriteArray(Teleporters, (w, x) => x.WriteTo(w));

        writer.WriteNullableStringToStringDictionary(AdditionalExotic);
    }
#else
    [JsonIgnore] private LangData[] LangDatas;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        Additional = reader.ReadStringToStringDictionary();

        Slimes = reader.ReadArray(r => { var x = new SlimeLangData(); x.ReadFrom(r); return x; });
        Hens = reader.ReadArray(r => { var x = new HenLangData(); x.ReadFrom(r); return x; });
        Chicks = reader.ReadArray(r => { var x = new ChickLangData(); x.ReadFrom(r); return x; });
        Fruits = reader.ReadArray(r => { var x = new FruitLangData(); x.ReadFrom(r); return x; });
        Veggies = reader.ReadArray(r => { var x = new VeggieLangData(); x.ReadFrom(r); return x; });
        // Crafts = reader.ReadArray(r => { var x = new CraftLangData(); x.ReadFrom(r); return x; });
        // EdibleCrafts = reader.ReadArray(r => { var x = new EdibleCraftLangData(); x.ReadFrom(r); return x; });
        Ranchers = reader.ReadArray(r => { var x = new RancherLangData(); x.ReadFrom(r); return x; });
        Plorts = reader.ReadArray(r => { var x = new PlortLangData(); x.ReadFrom(r); return x; });
        Largos = reader.ReadArray(r => { var x = new LargoLangData(); x.ReadFrom(r); return x; });
        Gordos = reader.ReadArray(r => { var x = new GordoLangData(); x.ReadFrom(r); return x; });
        // Zones = reader.ReadArray(r => { var x = new ZoneLangData(); x.ReadFrom(r); return x; });
        Mail = reader.ReadArray(r => { var x = new MailLangData(); x.ReadFrom(r); return x; });
        // Lamps = reader.ReadArray(r => { var x = new LampLangData(); x.ReadFrom(r); return x; });
        // Warps = reader.ReadArray(r => { var x = new WarpLangData(); x.ReadFrom(r); return x; });
        // Teleporters = reader.ReadArray(r => { var x = new TeleporterLangData(); x.ReadFrom(r); return x; });

        AdditionalExotic = reader.ReadNullableStringToStringDictionary();
    }

    public override void OnDeserialise()
    {
        base.OnDeserialise();

        LangDatas = [
            .. Slimes, .. Hens, .. Chicks,
            .. Veggies, .. Fruits, .. Ranchers,
            .. Gordos, .. Largos, .. Plorts,
            .. Mail//, .. Lamps, .. Warps,
            // .. Teleporters, .. Zones, .. Crafts,
            // .. EdibleCrafts
        ];

        Array.ForEach(LangDatas, x => x.OnDeserialise());
    }

    [JsonIgnore] private Dictionary<string, Dictionary<string, string>> TranslatedTexts;

    public Dictionary<string, Dictionary<string, string>> GetTranslations(Language lang)
    {
        if (TranslatedTexts != null)
            return TranslatedTexts;

        TranslatedTexts = new(StringComparer.Ordinal);
        Translator.BeginGatherPhase();

        foreach (var (bundleName, values) in Additional)
        {
            var keyValues = TranslatedTexts.GetBundle(bundleName);

            foreach (var (id, translatedText) in values)
                keyValues.AddTranslation(id, translatedText, bundleName);
        }

        foreach (var langData in LangDatas)
            langData.AddTranslations(TranslatedTexts, lang);

        var deferredItems = Translator.EndGatherPhase();
        var isFallback = lang == Config.FALLBACK_LANGUAGE;

        foreach (var item in deferredItems)
            item.AddComplexTranslation(TranslatedTexts, lang, isFallback);

        deferredItems.Clear();
        return TranslatedTexts;
    }

    [JsonIgnore] private bool ExoticTranslationsHandled;

    public void AddExoticTranslations(Language lang)
    {
        if (ExoticTranslationsHandled)
            return;

        Translator.BeginGatherPhase();

        if (AdditionalExotic != null)
        {
            foreach (var (bundleName, values) in AdditionalExotic)
            {
                var keyValues = TranslatedTexts.GetBundle(bundleName);

                foreach (var (id, translatedText) in values)
                    keyValues.AddTranslation(id, translatedText, bundleName);
            }
        }

        foreach (var langData in LangDatas)
            langData.AddExoticTranslations(TranslatedTexts, lang);

        var deferredItems = Translator.EndGatherPhase();
        var isFallback = lang == Config.FALLBACK_LANGUAGE;

        foreach (var item in deferredItems)
            item.AddComplexTranslation(TranslatedTexts, lang, isFallback);

        deferredItems.Clear();
        ExoticTranslationsHandled = true;
    }

    public void OnLanguageChanged(Language lang)
    {
        foreach (var rancher in Ranchers)
            rancher.OnLanguageChanged(lang);
    }

    public void WhenFallback()
    {
        foreach (var langData in LangDatas)
            langData.WhenFallback();
    }
#endif
}

public abstract class LangData : JsonData
{
    [JsonRequired] public string TranslatedName;

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolString(TranslatedName);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(TranslatedName);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        TranslatedName = reader.ReadString();
    }

    public abstract void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang);

    public virtual void AddExoticTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang) { }

    public virtual void WhenFallback() { }
#endif
}

public sealed class MailLangData : LangData
{
    [JsonRequired] public string Subject;
    [JsonRequired] public string Body;

    [JsonRequired] public string MailKey;

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolString(Subject);
        writer.PoolString(Body);
        writer.PoolString(MailKey);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Subject);
        writer.WriteString(Body);
        writer.WriteString(MailKey);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Subject = reader.ReadString();
        Body = reader.ReadString();
        MailKey = reader.ReadString();
    }

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        var bundle = translations.GetBundle("mail");
        bundle.AddTranslation("m.from." + MailKey, TranslatedName, "mail");
        bundle.AddTranslation("m.body." + MailKey, Body, "mail");
        bundle.AddTranslation("m.subj." + MailKey, Subject, "mail");
    }
#endif
}

public sealed class RancherLangData : LangData
{
    [JsonRequired] public string[] Offers;
    [JsonRequired] public string[] LoadingTexts;

    [JsonRequired] public string SpecialOffer;

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolStrings(Offers);
        writer.PoolStrings(LoadingTexts);
        writer.PoolString(SpecialOffer);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteStringArray(Offers);
        writer.WriteStringArray(LoadingTexts);
        writer.WriteString(SpecialOffer);
    }
#else
    [JsonIgnore] private RancherData Rancher;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Offers = reader.ReadStringArray();
        LoadingTexts = reader.ReadStringArray();
        SpecialOffer = reader.ReadString();
    }

    public override void OnDeserialise() => Rancher = Contacts.RancherMap[Helpers.ParseEnum<RancherName>(Name.ToUpperInvariant())];

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        var rancherId = Rancher.RancherId;
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

    public void OnLanguageChanged(Language lang) => Rancher.HandleTranslationData(this, lang);
#endif
}

public abstract class IdentifiableLangData : LangData
{
#if !UNITY
    [JsonIgnore] protected IdentifiableId IdentId;

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang) =>
        translations.GetBundle("actor").AddTranslation("l." + IdentId.ToString().ToLowerInvariant(), TranslatedName, "actor");
#endif
}

public sealed class PlortLangData : IdentifiableLangData
{
#if !UNITY
    public override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name.ToUpperInvariant() + "_PLORT");
#endif
}

public sealed class LargoLangData : IdentifiableLangData
{
#if !UNITY
    public override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name.ToUpperInvariant().Replace(' ', '_') + "_LARGO");
#endif
}

public sealed class GordoLangData : IdentifiableLangData
{
#if !UNITY
    [JsonIgnore] private bool Exists;

    public override void OnDeserialise() => Exists = Enum.TryParse(Name.ToUpperInvariant() + "_GORDO", out IdentId);

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        if (Exists)
            base.AddTranslations(translations, lang);
    }
#endif
}

#if UNITY
public abstract class PediaLangData : LangData
#else
public abstract class PediaLangData(string suffix, PediaCategory category) : LangData
#endif
{
    [JsonRequired] public string Intro;

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolString(Intro);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Intro);
    }
#else
    [JsonIgnore] private readonly string Suffix = suffix;
    [JsonIgnore] private readonly PediaCategory Category = category;

    [JsonIgnore] public PediaId PediaId;
    [JsonIgnore] public string PediaKey;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Intro = reader.ReadString();
    }

    public sealed override void OnDeserialise()
    {
        var mainPart = Name.ToUpperInvariant() + (Suffix?.Length is > 0 ? ("_" + Suffix) : string.Empty);

        var key = mainPart + "_ENTRY";
        PediaId = Helpers.AddEnumValue<PediaId>(key);
        PediaKey = key.ToLowerInvariant();

        OnDeserialisedEvent(mainPart);
    }

    protected virtual void OnDeserialisedEvent(string mainPart) { }

    public override void WhenFallback() => PediaRegistry.SetPediaCategory(PediaId, Category);

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        var bundle = translations.GetBundle("pedia");
        bundle.AddTranslation("t." + PediaKey, TranslatedName, "pedia");
        bundle.AddTranslation("m.intro." + PediaKey, Intro, "pedia");
    }
#endif
}

// #if UNITY
// public sealed class ZoneLangData : PediaLangData
// #else
// public sealed class ZoneLangData() : PediaLangData(null, PediaCategory.WORLD)
// #endif
// {
//     [JsonRequired] public string Description;
//     [JsonRequired] public string Presence;

// #if UNITY
//     public override void FindStrings(DataWriter writer)
//     {
//         base.FindStrings(writer);
//         writer.PoolString(Description);
//         writer.PoolString(Presence);
//     }

//     public override void WriteTo(DataWriter writer)
//     {
//         base.WriteTo(writer);
//         writer.WriteString(Description);
//         writer.WriteString(Presence);
//     }
// #else
//     [JsonIgnore] public Zone ZoneId;

//     public override void ReadFrom(DataReader reader)
//     {
//         base.ReadFrom(reader);
//         Description = reader.ReadString();
//         Presence = reader.ReadString();
//     }

//     protected override void OnDeserialisedEvent(string mainPart) => ZoneId = Helpers.ParseEnum<Zone>(mainPart);

//     public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
//     {
//         base.AddTranslations(translations, lang);

//         translations.GetBundle("global").AddTranslation("l.presence." + ZoneId.ToString().ToLowerInvariant(), Presence, "global");
//         translations.GetBundle("pedia").AddTranslation("m.desc." + PediaKey, Description, "pedia");
//     }
// #endif
// }

#if UNITY
public abstract class ActorLangData : PediaLangData
#else
public abstract class ActorLangData(string suffix, PediaCategory category) : PediaLangData(suffix, category)
#endif
{
#if !UNITY
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
#endif
}

#if UNITY
public sealed class SlimeLangData : ActorLangData
#else
public sealed class SlimeLangData() : ActorLangData("SLIME", PediaCategory.SLIMES)
#endif
{
    [JsonRequired] public string Risks;
    [JsonRequired] public string Slimeology;
    [JsonRequired] public string Diet;
    [JsonRequired] public string Favourite;
    [JsonRequired] public string Onomics;

    public string Exotic;
    public bool SsExists;

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolString(Risks);
        writer.PoolString(Slimeology);
        writer.PoolString(Diet);
        writer.PoolString(Favourite);
        writer.PoolString(Onomics);
        writer.PoolString(Exotic);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Risks);
        writer.WriteString(Slimeology);
        writer.WriteString(Diet);
        writer.WriteString(Favourite);
        writer.WriteString(Onomics);
        writer.WriteString(Exotic);
        writer.WriteBool(SsExists);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Risks = reader.ReadString();
        Slimeology = reader.ReadString();
        Diet = reader.ReadString();
        Favourite = reader.ReadString();
        Onomics = reader.ReadString();
        Exotic = reader.ReadString();
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
#endif
}

#if UNITY
public abstract class ResourceLangData : ActorLangData
#else
public abstract class ResourceLangData(string suffix) : ActorLangData(suffix, PediaCategory.RESOURCES)
#endif
{
    [JsonRequired] public string Type;
    [JsonRequired] public string Ranch;
    [JsonRequired] public string About;

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolString(Type);
        writer.PoolString(Ranch);
        writer.PoolString(About);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Type);
        writer.WriteString(Ranch);
        writer.WriteString(About);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Type = reader.ReadString();
        Ranch = reader.ReadString();
        About = reader.ReadString();
    }

    public override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        base.AddTranslations(translations, lang);

        var bundle = translations.GetBundle("pedia");
        bundle.AddTranslation("m.desc." + PediaKey, About, "pedia");
        bundle.AddTranslation("m.how_to_use." + PediaKey, Ranch, "pedia");
        bundle.AddTranslation("m.resource_type." + PediaKey, Type, "pedia");
    }
#endif
}

#if UNITY
// public sealed class CraftLangData : ResourceLangData;
#else
// public sealed class CraftLangData() : ResourceLangData("CRAFT");
#endif

#if UNITY
public abstract class FoodLangData : ResourceLangData
#else
public abstract class FoodLangData(string suffix) : ResourceLangData(suffix)
#endif
{
    [JsonRequired] public string FavouredBy;

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolString(FavouredBy);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(FavouredBy);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        FavouredBy = reader.ReadString();
    }

    public sealed override void AddTranslations(Dictionary<string, Dictionary<string, string>> translations, Language lang)
    {
        base.AddTranslations(translations, lang);
        translations.GetBundle("pedia").AddTranslation("m.favored_by." + PediaKey, FavouredBy, "pedia");
    }
#endif
}

#if UNITY
public sealed class HenLangData : FoodLangData;

public sealed class ChickLangData : FoodLangData;

public sealed class FruitLangData : FoodLangData;

public sealed class VeggieLangData : FoodLangData;

// public sealed class EdibleCraftLangData : FoodLangData;
#else
public sealed class HenLangData() : FoodLangData("HEN");

public sealed class ChickLangData() : FoodLangData("CHICK");

public sealed class FruitLangData() : FoodLangData("FRUIT");

public sealed class VeggieLangData() : FoodLangData("VEGGIE");

// public sealed class EdibleCraftLangData() : FoodLangData("CRAFT");
#endif