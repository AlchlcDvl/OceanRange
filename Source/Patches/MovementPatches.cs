namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeRandomMove), nameof(SlimeRandomMove.Action)), UsedImplicitly]
public static class StopMoving
{
    [UsedImplicitly]
    public static bool Prefix(SlimeRandomMove __instance, ref (float, float) __state)
    {
        __state = (__instance.scootSpeedFactor, __instance.verticalFactor);

        if (!__instance.TryGetComponent<CanMoveHandler>(out var canMove))
            return true;

        if (!canMove.CanMove)
            return false;

        if (__instance.TryGetComponent<LanternBehaviour>(out var lantern) && lantern.Fleeing)
        {
            __instance.scootSpeedFactor *= 2f;
            __instance.verticalFactor *= 2f;
        }

        return true;
    }

    [UsedImplicitly]
    public static void Postfix(SlimeRandomMove __instance, ref (float, float) __state) => (__instance.scootSpeedFactor, __instance.verticalFactor) = __state;
}

[HarmonyPatch(typeof(GotoConsumable)), HarmonyPatch(typeof(SlimeHover)), UsedImplicitly]
public static class StopMovingTowardsFoodOrFlying
{
    [HarmonyPatch("Relevancy"), UsedImplicitly]
    public static bool Prefix(SlimeSubbehaviour __instance, ref float __result)
    {
        if (!__instance.TryGetComponent<CanMoveHandler>(out var canMove) || canMove.CanMove)
            return true;

        __result = 0f;
        return false;
    }
}