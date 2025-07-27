namespace OceanRange.Patches;

[HarmonyPatch(typeof(GordoEat))]
public static class GordoIdFix
{
    [HarmonyPatch(nameof(GordoEat.Start))]
    public static bool Prefix(GordoEat __instance)
    {
        if (!SlimeManager.MgExists || !__instance.TryGetComponent<GordoIdentifiable>(out var identifiable) || identifiable.id != Ids.SAND_GORDO)
            return true;

        var count = __instance.GetEatenCount();

        if (count != -1 && count >= __instance.GetTargetCount())
            __instance.ImmediateReachedTarget();

        return false;
    }

    [HarmonyPatch(nameof(GordoEat.GetDirectFoodGroupsMsg))]
    public static bool Prefix(GordoEat __instance, ref string __result)
    {
        if (!SlimeManager.MgExists || !__instance.TryGetComponent<GordoIdentifiable>(out var identifiable) || identifiable.id != Ids.SAND_GORDO)
            return true;

        __result = "m.foodgroup.dirt_gordo";
        return false;
    }
}