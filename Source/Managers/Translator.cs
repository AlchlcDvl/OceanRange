namespace OceanRange.Managers;

public static class Translator
{
    public static Dictionary<string, string> SlimeToOnomicsMap;

    public static readonly HashSet<string> OfferIds = [];

    public static readonly List<string> LoadingIds = [];
    public static readonly HashSet<int> LoadingIndices = [];

    private static readonly Dictionary<Language, Translations> TranslationsHolder = new(LanguageComparer.Instance);

    private static Translations Fallback;

#if DEBUG
    [TimeDiagnostic("Pedia Preload")]
#endif
    public static void PreloadLangData() => Fallback = GenerateTranslations(Inventory.GetJson<LangHolder>("pedia").Fallback);

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

        if (!Inventory.TryGetJson<Translations>(langName, out var translations))
            return Fallback ?? throw new Exception("Fallback was null");

        Inventory.ReleaseHandles(langName);
        return translations;
    }

    public static Dictionary<string, string> GetBundle(this Dictionary<string, Dictionary<string, string>> translations, string key)
    {
        if (!translations.TryGetValue(key, out var bundle))
            translations[key] = bundle = [];

        return bundle;
    }
}

// namespace OceanRange.Managers;

// public static class Translator
// {
//     public static Dictionary<string, string> SlimeToOnomicsMap;

//     public static readonly HashSet<string> OfferIds = [];

//     public static readonly List<string> LoadingIds = [];
//     public static readonly HashSet<int> LoadingIndices = [];

//     private static readonly Dictionary<Language, Dictionary<string, Dictionary<string, string>>> Translations = new(LanguageComparer.Instance);

//     private static string Fallback;

//     private static LangHolder LangHolder;
//     public static string CurrentLanguage;

// #if DEBUG
//     [TimeDiagnostic("Pedia Preload")]
// #endif
//     public static void PreloadLangData()
//     {
//         LangHolder = Inventory.GetJson<LangHolder>("pedia");

//         SlimeToOnomicsMap = LangHolder.Slimes.ToDictionary(x => x.PediaKey, x => x.OnomicsType);
//     }

//     public static string GetText(this Dictionary<string, string> dict, string lang) => dict.TryGetValue(lang, out var text) ? text : dict[Fallback]; // English is guaranteed to exist here

//     public static string[] GetTexts(this Dictionary<string, string[]> dict, string lang) => dict.TryGetValue(lang, out var texts) ? texts : dict[Fallback]; // English is guaranteed to exist here

//     public static Dictionary<string, Dictionary<string, string>> GetTranslations(this Language lang)
//     {
//         var langName = lang.ToString();

//         if (!Translations.TryGetValue(lang, out var translations))
//             Translations[lang] = translations = GenerateTranslations(langName);

//         LangHolder.OnLanguageChanged(langName);
//         CurrentLanguage = langName;
//         return translations;
//     }

//     private static Dictionary<string, Dictionary<string, string>> GenerateTranslations(string langName)
//     {
//         var translations = new Dictionary<string, Dictionary<string, string>>();
//         LangHolder.AddTranslations(langName, translations);
//         return translations;
//     }

//     public static Dictionary<string, string> GetBundle(this Dictionary<string, Dictionary<string, string>> translations, string key)
//     {
//         if (!translations.TryGetValue(key, out var bundle))
//             translations[key] = bundle = [];

//         return bundle;
//     }
// }