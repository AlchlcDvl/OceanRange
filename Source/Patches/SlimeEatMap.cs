namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(SlimeEat), "GetFoodGroupIds")]
public static class FoodGroupPatch
{
    public static void Postfix(ref IdentifiableId[] __result, FoodGroup group)
    {
        if (__result != null)
            __result = [..__result, ..FoodManager.FoodsMap.Where(x => x.Value.Group == group).Select(x => x.Key)];
    }
}