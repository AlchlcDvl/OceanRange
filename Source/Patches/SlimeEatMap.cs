// namespace TheOceanRange.Patches;

// [HarmonyPatch(typeof(SlimeEat), "GetFoodGroupIds")]
// public static class FoodGroupPatch
// {
//     public static void Postfix(FoodGroup group, ref IdentifiableId[] __result)
//     {
//         if (__result != null)
//             __result = [..__result, ..FoodManager.Foods.Where(x => x.Group == group).Select(x => x.FoodId)];
//     }
// }