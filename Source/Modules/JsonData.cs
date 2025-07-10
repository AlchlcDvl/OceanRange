using Newtonsoft.Json;

namespace TheOceanRange.Modules;

public abstract class JsonData
{
    [JsonProperty("name"), JsonRequired]
    public string Name;

    [JsonIgnore]
    public IdentifiableId MainId;

    [JsonIgnore]
    public ExchangeDirector.Category Category;

    [JsonIgnore]
    public PediaId MainEntry;
}