#if UNITY
namespace OceanRange.Data;

public sealed partial class Translations
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolStrings(Additional.Keys);

        foreach (var dict in Additional.Values)
        {
            pooler.PoolStrings(dict.Keys);
            pooler.PoolStrings(dict.Values);
        }

        if (!AdditionalExotic.IsNullOrEmpty())
        {
            pooler.PoolStrings(AdditionalExotic.Keys);

            foreach (var dict in AdditionalExotic.Values)
            {
                pooler.PoolStrings(dict.Keys);
                pooler.PoolStrings(dict.Values);
            }
        }

        Array.ForEach(Slimes, x => x.FindStrings(pooler));
        Array.ForEach(Hens, x => x.FindStrings(pooler));
        Array.ForEach(Chicks, x => x.FindStrings(pooler));
        Array.ForEach(Fruits, x => x.FindStrings(pooler));
        Array.ForEach(Veggies, x => x.FindStrings(pooler));
        Array.ForEach(Ranchers, x => x.FindStrings(pooler));
        Array.ForEach(Plorts, x => x.FindStrings(pooler));
        Array.ForEach(Largos, x => x.FindStrings(pooler));
        Array.ForEach(Gordos, x => x.FindStrings(pooler));
        Array.ForEach(Mail, x => x.FindStrings(pooler));
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteStringToStringDictionary(Additional);

        writer.WriteArray(Slimes, (w, x) => x.WriteTo(w));
        writer.WriteArray(Hens, (w, x) => x.WriteTo(w));
        writer.WriteArray(Chicks, (w, x) => x.WriteTo(w));
        writer.WriteArray(Fruits, (w, x) => x.WriteTo(w));
        writer.WriteArray(Veggies, (w, x) => x.WriteTo(w));
        writer.WriteArray(Ranchers, (w, x) => x.WriteTo(w));
        writer.WriteArray(Plorts, (w, x) => x.WriteTo(w));
        writer.WriteArray(Largos, (w, x) => x.WriteTo(w));
        writer.WriteArray(Gordos, (w, x) => x.WriteTo(w));
        writer.WriteArray(Mail, (w, x) => x.WriteTo(w));

        writer.WriteNullableStringToStringDictionary(AdditionalExotic);
    }
}

public abstract partial class LangData
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(TranslatedName);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(TranslatedName);
    }
}

public sealed partial class MailLangData
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Subject);
        pooler.PoolString(Body);
        pooler.PoolString(MailKey);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Subject);
        writer.WriteString(Body);
        writer.WriteString(MailKey);
    }
}

public sealed partial class RancherLangData
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolStrings(Offers);
        pooler.PoolStrings(LoadingTexts);
        pooler.PoolString(SpecialOffer);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteStringArray(Offers);
        writer.WriteStringArray(LoadingTexts);
        writer.WriteString(SpecialOffer);
    }
}

public abstract partial class PediaLangData : LangData
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Intro);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Intro);
    }
}

public sealed partial class SlimeLangData : ActorLangData
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Risks);
        pooler.PoolString(Slimeology);
        pooler.PoolString(Diet);
        pooler.PoolString(Favourite);
        pooler.PoolString(Onomics);
        pooler.PoolString(Exotic);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Risks);
        writer.WriteString(Slimeology);
        writer.WriteString(Diet);
        writer.WriteString(Favourite);
        writer.WriteString(Onomics);
        writer.WriteString(Exotic);
        writer.WriteBool(SsExists);
    }
}

public abstract partial class ActorLangData : PediaLangData;

public abstract partial class ResourceLangData : ActorLangData
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Type);
        pooler.PoolString(Ranch);
        pooler.PoolString(About);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Type);
        writer.WriteString(Ranch);
        writer.WriteString(About);
    }
}

public sealed partial class CraftLangData : ResourceLangData;

public abstract partial class FoodLangData : ResourceLangData
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(FavouredBy);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(FavouredBy);
    }
}

public sealed partial class HenLangData : FoodLangData;

public sealed partial class ChickLangData : FoodLangData;

public sealed partial class FruitLangData : FoodLangData;

public sealed partial class VeggieLangData : FoodLangData;

public abstract partial class GadgetLangData : LangData
{
    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(CustomDescription);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(CustomDescription);
    }
}
#endif
