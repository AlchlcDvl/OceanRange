namespace OceanRange.Patches;

[HarmonyPatch]
public static class ZoneFix
{
    [HarmonyPatch(typeof(ZoneDirector), nameof(ZoneDirector.GetRegionSetId))]
    [HarmonyPrefix]
    public static bool RegionSetId(ref RegionId __result, Zone zone)
    {
        // cant do switch/case with modded ids...
        if (zone == Ids.SWIRLPOOL)
        {
            __result = Ids.UNDERWATER;
            return false;
        }

        return true;
    }

    [HarmonyPatch(typeof(PlayerZoneTracker), nameof(PlayerZoneTracker.OnEntered))]
    [HarmonyPostfix]
    private static void ZoneEnter(Zone zone)
    {
        if (zone == Ids.SWIRLPOOL)
            SceneContext.Instance.PediaDirector.MaybeShowPopup(Ids.SWIRLPOOL_ENTRY);
    }

}