namespace OceanRange.Modules;

public sealed class LangHolder : JsonData
{
    [JsonRequired] public Dictionary<string, Dictionary<string, Dictionary<string, string>>> Additional;
    //                ^ Bundle           ^ Translation Id   ^ Lang  ^ Translated Text

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
    [JsonRequired] public ZoneLangData[] Zones;
    [JsonRequired] public MailLangData[] Mail;

    [JsonRequired] public string Fallback = "EN";

    [JsonIgnore] public LangData[] LangDatas;

    protected override void OnDeserialise() => LangDatas = [.. Slimes, .. Hens, .. Chicks, .. Veggies, .. Fruits, .. Ranchers, .. Gordos, .. Largos, .. Zones, .. Plorts, .. Mail/*, .. Crafts, .. EdibleCrafts */];

    public void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        foreach (var (bundleName, values) in Additional)
        {
            var keyValues = translations.GetBundle(bundleName);

            foreach (var (id, translatedTexts) in values)
                keyValues[id] = translatedTexts.GetText(langName);
        }

        foreach (var LangData in LangDatas)
            LangData.AddTranslations(langName, translations);
    }

    public void OnLanguageChanged(string langName)
    {
        foreach (var LangData in Ranchers)
            LangData.OnLanguageChanged(langName);
    }
}

public abstract class LangData : JsonData
{
    [JsonRequired] public Dictionary<string, string> Names;

    public abstract void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations);
}

public sealed class MailLangData : LangData
{
    [JsonRequired] public Dictionary<string, string> Subjects;
    [JsonRequired] public Dictionary<string, string> Bodies;

    [JsonRequired] public string MailKey;

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        var bundle = translations.GetBundle("mail");
        bundle["m.from." + MailKey] = Names.GetText(langName);
        bundle["m.subj." + MailKey] = Subjects.GetText(langName);
        bundle["m.body." + MailKey] = Bodies.GetText(langName);
    }
}

public sealed class RancherLangData : LangData
{
    [JsonRequired] public Dictionary<string, string[]> Offers;
    [JsonRequired] public Dictionary<string, string[]> LoadingTexts;

    [JsonRequired] public Dictionary<string, string> SpecialOffers;

    [JsonIgnore] public RancherData Rancher;

    protected override void OnDeserialise()
    {
        Rancher = Contacts.RancherMap[Helpers.ParseEnum<RancherName>(Name.ToUpperInvariant())];

        var rancherId = Rancher.RancherId;
        var set = new HashSet<string>();

        foreach (var array in Offers.Values)
        {
            for (var i = 0; i < array.Length; i++)
            {
                var id = $"m.offer_{i + 1}.{rancherId}";

                if (set.Contains(id))
                    continue;

                ExchangeOfferRegistry.RegisterOfferID(id);
                set.Add(id);
            }
        }

        ExchangeOfferRegistry.RegisterOfferID($"m.bonusoffer.{rancherId}");
    }

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        var rancherId = Rancher.RancherId;
        var array = Offers.GetTexts(langName);
        var bundle = translations.GetBundle("exchange");

        for (var i = 0; i < array.Length; i++)
            bundle[$"m.offer_{i + 1}.{rancherId}"] = array[i];

        bundle[$"m.bonusoffer.{rancherId}"] = SpecialOffers.GetText(langName);
        bundle[$"m.rancher.{rancherId}"] = Names.GetText(langName);
    }

    public void OnLanguageChanged(string langName) => Rancher.Rancher.numBlurbs = Offers.GetTexts(langName).Length;
}

public abstract class IdentifiableLangData : LangData
{
    [JsonIgnore] public IdentifiableId IdentId;

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
        => translations.GetBundle("actor")["l." + IdentId.ToString().ToLowerInvariant()] = Names.GetText(langName);
}

public sealed class PlortLangData() : IdentifiableLangData
{
    protected override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name.ToUpperInvariant() + "_PLORT");
}

public sealed class LargoLangData() : IdentifiableLangData
{
    protected override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name.ToUpperInvariant().Replace(' ', '_') + "_LARGO");
}

public sealed class GordoLangData() : IdentifiableLangData
{
    [JsonIgnore] public bool Exists;

    protected override void OnDeserialise() => Exists = Enum.TryParse(Name.ToUpperInvariant() + "_GORDO", out IdentId);

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        if (Exists)
            base.AddTranslations(langName, translations);
    }
}

// Other pairs of (string, string) are Lang -> Translation

public abstract class PediaLangData(string suffix, PediaCategory category) : LangData
{
    [JsonIgnore] private readonly string Suffix = suffix;
    [JsonIgnore] public readonly PediaCategory Category = category;

    [JsonIgnore] public PediaId PediaId;
    [JsonIgnore] public string PediaKey;

    [JsonRequired] public Dictionary<string, string> Intros;

    protected sealed override void OnDeserialise()
    {
        var mainPart = Name.ToUpperInvariant() + (Suffix.Length > 0 ? ('_' + Suffix) : "");

        var key = mainPart + "_ENTRY";
        PediaId = Helpers.AddEnumValue<PediaId>(key);
        PediaKey = key.ToLowerInvariant();

        OnDeserialisedEvent(mainPart);
    }

    protected virtual void OnDeserialisedEvent(string mainPart) { }

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        PediaRegistry.SetPediaCategory(PediaId, Category);

        var bundle = translations.GetBundle("pedia");
        bundle["t." + PediaKey] = Names.GetText(langName);
        bundle["m.intro." + PediaKey] = Intros.GetText(langName);
    }
}

public sealed class ZoneLangData() : PediaLangData("", PediaCategory.WORLD)
{
    [JsonRequired] public Dictionary<string, string> Descriptions;
    [JsonRequired] public Dictionary<string, string> Presences;
    [JsonIgnore] public Zone ZoneId;

    protected override void OnDeserialisedEvent(string mainPart) => ZoneId = Helpers.ParseEnum<Zone>(mainPart);

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(langName, translations);

        translations.GetBundle("global")["l.presence." + ZoneId.ToString().ToLowerInvariant()] = Presences.GetText(langName);
        translations.GetBundle("pedia")["m.desc." + PediaKey] = Descriptions.GetText(langName);
    }
}

public abstract class ActorLangData(string suffix, PediaCategory category) : PediaLangData(suffix, category)
{
    [JsonIgnore] public IdentifiableId ActorId;

    protected sealed override void OnDeserialisedEvent(string mainPart) => ActorId = Helpers.ParseEnum<IdentifiableId>(mainPart);

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(langName, translations);

        PediaRegistry.RegisterIdentifiableMapping(PediaId, ActorId);
        translations.GetBundle("actor")["l." + ActorId.ToString().ToLowerInvariant()] = Names.GetText(langName);
    }
}

public sealed class SlimeLangData() : ActorLangData("SLIME", PediaCategory.SLIMES)
{
    [JsonRequired] public Dictionary<string, string> Risks;
    [JsonRequired] public Dictionary<string, string> Slimeologies;
    [JsonRequired] public Dictionary<string, string> Diets;
    [JsonRequired] public Dictionary<string, string> Favourites;
    [JsonRequired] public Dictionary<string, string> Onomics;

    public string OnomicsType = "pearls";

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(langName, translations);

        var bundle = translations.GetBundle("pedia");
        bundle["m.diet." + PediaKey] = Diets.GetText(langName);
        bundle["m.risks." + PediaKey] = Risks.GetText(langName);
        bundle["m.favorite." + PediaKey] = Favourites.GetText(langName);
        bundle["m.plortonomics." + PediaKey] = Onomics.GetText(langName);
        bundle["m.slimeology." + PediaKey] = Slimeologies.GetText(langName);
    }
}

public abstract class ResourceLangData(string suffix) : ActorLangData(suffix, PediaCategory.RESOURCES)
{
    [JsonRequired] public Dictionary<string, string> Ranch;
    [JsonRequired] public Dictionary<string, string> Types;
    [JsonRequired] public Dictionary<string, string> About;

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(langName, translations);

        var bundle = translations.GetBundle("pedia");
        bundle["m.desc." + PediaKey] = About.GetText(langName);
        bundle["m.how_to_use." + PediaKey] = Ranch.GetText(langName);
        bundle["m.resource_type." + PediaKey] = Types.GetText(langName);
    }
}

// public sealed class CraftLangData() : ResourceLangData("CRAFT");

public abstract class FoodLangData(string suffix) : ResourceLangData(suffix)
{
    [JsonRequired] public Dictionary<string, string> FavouredBy;

    public sealed override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(langName, translations);

        translations.GetBundle("pedia")["m.resource_type." + PediaKey] = FavouredBy.GetText(langName);
    }
}

public sealed class HenLangData() : FoodLangData("HEN");

public sealed class ChickLangData() : FoodLangData("CHICK");

public sealed class FruitLangData() : FoodLangData("FRUIT");

public sealed class VeggieLangData() : FoodLangData("VEGGIE");

// public sealed class EdibleCraftLangData() : FoodLangData("CRAFT");