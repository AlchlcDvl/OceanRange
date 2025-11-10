namespace OceanRange.Managers;

public static class Translator
{
    public static readonly Dictionary<string, string> SlimeToOnomicsMap = [];

    public static readonly List<string> LoadingIds = [];

    private static readonly Dictionary<Language, Translations> TranslationsHolder = new(LanguageComparer.Instance);

    private static Translations Fallback;
    private static Dictionary<string, Dictionary<string, string>> FallbackTranslations;

#if DEBUG
    [TimeDiagnostic("Pedia Preload")]
#endif
    public static void PreloadLangData()
    {
        Fallback = TranslationsHolder.GetOrAdd(Config.FALLBACK_LANGUAGE, GenerateTranslations);
        FallbackTranslations = Fallback.GetTranslations();
    }

    public static Dictionary<string, Dictionary<string, string>> GetTranslations(this Language lang)
    {
        var holder = TranslationsHolder.GetOrAdd(lang, GenerateTranslations);
        holder.OnLanguageChanged();
        return holder.GetTranslations();
    }

    private static Translations GenerateTranslations(Language lang)
    {
        var langName = lang.ToString();

        if (Inventory.TryGetJson<Translations>(langName.ToLowerInvariant(), Config.DUMP_TRANSLATIONS, out var translations))
        {
            Inventory.TryReleaseHandles(langName);
            return translations;
        }

        if (lang == Config.FALLBACK_LANGUAGE)
            throw new($"Fallback {Config.FALLBACK_LANGUAGE} was null");

        return Fallback ?? GenerateTranslations(Config.FALLBACK_LANGUAGE);
    }

    public static Dictionary<string, string> GetBundle(this Dictionary<string, Dictionary<string, string>> translations, string key)
    {
        if (!translations.TryGetValue(key, out var bundle))
            translations[key] = bundle = [];

        return bundle;
    }

    public static void AddTranslation(this Dictionary<string, string> bundle, string id, string text, string bundleName) => bundle[id] = text ?? FallbackTranslations[bundleName][id];
}