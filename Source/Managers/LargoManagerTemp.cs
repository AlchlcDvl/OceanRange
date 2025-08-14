namespace OceanRange.Managers;

public static class LargoManagerTemp
{
    public static readonly Dictionary<IdentifiableId, List<(IdentifiableId, IdentifiableId)>> LargoMaps = [];

    public static void AddLargoEatMap(IdentifiableId largoId, IdentifiableId slimeId1, IdentifiableId slimeId2)
    {
        if (!LargoMaps.TryGetValue(slimeId1, out var slime1Values))
            slime1Values = LargoMaps[slimeId1] = [];

        if (!LargoMaps.TryGetValue(slimeId2, out var slime2Values))
            slime2Values = LargoMaps[slimeId2] = [];

        slime1Values.Add((largoId, slimeId2));
        slime2Values.Add((largoId, slimeId1));
    }
}