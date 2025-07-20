namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(SlimeAppearanceApplicator), nameof(SlimeAppearanceApplicator.ApplyAppearance))]
public static class MineSlimeAppearanceFix
{
    public static void Postfix(SlimeAppearanceApplicator __instance)
    {
        if (__instance.Appearance && __instance.TryGetComponent<MineBehaviour>(out var mine))
            mine.ExplodeFX = __instance.Appearance.ExplosionAppearance.explodeFx;
    }
}