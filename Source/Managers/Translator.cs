namespace OceanRange.Managers;

public static class Translator
{
    public static Dictionary<string, string> SlimeToOnomicsMap;

    private static readonly Dictionary<Language, Dictionary<string, Dictionary<string, string>>> Translations = new(LanguageComparer.Instance);

    private static LangHolder LangHolder;

#if DEBUG
    [TimeDiagnostic("Pedia Preload")]
#endif
    public static void PreloadLangData()
    {
        LangHolder = Inventory.GetModData<LangHolder>("pedia");

        SlimeToOnomicsMap = LangHolder.Slimes.ToDictionary(x => x.PediaKey, x => x.OnomicsType);
    }

    public static string GetText(this Dictionary<string, string> dict, string lang) => dict.TryGetValue(lang, out var text) ? text : dict["EN"]; // English is guaranteed to exist here

    public static string[] GetTexts(this Dictionary<string, string[]> dict, string lang) => dict.TryGetValue(lang, out var texts) ? texts : dict["EN"]; // English is guaranteed to exist here

    public static Dictionary<string, Dictionary<string, string>> GetTranslations(this Language lang)
    {
        var langName = lang.ToString();

        if (!Translations.TryGetValue(lang, out var translations))
            Translations[lang] = translations = GenerateTranslations(langName);

        LangHolder.OnLanguageChanged(langName);
        return translations;
    }

    private static Dictionary<string, Dictionary<string, string>> GenerateTranslations(string langName)
    {
        var translations = new Dictionary<string, Dictionary<string, string>>();
        LangHolder.AddTranslations(langName, translations);
        return translations;
    }

    public static Dictionary<string, string> GetBundle(this Dictionary<string, Dictionary<string, string>> translations, string key)
    {
        if (!translations.TryGetValue(key, out var bundle))
            translations[key] = bundle = [];

        return bundle;
    }
}