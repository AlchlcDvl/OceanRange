namespace OceanRange.Patches;

[HarmonyPatch(typeof(ZoneDirector), nameof(ZoneDirector.GetRegionSetId)), UsedImplicitly]
public static class SetModdedRegionId
{
    public static bool Prefix(ref RegionId __result, Zone zone)
    {
        var isModded = Atlas.ZoneToDataMap.TryGetValue(zone, out var data);

        if (isModded)
            __result = data.Region;

        return !isModded;
    }
}

[HarmonyPatch(typeof(PlayerZoneTracker), nameof(PlayerZoneTracker.OnEntered)), UsedImplicitly]
public static class ShowZonePediaPopUp
{
    public static void Postfix(PlayerZoneTracker __instance, Zone zone)
    {
        if (Atlas.ZoneToDataMap.TryGetValue(zone, out var data))
            __instance.pediaDir.MaybeShowPopup(data.PediaId);
    }
}