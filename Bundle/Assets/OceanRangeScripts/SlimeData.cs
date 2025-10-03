using UnityEngine;
using System.IO;
using System;
using UnityEngine;
using OceanRange.Unity;

[CreateAssetMenu(menuName = "OceanRange/Holder/Slimepedia")]
public sealed class Slimepedia : JsonData
{
    public SlimeData[] Slimes;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}

[CreateAssetMenu(menuName = "OceanRange/Data/Slime")]
public sealed class SlimeData : SpawnedActorData
{
    public string FavFood;
    public string FavToy;
    public bool NightSpawn;
    public string Diet;
    public string BaseSlime = "PINK_SLIME";
    public string BasePlort = "PINK_PLORT";
    public string BaseGordo = "PINK_GORDO";
    public OptionalInt TopMouthColor;
    public OptionalInt MiddleMouthColor;
    public OptionalInt BottomMouthColor;
    public OptionalInt RedEyeColor;
    public OptionalInt GreenEyeColor;
    public OptionalInt BlueEyeColor;
    public OptionalInt TopPaletteColor;
    public OptionalInt MiddlePaletteColor;
    public OptionalInt BottomPaletteColor;
    public OptionalInt PlortAmmoColor;
    public string PlortType = "Pearl";
    public bool CanBeRefined;
    public string[] Zones;
    public string GordoZone;
    public float SpawnAmount = 0.25f;
    public bool HasGordo = true;
    public string[] GordoRewards;
    public Orientation GordoOrientation;
    public string GordoCell;
    public bool NaturalGordoSpawn = true;
    public int PlortExchangeWeight = 16;
    public float JiggleAmount = 1f;
    public ModelData[] SlimeFeatures;
    public ModelData[] GordoFeatures;
    public ModelData[] PlortFeatures;
    public string[] ComponentsToAdd;
    public string[] ComponentsToRemove;
    public string[] ExcludedSpawners;
    public bool Vaccable = true;
    public int GordoEatAmount = 25;
    public string ComponentBase;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}