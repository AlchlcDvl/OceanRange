using System.Collections.Generic;
using System.IO;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Holder/Translations")]
public sealed class LangHolder : JsonData
{
    public Dictionary<string, Dictionary<string, Dictionary<string, string>>> Additional;
    public SlimeLangData[] Slimes;
    public FoodLangData[] Hens;
    public FoodLangData[] Chicks;
    public FoodLangData[] Fruits;
    public FoodLangData[] Veggies;
    // public ResourceLangData[] Crafts;
    // public FoodLangData[] EdibleCrafts;
    public RancherLangData[] Ranchers;
    public LangData[] Plorts;
    public LangData[] Largos;
    public LangData[] Gordos;
    public ZoneLangData[] Zones;
    public MailLangData[] Mail;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}