namespace OceanRange.Managers;

public static class Contacts
{
#if DEBUG
    [TimeDiagnostic("Contacts Preload")]
#endif
    public static void PreloadRancherData()
    {
        ExchangeOfferRegistry.RegisterCategory(Ids.OCEAN, [.. SlimeManager.Slimes.Select(x => x.MainId), .. FoodManager.Chimkens.Select(x => x.MainId), .. FoodManager.Plants.Select(x => x.MainId)]);
    }
}