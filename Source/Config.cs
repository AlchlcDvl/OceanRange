// ReSharper disable InconsistentNaming
// ReSharper disable ConvertToConstant.Global

using SRML.Config.Attributes;

namespace OceanRange;

[ConfigFile("OceanRange")]
public static class Config
{
    [ConfigComment("The fallback language of translations in the event a translation doesn't exist")]
    public static readonly Language FALLBACK_LANGUAGE = Language.EN;
}