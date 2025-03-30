namespace TheOceanRange.Managers;

// Manager class to handle the commonality of a bunch of slime handling code, like gordo stuff
public static class SlimeManager
{
    public static Dictionary<IdentifiableId, CustomSlimeData> SlimesMap { get; } = [];
    public static Dictionary<IdentifiableId, IdentifiableId> BaitToGordoMap { get; } = [];
}