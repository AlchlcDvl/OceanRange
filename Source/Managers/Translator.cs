using System.Globalization;
using System.Text.RegularExpressions;
using DLCPackage;

namespace OceanRange.Managers;

[Manager(ManagerType.Translator)]
public static class Translator
{
    public static readonly Dictionary<string, string> SlimeToOnomicsMap = [];
    public static readonly Dictionary<Language, List<string>> LoadingIds = new(LanguageComparer.Instance);

    private static readonly Dictionary<string, Dictionary<string, string>> FallbackTranslations = [];
    private static readonly Dictionary<Language, Translations> TranslationsHolder = new(LanguageComparer.Instance);
    private static readonly Dictionary<Language, Dictionary<string, Dictionary<string, string>>> VanillaFallbackTranslations = new(LanguageComparer.Instance);

    private static readonly string[] Bundles = ["achieve", "actor", "build", "exchange", "global", "keys", "mail", "pedia", "range", "tutorial", "ui"];

    private static Translations Fallback;
    private static bool FallbackHandled;
    private static bool ExoticsLoaded;

    private static readonly Func<Language, Translations> GenerateTranslationsFunc = GenerateTranslations;

#if DEBUG
    [TimeDiagnostic("Pedia Preload")]
#endif
    [PreloadMethod]
    public static void PreloadLangData() => Fallback = TranslationsHolder.GetOrAdd(Config.FALLBACK_LANGUAGE, GenerateTranslationsFunc);

#if DEBUG
    [TimeDiagnostic("Pedia Load")]
#endif
    [LoadMethod]
    public static void LoadLangData() => GameContext.Instance.DLCDirector.onPackageInstalled += HandleDefaultExotics;

    public static void MessageDirectorHook(MessageDirector __instance)
    {
        if (FallbackHandled)
            return;

        StoreVanillaTranslations(__instance, Config.FALLBACK_LANGUAGE);

        foreach (var (key, texts) in Fallback.GetTranslations(Config.FALLBACK_LANGUAGE))
            FallbackTranslations[key] = texts;

        Fallback.WhenFallback();

        FallbackHandled = true;
    }

    private static void HandleDefaultExotics(Id id)
    {
        if (id != Id.SECRET_STYLE || ExoticsLoaded)
            return;

        Fallback.AddExoticTranslations(Config.FALLBACK_LANGUAGE);
        ExoticsLoaded = true;
    }

    private static void StoreVanillaTranslations(MessageDirector __instance, Language lang)
    {
        if (VanillaFallbackTranslations.ContainsKey(lang))
            return;

        var translations = VanillaFallbackTranslations[lang] = [];
        var info = MessageDirector.GetCultureInfo(lang);

        foreach (var bundle in Bundles)
            translations[bundle] = GetBundle(__instance.msgPath, bundle, info, __instance.fallbackLang).dict;
    }

    public static Dictionary<string, Dictionary<string, string>> GetTranslations(this Language lang)
    {
        var holder = TranslationsHolder.GetOrAdd(lang, GenerateTranslationsFunc);
        holder.OnLanguageChanged(lang);
        StoreVanillaTranslations(GameContext.Instance.MessageDirector, lang);
        var translations = holder.GetTranslations(lang);

        if (ExoticsLoaded)
            holder.AddExoticTranslations(lang);

        return translations;
    }

    private static Translations GenerateTranslations(Language lang)
    {
        var langName = lang.ToString().ToLowerInvariant();

        if (Inventory.TryGetJson<Translations>(langName, Config.DUMP_TRANSLATIONS, out var translations))
        {
            Inventory.TryReleaseHandles(langName);
            return translations;
        }

        if (lang == Config.FALLBACK_LANGUAGE)
            throw new ArgumentException($"Fallback {langName} was null");

        return Fallback ?? GenerateTranslations(Config.FALLBACK_LANGUAGE);
    }

    public static Dictionary<string, string> GetBundle(this Dictionary<string, Dictionary<string, string>> translations, string key)
    {
        if (!translations.TryGetValue(key, out var bundle))
            translations[key] = bundle = [];

        return bundle;
    }

    public readonly struct DeferredTranslation(Dictionary<string, string> bundle, string id, string text, string bundleName)
    {
        public void AddComplexTranslation(Dictionary<string, Dictionary<string, string>> translations, Language lang, bool isFallback) =>
            bundle[id] = GetTranslationValue(id, text, bundleName, translations, lang, isFallback) ?? $"STRMSS: {id}";
    }

    private static List<DeferredTranslation> CurrentDeferredList;

    public static void BeginGatherPhase() => CurrentDeferredList = [];

    public static List<DeferredTranslation> EndGatherPhase()
    {
        var list = CurrentDeferredList;
        CurrentDeferredList = null;
        return list;
    }

    extension(Dictionary<string, string> bundle)
    {
        public void AddTranslation(string id, string text, string bundleName)
        {
            if (text == null)
                throw new ArgumentNullException(nameof(text), $"Translation for {bundleName}:{id} was null!");

            if (text.StartsWith('@'))
                bundle.AddComplexTranslation(id, text, bundleName);
            else
                bundle.AddSimpleTranslation(id, text);
        }

        private void AddSimpleTranslation(string id, string text) => bundle[id] = text.IsNullOrWhiteSpace() ? $"STRMSS: {id}" : text;

        private void AddComplexTranslation(string id, string text, string bundleName) => CurrentDeferredList.Add(new(bundle, id, text, bundleName));
    }

    private static string GetTranslationValue(string id, string text, string bundleName, Dictionary<string, Dictionary<string, string>> translations, Language lang, bool isFallback)
    {
        var resolvedText = ResolveReference(text, bundleName, translations) ?? ResolveReference(text, bundleName, VanillaFallbackTranslations[lang]);

        if (resolvedText != null)
            return resolvedText;

        if (isFallback)
        {
            Main.Console.LogError($"{bundleName}:{id} was null!");
            return null;
        }

        if (FallbackTranslations.TryGetValue(bundleName, out var innerBundle) && innerBundle.TryGetValue(id, out var innerValueToAssign))
        {
            resolvedText = ResolveReference(innerValueToAssign, bundleName, FallbackTranslations);

            if (resolvedText != null)
                return resolvedText;
        }

        var fallback = VanillaFallbackTranslations[Config.FALLBACK_LANGUAGE];

        if (fallback.TryGetValue(bundleName, out var vanillaFallbackBundle) && vanillaFallbackBundle.TryGetValue(id, out var vanillaFallbackValue))
        {
            resolvedText = ResolveReference(vanillaFallbackValue, bundleName, fallback);

            if (resolvedText != null)
                return resolvedText;
        }

        Main.Console.LogError($"Couldn't find {bundleName}:{id} in fallback!");
        return null;
    }

    private static string ResolveReference(string referenceText, string currentBundleName, Dictionary<string, Dictionary<string, string>> translations)
    {
        var refKey = referenceText.Substring(1);
        var refBundleName = currentBundleName;
        var refId = refKey;
        var colonIndex = refKey.IndexOf(':');

        if (colonIndex > 0 && colonIndex < refKey.Length - 1)
        {
            refBundleName = refKey.Substring(0, colonIndex);
            refId = refKey.Substring(colonIndex + 1);
        }

        if (translations.TryGetValue(refBundleName, out var referencedBundle) && referencedBundle.TryGetValue(refId, out var resolvedText))
            return resolvedText?.StartsWith('@') == true ? ResolveReference(resolvedText, refBundleName, translations) : resolvedText;

        return null;
    }

    // The next set of methods are ripped straight from the game itself, because the original is patched

    private static ResourceBundle GetBundle(string prefix, string path, CultureInfo culture, string defaultLang)
    {
        var culturePath = prefix + "/" + culture.Name + "/" + path;
        var langPath = prefix + "/" + culture.TwoLetterISOLanguageName + "/" + path;
        var defaultPath = prefix + "/" + defaultLang + "/" + path;
        return new(LoadFromResources(culturePath, langPath, defaultPath));
    }

    private static Dictionary<string, string> LoadFromResources(string culturePath, string langPath, string defaultPath)
    {
        var textAsset = Resources.Load<TextAsset>(culturePath) ?? Resources.Load<TextAsset>(langPath) ?? Resources.Load<TextAsset>(defaultPath);

        if (!textAsset)
        {
            Log.Warning("Failed to read file.", "culturePath", culturePath, "langPath", langPath, "defaultPath", defaultPath);
            return [];
        }

        return LoadFromText(textAsset.name, textAsset.text);
    }

    private static Dictionary<string, string> LoadFromText(string path, string text)
    {
        var list = Regex.Replace(text, @"\\(\r\n|\n|\r)[ \t]*", string.Empty).TrueSplit('\n');
        var dictionary = new Dictionary<string, string>(list.Count);

        foreach (var item2 in list)
        {
            if (item2.Length <= 1 || item2.StartsWith('#'))
                continue;

            var array2 = Regex.Split(item2, @"(?<!(?<!\\)*\\)\=");

            if (array2.Length != 2)
                Log.Warning("Illegal resource bundle line", "path", path, "line", item2);
            else
                dictionary[ResourceBundle.Unescape(array2[0]).Trim()] = ResourceBundle.Unescape(array2[1]).Trim();
        }

        return dictionary;
    }
}