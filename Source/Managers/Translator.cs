namespace OceanRange.Managers;

public static class Translator
{
    public static Dictionary<string, string> SlimeToOnomicsMap;

    public static readonly HashSet<string> OfferIds = [];

    public static readonly List<string> LoadingIds = [];
    public static readonly HashSet<int> LoadingIndices = [];

    private static readonly Dictionary<Language, Translations> TranslationsHolder = new(LanguageComparer.Instance);

    private static Translations Fallback;

    public static Dictionary<string, Dictionary<string, string>> GetTranslations(this Language lang)
    {
        if (!TranslationsHolder.TryGetValue(lang, out var holder))
            TranslationsHolder[lang] = holder = GenerateTranslations(lang);

        holder.OnLanguageChanged();
        SlimeToOnomicsMap = holder.SlimeToOnomicsMap;
        return holder.GetTranslations();
    }

    private static Translations GenerateTranslations(Language lang)
    {
        var langName = lang.ToString();

        if (Inventory.TryGetJson<Translations>(langName, out var translations, Config.DUMP_TRANSLATIONS))
        {
            Inventory.TryReleaseHandles(langName);
            return translations;
        }

        if (lang == Config.FALLBACK_LANGUAGE)
            throw new("Fallback was null");

        return Fallback ?? GenerateTranslations(Config.FALLBACK_LANGUAGE) ?? throw new("Fallback was null");
    }

    public static Dictionary<string, string> GetBundle(this Dictionary<string, Dictionary<string, string>> translations, string key)
    {
        if (!translations.TryGetValue(key, out var bundle))
            translations[key] = bundle = [];

        return bundle;
    }
}