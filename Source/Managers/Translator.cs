namespace OceanRange.Managers;

public static class Translator
{
    public static Dictionary<string, string> SlimeToOnomicsMap;
    public static ExchangeLangData[] Ranchers;

    private static readonly Dictionary<Language, Dictionary<string, Dictionary<string, string>>> Translations = [];

    private static LangHolder LangHolder;

#if DEBUG
    [TimeDiagnostic("Pedia Preload")]
#endif
    public static void PreloadLangData()
    {
        LangHolder = Inventory.GetJson<LangHolder>("pedia");

        Ranchers = LangHolder.Ranchers;
        SlimeToOnomicsMap = LangHolder.Slimes.ToDictionary(x => x.PediaKey, x => x.OnomicsType);
    }

    public static string GetText(this Dictionary<string, string> dict, string lang) => dict.TryGetValue(lang, out var text) ? text : dict["EN"]; // English is guaranteed to exist here

    public static string[] GetTexts(this Dictionary<string, string[]> dict, string lang) => dict.TryGetValue(lang, out var texts) ? texts : dict["EN"]; // English is guaranteed to exist here

    public static Dictionary<string, Dictionary<string, string>> GetTranslations(Language lang)
    {
        if (!Translations.TryGetValue(lang, out var translations))
            Translations[lang] = translations = GenerateTranslations(lang.ToString());

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