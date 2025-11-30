// ReSharper disable InconsistentNaming

using SRML.Config.Attributes;

namespace OceanRange;

[ConfigFile("OceanRange")]
public static class Config
{
    [ConfigComment("Allows the mod to dump its translation files so that custom translations can be loaded")]
    public static bool DUMP_TRANSLATIONS = false;

    [ConfigComment("The fallback language of translations in the event a translation doesn't exist")]
    public static Language FALLBACK_LANGUAGE = Language.EN;
}