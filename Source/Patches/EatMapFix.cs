namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeDiet), nameof(SlimeDiet.RefreshEatMap))]
public static class EatMapFix
{
    public static void Postfix(SlimeDiet __instance) => __instance.EatMap.RemoveAll(x => Identifiable.CHICK_CLASS.Contains(x.eats));
}