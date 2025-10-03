using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Holder/Lang Holder")]
public sealed class LangHolder : JsonData
{
    public Dictionary<string, Dictionary<string, Dictionary<string, string>>> Additional;
    public SlimeLangData[] Slimes;
    public HenLangData[] Hens;
    public ChickLangData[] Chicks;
    public FruitLangData[] Fruits;
    public VeggieLangData[] Veggies;
    // public CraftLangData[] Crafts;
    // public EdibleCraftLangData[] EdibleCrafts;
    public RancherLangData[] Ranchers;
    public PlortLangData[] Plorts;
    public LargoLangData[] Largos;
    public GordoLangData[] Gordos;
    public ZoneLangData[] Zones;
    public MailLangData[] Mail;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

public abstract class LangData : JsonData
{
    public Dictionary<string, string> Names;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Mail")]
public sealed class MailLangData : LangData
{
    public Dictionary<string, string> Subjects;
    public Dictionary<string, string> Bodies;
    public string MailKey;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Rancher")]
public sealed class RancherLangData : LangData
{
    public Dictionary<string, string[]> Offers;
    public Dictionary<string, string> SpecialOffers;
    public Dictionary<string, string[]> LoadingTexts;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Plort")]
public sealed class PlortLangData : LangData { }

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Largo")]
public sealed class LargoLangData : LangData { }

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Gordo")]
public sealed class GordoLangData : LangData { }

public abstract class PediaLangData : LangData
{
    public Dictionary<string, string> Intros;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Zone")]
public sealed class ZoneLangData : PediaLangData
{
    public Dictionary<string, string> Descriptions;
    public Dictionary<string, string> Presences;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Slime")]
public sealed class SlimeLangData : PediaLangData
{
    public Dictionary<string, string> Risks;
    public Dictionary<string, string> Slimeologies;
    public Dictionary<string, string> Diets;
    public Dictionary<string, string> Favourites;
    public Dictionary<string, string> Onomics;
    public string OnomicsType = "pearls";

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

public abstract class ResourceLangData : PediaLangData
{
    public Dictionary<string, string> Ranch;
    public Dictionary<string, string> Types;
    public Dictionary<string, string> About;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

// [CreateAssetMenu(menuName = "OceanRange/Data/Lang/Craft")]
// public sealed class CraftLangData : ResourceLangData { }

public abstract class FoodLangData : ResourceLangData
{
    public Dictionary<string, string> FavouredBy;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Hen")]
public sealed class HenLangData : FoodLangData { }

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Chick")]
public sealed class ChickLangData : FoodLangData { }

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Fruit")]
public sealed class FruitLangData : FoodLangData { }

[CreateAssetMenu(menuName = "OceanRange/Data/Lang/Veggie")]
public sealed class VeggieLangData : FoodLangData { }

// [CreateAssetMenu(menuName = "OceanRange/Data/Lang/Edible Craft")]
// public sealed class EdibleCraftLangData : FoodLangData { }