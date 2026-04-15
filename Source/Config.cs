// ReSharper disable InconsistentNaming
// ReSharper disable ConvertToConstant.Global

using SRML.Config.Attributes;

namespace OceanRange;

[ConfigFile("OceanRange")]
public static class Config
{
    [ConfigComment("Allows the mod to dump its translation files so that custom translations can be loaded")]
    public static readonly bool DUMP_TRANSLATIONS = false;

    [ConfigComment("The fallback language of translations in the event a translation doesn't exist")]
    public static readonly Language FALLBACK_LANGUAGE = Language.EN;
}