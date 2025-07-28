using static ExchangeDirector;

namespace OceanRange.Patches;

[HarmonyPatch(typeof(ExchangeDirector), nameof(ExchangeDirector.Awake))]
public static class CreateExchanges
{
    public static void Prefix(ExchangeDirector __instance) => __instance.values =
    [
        .. __instance.values,
        .. SlimeManager.Slimes.SelectMany(x => new ValueEntry[]
        {
            new()
            {
                id = x.MainId,
                value = x.ExchangeWeight
            },
            new()
            {
                id = x.PlortId,
                value = x.PlortExchangeWeight
            }
        }),
        .. FoodManager.Chimkens.Select(x => new ValueEntry
        {
            id = x.MainId,
            value = x.ExchangeWeight
        }),
        .. FoodManager.Plants.Select(x => new ValueEntry
        {
            id = x.MainId,
            value = x.ExchangeWeight
        })
    ];
}