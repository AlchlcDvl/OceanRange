using SRML.Config.Attributes;

namespace OceanRange;

[ConfigFile("OceanRance")]
public static class Config
{
    public static bool DUMP_TRANSLATIONS
#if DEBUG
        = true;
#else
        ;
#endif

    public static Language FALLBACK_LANGUAGE = Language.EN;
}