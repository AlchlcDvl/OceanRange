using MonomiPark.SlimeRancher.DataModel;

namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(GordoSnare), "GetGordoIdForBait"), HarmonyPriority(Priority.First)]
public static class GordoSnarePatch
{
    public static bool Prefix(GordoSnare __instance, ref IdentifiableId __result)
    {
        var bait = __instance.GetPrivateField<SnareModel>("model").baitTypeId;

        if (!SlimeManager.SlimesMap.Values.TryFinding(x => x.BaitId == bait, out var id) || Randoms.SHARED.GetInRange(0, 100) > 70)
            return true;

        __result = id.GordoId;
        return false;
    }
}