using Newtonsoft.Json;

namespace TheOceanRange.Modules;

public sealed class FoodPediaEntry
{
    [JsonProperty("title"), JsonRequired]
    public string Title;

    [JsonProperty("intro"), JsonRequired]
    public string Intro;

    [JsonProperty("type")]
    public string Type;

    [JsonProperty("favouredBy")]
    public string FavouredBy;

    [JsonProperty("about")]
    public string About;

    [JsonProperty("ranch")]
    public string Ranch;
}