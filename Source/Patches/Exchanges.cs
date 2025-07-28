using static ExchangeDirector;

namespace OceanRange.Patches;

[HarmonyPatch(typeof(ExchangeDirector), nameof(ExchangeDirector.Awake))]
public static class CreateExchanges
{
    public static void Prefix(ExchangeDirector __instance)
    {
        var list = new List<ValueEntry>(__instance.values.Length + FoodManager.Chimkens.Length + FoodManager.Plants.Length + (SlimeManager.Slimes.Length * 2));
        list.AddRange(__instance.values);

        foreach (var chimkenData in FoodManager.Chimkens)
            list.Add(CreateEntry(chimkenData));

        foreach (var plantData in FoodManager.Plants)
            list.Add(CreateEntry(plantData));

        foreach (var slimeData in SlimeManager.Slimes)
        {
            list.Add(CreateEntry(slimeData));
            list.Add(new()
            {
                id = slimeData.PlortId,
                value = slimeData.PlortExchangeWeight
            });
        }

        __instance.values = [.. list];
    }

    private static ValueEntry CreateEntry(JsonData data) => new()
    {
        id = data.MainId,
        value = data.ExchangeWeight
    };
}