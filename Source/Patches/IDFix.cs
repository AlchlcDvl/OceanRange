namespace OceanRange.Patches;

[HarmonyPatch(typeof(LiquidSource), nameof(LiquidSource.Register))]
public static class IDFix
{
    public static bool Prefix(LiquidSource __instance)
    {
        return false;
    }
}