namespace OceanRange.Patches;

// TODO: Remove when SRML v0.3.0 comes out
[HarmonyPatch(typeof(SlimeDiet), nameof(SlimeDiet.RefreshEatMap))]
public static class EatMapFix
{
    public static void Postfix(SlimeDiet __instance) => __instance.EatMap.RemoveAll(x => Identifiable.CHICK_CLASS.Contains(x.eats));
}