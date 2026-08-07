namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeFaceAnimator), nameof(SlimeFaceAnimator.RegistryUpdate))]
public static class SlimeFaceAnimatorRegistryUpdatePatch
{
    public static bool Prefix(SlimeFaceAnimator __instance)
    {
        if (__instance.TryGetComponent<HermitBehaviour>(out var hermit) && hermit.IsHiding)
            return false;

        if (__instance.TryGetComponent<LanternBehaviour>(out var lantern) && (lantern.Fleeing || !lantern.CanMove.CanMove))
            return false;

        return true;
    }
}