namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeDiet), nameof(SlimeDiet.RefreshEatMap))]
public static class EatMapFix
{
    public static void Postfix(SlimeDiet __instance) => __instance.EatMap.RemoveAll(x => x.eats == Ids.RADIANT_CHICK || x.eats == Ids.SANDY_CHICK);
}