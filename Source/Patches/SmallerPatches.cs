namespace OceanRange.Patches;

// This patch exists because the assembly publicizer has issues trying to publicize events, why???
[HarmonyPatch(typeof(SlimeAppearanceApplicator), nameof(SlimeAppearanceApplicator.ApplyAppearance))]
public static class MineSlimeAppearanceFix
{
    public static void Postfix(SlimeAppearanceApplicator __instance)
    {
        if (__instance.Appearance && __instance.TryGetComponent<MineBehaviour>(out var mine))
            mine.ExplodeFX = __instance.Appearance.ExplosionAppearance.explodeFx;
    }
}

// This is such a goofy oversight lmao, SRML used Identifiable.IsAnimal instead of directly comparing with the Identifiable.MEAT_CLASS, leading to chicks being eaten as well lol
// TODO: Remove when SRML v0.3.0 comes out
[HarmonyPatch(typeof(SlimeDiet), nameof(SlimeDiet.RefreshEatMap))]
public static class EatMapFix
{
    public static void Postfix(SlimeDiet __instance) => __instance.EatMap.RemoveAll(IsChick);

    private static readonly Predicate<SlimeDiet.EatMapEntry> IsChick = IsChickMethod;

    private static bool IsChickMethod(SlimeDiet.EatMapEntry entry) => Identifiable.CHICK_CLASS.Contains(entry.eats);
}