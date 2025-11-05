// ReSharper disable InconsistentNaming

using SRML.Config.Attributes;

namespace OceanRange;

[ConfigFile("OceanRange")]
public static class Config
{
    public static bool DUMP_TRANSLATIONS = false;

    public static Language FALLBACK_LANGUAGE = Language.EN;
}