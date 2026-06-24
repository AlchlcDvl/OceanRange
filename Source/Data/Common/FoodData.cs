// ReSharper disable UnassignedField.Global
// ReSharper disable FieldCanBeMadeReadOnly.Global
// ReSharper disable ConvertToConstant.Global

namespace OceanRange.Data;

[Serializable]
public sealed partial class Ingredients : JsonData
{
    [JsonRequired] public GroupData[] Groups;
    [JsonRequired] public FruitData[] Fruits;
    [JsonRequired] public VeggieData[] Veggies;
    [JsonRequired] public ChimkenData[] Chimkens;
}

[Serializable]
public sealed partial class GroupData : JsonData
{
    protected override bool SerialiseName => true;
}

public abstract partial class FoodData : SpawnedActorData
{
    protected override bool SerialiseName => true;
}

[Serializable]
public sealed partial class ChimkenData : FoodData
{
    public float SpawnAmount = 1f;
    public float ChickSpawnAmount = 1f;
}

public abstract partial class PlantData : FoodData
{
#if UNITY
    [SerializeField]
#endif
    public Dictionary<string, Orientation[]> SpawnLocations;

    public bool AdjustColliders = true;
}

[Serializable]
public sealed partial class VeggieData : PlantData;

[Serializable]
public sealed partial class FruitData : PlantData;
