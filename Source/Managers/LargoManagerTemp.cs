namespace OceanRange.Managers;

public static class LargoManagerTemp
{
    public static readonly List<LargoObject> LargoMaps = [];

    public static void AddLargoEatMap(IdentifiableId largoId, IdentifiableId slimeId1, IdentifiableId slimeId2) => LargoMaps.Add(new(largoId, slimeId1, slimeId2));

    public readonly struct LargoObject(IdentifiableId largoId, IdentifiableId slimeId1, IdentifiableId slimeId2)
    {
        public readonly IdentifiableId LargoId = largoId;
        public readonly IdentifiableId SlimeId1 = slimeId1;
        public readonly IdentifiableId SlimeId2 = slimeId2;
    }
}