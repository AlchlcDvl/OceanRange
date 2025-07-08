namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(SlimeDiet), "RefreshEatMap")]
public static class EatMapsPatch
{
    public static void Postfix(SlimeDiet __instance, SlimeDefinition definition)
    {
        foreach (var foodData in FoodManager.FoodsMap)
        {
            foreach (var id2 in definition.Diet.Produces)
            {
                __instance.EatMap.RemoveAll(x => x.eats == foodData.FoodId);
                __instance.EatMap.Add(new()
                {
                    isFavorite = foodData.FavouredBy.Contains(definition.IdentifiableId),
                    producesId = id2,
                    favoriteProductionCount = definition.Diet.FavoriteProductionCount + foodData.FavouriteModifier,
                    eats = foodData.FoodId,
                    minDrive = foodData.MinDrive
                });
            }
        }
    }
}