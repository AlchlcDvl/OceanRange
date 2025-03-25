using MonomiPark.SlimeRancher.DataModel;

namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(GordoSnare), "GetGordoIdForBait")]
public static class GordoSnarePatch
{
    [HarmonyPriority(800)]
    public static bool Prefix(GordoSnare __instance, ref IdentifiableId __result)
    {
        if (!SlimeManager.BaitToGordoMap.TryGetValue(__instance.GetPrivateField<SnareModel>("model").baitTypeId, out var data) || Randoms.SHARED.GetInRange(0, 100) > 70)
            return true;

        __result = data.GordoId;
        return false;
    }
}