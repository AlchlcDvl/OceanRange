using static ExchangeDirector;

namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(ExchangeDirector), nameof(ExchangeDirector.Awake))]
public static class CreateExchanges
{
    public static void Prefix(ExchangeDirector __instance)
    {
        __instance.values =
        [
            .. __instance.values,
            .. SlimeManager.Slimes.SelectMany(x => new ValueEntry[]
            {
                new()
                {
                    id = x.MainId,
                    value = 18f
                },
                new()
                {
                    id = x.PlortId,
                    value = 16f
                }
            }),
            .. FoodManager.Foods.Select(x => new ValueEntry
            {
                id = x.MainId,
                value = 20f
            })
        ];

        var catDict = __instance.GetPrivateField<Dictionary<Category, IdentifiableId[]>>("catDict");
        new Category[] { Category.VEGGIES, Category.FRUIT, Category.MEAT, Category.SLIMES }.Do(x => catDict[x] = [.. catDict[x], .. AssetManager.JsonData.Where(y => y.Category == x).Select(y =>
            y.MainId)]);
        catDict[Category.PLORTS] = [.. catDict[Category.PLORTS], .. SlimeManager.Slimes.Select(y => y.PlortId)];
    }
}