using Newtonsoft.Json;

namespace TheOceanRange.Modules;

public sealed class PediaJsonEntry
{
    [JsonProperty("id")]
    public string ID { get; set; }

    [JsonProperty("title")]
    public string Title { get; set; }

    [JsonProperty("intro")]
    public string Intro { get; set; }

    [JsonProperty("diet")]
    public string Diet { get; set; }

    [JsonProperty("fav")]
    public string Fav { get; set; }

    [JsonProperty("slimeology")]
    public string Slimeology { get; set; }

    [JsonProperty("risks")]
    public string Risks { get; set; }

    [JsonProperty("plortonomics")]
    public string Plortonomics { get; set; }
}