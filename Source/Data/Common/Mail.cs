namespace OceanRange.Data;

[Serializable, CreateAssetMenu(menuName = "OceanRange/Mail")]
public sealed class Starmail : ValueArrayHolder<MailData>;

[Serializable]
public sealed partial class MailData : ModData
{
    [JsonProperty, JsonRequired] public string Id;
}