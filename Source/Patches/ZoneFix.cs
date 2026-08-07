// namespace OceanRange.Patches;

// [HarmonyPatch(typeof(ZoneDirector), nameof(ZoneDirector.GetRegionSetId))]
// public static class SetModdedRegionId
// {
//     public static bool Prefix(Zone zone, ref RegionId __result)
//     {
//         var isModded = Atlas.ZoneToDataMap.TryGetValue(zone, out var data);

//         if (isModded)
//             __result = data.Region;

//         return !isModded;
//     }
// }

// [HarmonyPatch(typeof(PlayerZoneTracker), nameof(PlayerZoneTracker.OnEntered))]
// public static class ShowZonePediaPopUp
// {
//     public static void Postfix(PlayerZoneTracker __instance, Zone zone)
//     {
//         if (Atlas.ZoneToDataMap.TryGetValue(zone, out var data))
//             __instance.pediaDir.MaybeShowPopup(data.PediaId);
//     }
// }