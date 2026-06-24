// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

[Serializable]
public sealed partial class MailData : JsonData
{
    [JsonRequired] public string Id;
}
