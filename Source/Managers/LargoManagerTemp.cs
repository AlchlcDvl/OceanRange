namespace OceanRange.Managers;

public static class LargoManagerTemp
{
    public static readonly List<(IdentifiableId LargoId, IdentifiableId BaseSlime)> LargoMaps = [];

    public static void AddLargoEatMap(IdentifiableId largoId, IdentifiableId slimeId1, IdentifiableId slimeId2)
    {
        if (LargoMaps.Any(x => x.BaseSlime.IsAny(slimeId1, slimeId2)))
            return;

        LargoMaps.Add((largoId, slimeId1));
        LargoMaps.Add((largoId, slimeId2));
    }
}