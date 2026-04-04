namespace OceanRange.Managers;

[Manager(ManagerType.Contacts)]
public static class Contacts
{
    public static Dictionary<RancherName, RancherData> RancherMap;

    private static RancherData[] Ranchers;

#if DEBUG
    [TimeDiagnostic("Contacts Preload")]
#endif
    [PreloadMethod]
    public static void PreloadRancherData()
    {
        Ranchers = Inventory.GetJsonArray<RancherData>("contacts");

        RancherMap = Ranchers.ToDictionary(x => x.RancherName, RancherNameComparer.Instance);

        ExchangeOfferRegistry.RegisterCategory(Ids.OCEAN, [.. Slimepedia.Slimes.Where(x => x.Exchangeable).SelectMany(x => new[] { x.MainId, x.PlortId })]);

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
    }

#if DEBUG
    [TimeDiagnostic("Contacts PreOnSaveLoad")]
#endif
    private static void PreOnSaveLoad(SceneContext context)
    {
        var background = context.ExchangeDirector.ranchers[1].chatBackground;

        foreach (var rancher in Ranchers)
            rancher.Rancher.chatBackground = background;
    }

#if DEBUG
    [TimeDiagnostic("Contacts Load")]
#endif
    [LoadMethod]
    public static void LoadAllRanchers() => Array.ForEach(Ranchers, LoadRancher);

    private static void LoadRancher(RancherData rancher)
    {
        ExchangeOfferRegistry.RegisterRancher(rancher.Rancher);
        ExchangeOfferRegistry.RegisterRancherID(rancher.RancherId);
    }
}