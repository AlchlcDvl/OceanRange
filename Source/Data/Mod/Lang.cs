namespace OceanRange.Data;

public sealed partial class LangHolder : Holder
{
    [JsonProperty, JsonRequired] public HenLangData[] Hens;
    [JsonProperty, JsonRequired] public ChickLangData[] Chicks;
    [JsonProperty, JsonRequired] public FruitLangData[] Fruits;
    [JsonProperty, JsonRequired] public VeggieLangData[] Veggies;
    // [JsonProperty, JsonRequired] public CraftLangData[] Crafts;
    // [JsonProperty, JsonRequired] public EdibleCraftLangData[] EdibleCrafts;
    [JsonProperty, JsonRequired] public PlortLangData[] Plorts;
    [JsonProperty, JsonRequired] public LargoLangData[] Largos;
    [JsonProperty, JsonRequired] public GordoLangData[] Gordos;

    [JsonProperty, JsonRequired] public Dictionary<string, Dictionary<string, Dictionary<string, string>>> Additional;
    //                ^ Bundle           ^ Translation Id   ^ Lang  ^ Translated Text

    public LangData[] LangDatas;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Slimes = reader.ReadArray(Helpers.ReadModData<SlimeLangData>);
        Hens = reader.ReadArray(Helpers.ReadModData<HenLangData>);
        Chicks = reader.ReadArray(Helpers.ReadModData<ChickLangData>);
        Fruits = reader.ReadArray(Helpers.ReadModData<FruitLangData>);
        Veggies = reader.ReadArray(Helpers.ReadModData<VeggieLangData>);
        // Crafts = reader.ReadArray(Helpers.ReadModData<CraftLangData>);
        // EdibleCrafts = reader.ReadArray(Helpers.ReadModData<EdibleCraftLangData>);
        Ranchers = reader.ReadArray(Helpers.ReadModData<RancherLangData>);
        Plorts = reader.ReadArray(Helpers.ReadModData<PlortLangData>);
        Largos = reader.ReadArray(Helpers.ReadModData<LargoLangData>);
        Gordos = reader.ReadArray(Helpers.ReadModData<GordoLangData>);
        Zones = reader.ReadArray(Helpers.ReadModData<ZoneLangData>);
        Mail = reader.ReadArray(Helpers.ReadModData<MailLangData>);

        Additional = reader.ReadDictionary(r => r.ReadDictionary(r2 => r2.ReadDictionary(Helpers.ReadString2)));

        Fallback = reader.ReadString2();
    }

    public override void OnDeserialise() => LangDatas = [.. Slimes, .. Hens, .. Chicks, .. Veggies, .. Fruits, .. Ranchers, .. Gordos, .. Largos, .. Zones, .. Plorts, .. Mail/*, .. Crafts, .. EdibleCrafts */];

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

public abstract partial class LangData : ModData
{
    [JsonProperty, JsonRequired] public Dictionary<string, string> Names;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Names = reader.ReadDictionary(Helpers.ReadString2);
    }

    public abstract void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations);
}

public sealed partial class MailLangData : LangData
{
    [JsonProperty, JsonRequired] public Dictionary<string, string> Subjects;
    [JsonProperty, JsonRequired] public Dictionary<string, string> Bodies;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        MailKey = reader.ReadString2();
        Subjects = reader.ReadDictionary(Helpers.ReadString2);
        Bodies = reader.ReadDictionary(Helpers.ReadString2);
    }

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        var bundle = translations.GetBundle("mail");
        bundle["m.from." + MailKey] = Names.GetText(langName);
        bundle["m.subj." + MailKey] = Subjects.GetText(langName);
        bundle["m.body." + MailKey] = Bodies.GetText(langName);
    }
}

public sealed partial class RancherLangData : LangData
{
    [JsonProperty, JsonRequired] public Dictionary<string, string> SpecialOffers;

    [JsonProperty, JsonRequired] public Dictionary<string, string[]> Offers;
    [JsonProperty, JsonRequired] public Dictionary<string, string[]> LoadingTexts;

    public RancherData Rancher;

    private readonly List<string> LoadingIds = [];

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        SpecialOffers = reader.ReadDictionary(Helpers.ReadString2);
        Offers = reader.ReadDictionary(r => r.ReadArray(Helpers.ReadString2));
        LoadingTexts = reader.ReadDictionary(r => r.ReadArray(Helpers.ReadString2));
    }

    public override void OnDeserialise()
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

        if (!Main.ClsExists)
            return;

        var set2 = new HashSet<int>();

        foreach (var array in LoadingTexts.Values)
        {
            for (var i = 0; i < array.Length; i++)
            {
                if (set2.Contains(i))
                    continue;

                LoadingIds.Add(Main.GetNextLoadingIdBypass());
                set2.Add(i);
            }
        }
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

        if (!Main.ClsExists)
            return;

        var array2 = LoadingTexts.GetTexts(langName);

        for (var i = 0; i < array2.Length; i++)
            bundle[LoadingIds[i]] = array2[i];
    }

    public void OnLanguageChanged(string langName) => Rancher.Rancher.numBlurbs = Offers.GetTexts(langName).Length;
}

public abstract class IdentifiableLangData(string suffix) : LangData
{
    private readonly string Suffix = suffix;

    public IdentifiableId IdentId;

    public override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name.ToUpperInvariant() + "_" + Suffix);

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations) => translations.GetBundle("actor")["l." + IdentId.ToString().ToLowerInvariant()] = Names.GetText(langName);
}

[Serializable]
public sealed class PlortLangData() : IdentifiableLangData("PLORT");

[Serializable]
public sealed class LargoLangData() : IdentifiableLangData("LARGO")
{
    public override void OnDeserialise() => IdentId = Helpers.ParseEnum<IdentifiableId>(Name.ToUpperInvariant().Replace(" ", "_") + "_LARGO");
}

[Serializable]
public sealed class GordoLangData() : IdentifiableLangData("GORDO")
{
    public bool Exists;

    public override void OnDeserialise() => Exists = Enum.TryParse(Name.ToUpperInvariant() + "_GORDO", out IdentId);

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        if (Exists)
            base.AddTranslations(langName, translations);
    }
}

// Other pairs of (string, string) are Lang -> Translation

public abstract partial class PediaLangData(string suffix, PediaCategory category) : LangData
{
    private readonly string Suffix = suffix;
    public readonly PediaCategory Category = category;

    public PediaId PediaId;
    public string PediaKey;

    [JsonProperty, JsonRequired] public Dictionary<string, string> Intros;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Intros = reader.ReadDictionary(Helpers.ReadString2);
    }

    public override void OnDeserialise()
    {
        var mainPart = Name.ToUpperInvariant() + (Suffix.Length > 0 ? ("_" + Suffix) : "");

        var key = mainPart + "_ENTRY";
        PediaId = Helpers.AddEnumValue<PediaId>(key);
        PediaKey = key.ToLowerInvariant();

        OnDeserialised(mainPart);
    }

    protected virtual void OnDeserialised(string mainPart) { }

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        PediaRegistry.SetPediaCategory(PediaId, Category);

        var bundle = translations.GetBundle("pedia");
        bundle["t." + PediaKey] = Names.GetText(langName);
        bundle["m.intro." + PediaKey] = Intros.GetText(langName);
    }
}

public sealed partial class ZoneLangData() : PediaLangData("", PediaCategory.WORLD)
{
    [JsonProperty, JsonRequired] public Dictionary<string, string> Descriptions;
    [JsonProperty, JsonRequired] public Dictionary<string, string> Presences;

    public Zone ZoneId;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Descriptions = reader.ReadDictionary(Helpers.ReadString2);
        Presences = reader.ReadDictionary(Helpers.ReadString2);
    }

    protected override void OnDeserialised(string mainPart) => ZoneId = Helpers.ParseEnum<Zone>(mainPart);

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(langName, translations);

        translations.GetBundle("global")["l.presence." + ZoneId.ToString().ToLowerInvariant()] = Presences.GetText(langName);
        translations.GetBundle("pedia")["m.desc." + PediaKey] = Descriptions.GetText(langName);
    }
}

public abstract class ActorLangData(string suffix, PediaCategory category) : PediaLangData(suffix, category)
{
    public IdentifiableId ActorId;

    protected sealed override void OnDeserialised(string mainPart) => ActorId = Helpers.ParseEnum<IdentifiableId>(mainPart);

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(langName, translations);

        PediaRegistry.RegisterIdentifiableMapping(PediaId, ActorId);
        translations.GetBundle("actor")["l." + ActorId.ToString().ToLowerInvariant()] = Names.GetText(langName);
    }
}

public sealed partial class SlimeLangData() : ActorLangData("SLIME", PediaCategory.SLIMES)
{
    [JsonProperty, JsonRequired] public Dictionary<string, string> Risks;
    [JsonProperty, JsonRequired] public Dictionary<string, string> Slimeologies;
    [JsonProperty, JsonRequired] public Dictionary<string, string> Diets;
    [JsonProperty, JsonRequired] public Dictionary<string, string> Favourites;
    [JsonProperty, JsonRequired] public Dictionary<string, string> Onomics;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Risks = reader.ReadDictionary(Helpers.ReadString2);
        Slimeologies = reader.ReadDictionary(Helpers.ReadString2);
        Diets = reader.ReadDictionary(Helpers.ReadString2);
        Favourites = reader.ReadDictionary(Helpers.ReadString2);
        Onomics = reader.ReadDictionary(Helpers.ReadString2);
        OnomicsType = reader.ReadString2();
    }

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

public abstract partial class ResourceLangData(string suffix) : ActorLangData(suffix, PediaCategory.RESOURCES)
{
    [JsonProperty, JsonRequired] public Dictionary<string, string> Ranch;
    [JsonProperty, JsonRequired] public Dictionary<string, string> Types;
    [JsonProperty, JsonRequired] public Dictionary<string, string> About;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Ranch = reader.ReadDictionary(Helpers.ReadString2);
        Types = reader.ReadDictionary(Helpers.ReadString2);
        About = reader.ReadDictionary(Helpers.ReadString2);
    }

    public override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(langName, translations);

        var bundle = translations.GetBundle("pedia");
        bundle["m.desc." + PediaKey] = About.GetText(langName);
        bundle["m.how_to_use." + PediaKey] = Ranch.GetText(langName);
        bundle["m.resource_type." + PediaKey] = Types.GetText(langName);
    }
}

// [Serializable]
// public sealed class CraftLangData() : ResourceLangData("CRAFT");

public abstract partial class FoodLangData(string suffix) : ResourceLangData(suffix)
{
    [JsonProperty, JsonRequired] public Dictionary<string, string> FavouredBy;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        FavouredBy = reader.ReadDictionary(Helpers.ReadString2);
    }

    public sealed override void AddTranslations(string langName, Dictionary<string, Dictionary<string, string>> translations)
    {
        base.AddTranslations(langName, translations);

        translations.GetBundle("pedia")["m.resource_type." + PediaKey] = FavouredBy.GetText(langName);
    }
}

[Serializable]
public sealed class HenLangData() : FoodLangData("HEN");

[Serializable]
public sealed class ChickLangData() : FoodLangData("CHICK");

[Serializable]
public sealed class FruitLangData() : FoodLangData("FRUIT");

[Serializable]
public sealed class VeggieLangData() : FoodLangData("VEGGIE");

// [Serializable]
// public sealed class EdibleCraftLangData() : FoodLangData("CRAFT");