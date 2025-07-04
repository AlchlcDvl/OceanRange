namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(ExchangeDirector), nameof(ExchangeDirector.Awake))]
public static class CreateExchanges
{
    public static void Prefix(ExchangeDirector __instance)
    {
        __instance.values =
        [
            .. __instance.values,
            .. SlimeManager.SlimesMap.SelectMany(x => new ExchangeDirector.ValueEntry[]
            {
                new()
                {
                    id = x.Key,
                    value = 18f
                },
                new()
                {
                    id = x.Value.PlortId,
                    value = 16f
                }
            }),
            .. FoodManager.FoodsMap.Select(x => new ExchangeDirector.ValueEntry()
            {
                id = x.Key,
                value = 20f
            })
        ];
    }
}