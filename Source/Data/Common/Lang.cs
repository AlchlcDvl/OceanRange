namespace OceanRange.Data;

[Serializable, CreateAssetMenu(menuName = "OceanRange/Translations")]
public sealed partial class LangHolder : Holder
{
    [JsonProperty, JsonRequired] public RancherLangData[] Ranchers;
    [JsonProperty, JsonRequired] public SlimeLangData[] Slimes;
    [JsonProperty, JsonRequired] public ZoneLangData[] Zones;
    [JsonProperty, JsonRequired] public MailLangData[] Mail;

    [JsonProperty] public string Fallback = "EN";
}

[Serializable]
public partial class LangData : ModData;

[Serializable]
public sealed partial class MailLangData
{
    [JsonProperty, JsonRequired] public string MailKey;
}

[Serializable]
public sealed partial class RancherLangData : LangData;

[Serializable]
public abstract partial class PediaLangData : LangData;

[Serializable]
public sealed partial class ZoneLangData : PediaLangData;

[Serializable]
public sealed partial class SlimeLangData
{
    [JsonProperty] public string OnomicsType = "pearls";
}

[Serializable]
public partial class ResourceLangData;

[Serializable]
public partial class FoodLangData : ResourceLangData;