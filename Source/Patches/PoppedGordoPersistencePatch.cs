namespace OceanRange.Patches;

[HarmonyPatch(typeof(GordoEat), nameof(GordoEat.ImmediateReachedTarget))]
public static class EnsureGordoStaysPopped
{
    public static void Postfix(GordoEat __instance)
    {
        if (__instance.TryGetComponent<GordoPop>(out var pop))
            pop.Data.IsPopped = true;
    }
}