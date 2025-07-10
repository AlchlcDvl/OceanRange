namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(SlimeRandomMove), nameof(SlimeRandomMove.Action))]
public static class StopMovingDuringDay
{
    public static bool Prefix(SlimeRandomMove __instance, ref (float, float) __state)
    {
        __state = (__instance.scootSpeedFactor, __instance.verticalFactor);

        if (!__instance.TryGetComponent<LanternBehaviour>(out var lantern))
            return true;

        if (!lantern.CanMove)
            return false;

        if (lantern.Fleeing)
        {
            __instance.scootSpeedFactor *= 2f;
            __instance.verticalFactor *= 2f;
        }

        return true;
    }

    public static void Postfix(SlimeRandomMove __instance, ref (float, float) __state) => (__instance.scootSpeedFactor, __instance.verticalFactor) = __state;
}