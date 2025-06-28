using Newtonsoft.Json;

namespace TheOceanRange.Modules;

public abstract class PediaEntry
{
    [JsonProperty("title"), JsonRequired]
    public string Title { get; set; }

    [JsonProperty("intro"), JsonRequired]
    public string Intro { get; set; }
}

public sealed class SlimePediaEntry : PediaEntry
{
    [JsonProperty("diet"), JsonRequired]
    public string Diet { get; set; }

    [JsonProperty("fav"), JsonRequired]
    public string Fav { get; set; }

    [JsonProperty("slimeology"), JsonRequired]
    public string Slimeology { get; set; }

    [JsonProperty("risks"), JsonRequired]
    public string Risks { get; set; }

    [JsonProperty("plortonomics"), JsonRequired]
    public string Plortonomics { get; set; }
}

public sealed class FoodPediaEntry : PediaEntry
{
    [JsonProperty("type")]
    public string Type { get; set; }

    [JsonProperty("favouredBy")]
    public string FavouredBy { get; set; }

    [JsonProperty("about")]
    public string About { get; set; }

    [JsonProperty("ranch")]
    public string Ranch { get; set; }
}