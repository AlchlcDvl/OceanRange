namespace OceanRange.Unity.Json;

[Serializable]
public sealed class LangHolder : JsonData
{
    [JsonProperty("additional"), JsonRequired]
    public List<SerializableStringStringPairListPairListPair> Additional;

    [JsonProperty("slimes"), JsonRequired]
    public SlimeLangData[] Slimes;

    [JsonProperty("hens"), JsonRequired]
    public FoodLangData[] Hens;

    [JsonProperty("chicks"), JsonRequired]
    public FoodLangData[] Chicks;

    [JsonProperty("fruits"), JsonRequired]
    public FoodLangData[] Fruits;

    [JsonProperty("veggies"), JsonRequired]
    public FoodLangData[] Veggies;

    // [JsonProperty("crafts"), JsonRequired]
    // public ResourceLangData[] Crafts;

    // [JsonProperty("edibleCrafts"), JsonRequired]
    // public FoodLangData[] EdibleCrafts;

    [JsonProperty("ranchers"), JsonRequired]
    public RancherLangData[] Ranchers;

    [JsonProperty("plorts"), JsonRequired]
    public LangData[] Plorts;

    [JsonProperty("largos"), JsonRequired]
    public LangData[] Largos;

    [JsonProperty("gordos"), JsonRequired]
    public LangData[] Gordos;

    [JsonProperty("zones"), JsonRequired]
    public ZoneLangData[] Zones;

    [JsonProperty("mail"), JsonRequired]
    public MailLangData[] Mail;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteArray(Slimes, Helpers.WriteJsonData);
        writer.WriteArray(Hens, Helpers.WriteJsonData);
        writer.WriteArray(Chicks, Helpers.WriteJsonData);
        writer.WriteArray(Fruits, Helpers.WriteJsonData);
        writer.WriteArray(Veggies, Helpers.WriteJsonData);
        // writer.WriteArray(Crafts, Helpers.WriteJsonData);
        // writer.WriteArray(EdibleCrafts, Helpers.WriteJsonData);
        writer.WriteArray(Ranchers, Helpers.WriteJsonData);
        writer.WriteArray(Plorts, Helpers.WriteJsonData);
        writer.WriteArray(Largos, Helpers.WriteJsonData);
        writer.WriteArray(Gordos, Helpers.WriteJsonData);
        writer.WriteArray(Zones, Helpers.WriteJsonData);
        writer.WriteArray(Mail, Helpers.WriteJsonData);

        // Oh god
        writer.WriteDictionary(Additional,
            Helpers.WriteString,
            (writer, x) => writer.WriteDictionary(x,
                Helpers.WriteString,
                (writer2, y) => writer.WriteDictionary(y,
                    Helpers.WriteString, Helpers.WriteString)));
    }
}

[Serializable]
public class LangData : JsonData
{
    [JsonProperty("names"), JsonRequired]
    public List<SerializableStringStringPair> Names;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(Names, Helpers.WriteString, Helpers.WriteString);
    }
}

[Serializable]
public sealed class MailLangData : LangData
{
    [JsonProperty("subjects"), JsonRequired]
    public List<SerializableStringStringPair> Subjects;

    [JsonProperty("bodies"), JsonRequired]
    public List<SerializableStringStringPair> Bodies;

    [JsonProperty("mailKey"), JsonRequired]
    public string MailKey;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteString(MailKey);
        writer.WriteDictionary(Subjects, Helpers.WriteString, Helpers.WriteString);
        writer.WriteDictionary(Bodies, Helpers.WriteString, Helpers.WriteString);
    }
}

[Serializable]
public sealed class RancherLangData : LangData
{
    [JsonProperty("offers"), JsonRequired]
    public List<SerializableStringStringArrayPair> Offers;

    [JsonProperty("specOffers"), JsonRequired]
    public List<SerializableStringStringPair> SpecialOffers;

    [JsonProperty("loading"), JsonRequired]
    public List<SerializableStringStringArrayPair> LoadingTexts;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(SpecialOffers, Helpers.WriteString, Helpers.WriteString);
        writer.WriteDictionary(Offers, Helpers.WriteString, (writer, x) => writer.WriteArray(x, Helpers.WriteString));
        writer.WriteDictionary(LoadingTexts, Helpers.WriteString, (writer, x) => writer.WriteArray(x, Helpers.WriteString));
    }
}

// Other pairs of (string, string) are Lang -> Translation

[Serializable]
public abstract class PediaLangData : LangData
{
    [JsonProperty("intros")]
    public List<SerializableStringStringPair> Intros;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(Intros, Helpers.WriteString, Helpers.WriteString);
    }
}

[Serializable]
public sealed class ZoneLangData : PediaLangData
{
    [JsonProperty("descriptions"), JsonRequired]
    public List<SerializableStringStringPair> Descriptions;

    [JsonProperty("presences"), JsonRequired]
    public List<SerializableStringStringPair> Presences;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(Descriptions, Helpers.WriteString, Helpers.WriteString);
        writer.WriteDictionary(Presences, Helpers.WriteString, Helpers.WriteString);
    }
}

[Serializable]
public sealed class SlimeLangData : PediaLangData
{
    [JsonProperty("risks"), JsonRequired]
    public List<SerializableStringStringPair> Risks;

    [JsonProperty("slimeologies"), JsonRequired]
    public List<SerializableStringStringPair> Slimeologies;

    [JsonProperty("diets"), JsonRequired]
    public List<SerializableStringStringPair> Diets;

    [JsonProperty("favs"), JsonRequired]
    public List<SerializableStringStringPair> Favourites;

    [JsonProperty("onomics"), JsonRequired]
    public List<SerializableStringStringPair> Onomics;

    [JsonProperty("onomicsType")]
    public string OnomicsType = "pearls";

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(Risks, Helpers.WriteString, Helpers.WriteString);
        writer.WriteDictionary(Slimeologies, Helpers.WriteString, Helpers.WriteString);
        writer.WriteDictionary(Diets, Helpers.WriteString, Helpers.WriteString);
        writer.WriteDictionary(Favourites, Helpers.WriteString, Helpers.WriteString);
        writer.WriteDictionary(Onomics, Helpers.WriteString, Helpers.WriteString);
        writer.WriteString(OnomicsType);
    }
}

[Serializable]
public class ResourceLangData : PediaLangData
{
    [JsonProperty("ranch"), JsonRequired]
    public List<SerializableStringStringPair> Ranch;

    [JsonProperty("types"), JsonRequired]
    public List<SerializableStringStringPair> Types;

    [JsonProperty("about"), JsonRequired]
    public List<SerializableStringStringPair> About;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(Ranch, Helpers.WriteString, Helpers.WriteString);
        writer.WriteDictionary(Types, Helpers.WriteString, Helpers.WriteString);
        writer.WriteDictionary(About, Helpers.WriteString, Helpers.WriteString);
    }
}

[Serializable]
public sealed class FoodLangData : ResourceLangData
{
    [JsonProperty("favouredBy"), JsonRequired]
    public List<SerializableStringStringPair> FavouredBy;

    public override void SerialiseTo(BinaryWriter writer)
    {
        base.SerialiseTo(writer);
        writer.WriteDictionary(FavouredBy, Helpers.WriteString, Helpers.WriteString);
    }
}