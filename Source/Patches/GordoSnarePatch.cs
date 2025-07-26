namespace OceanRange.Patches;

[HarmonyPatch(typeof(GordoSnare), nameof(GordoSnare.GetGordoIdForBait)), HarmonyPriority(Priority.First)]
public static class GordoSnarePatch
{
    public static bool Prefix(GordoSnare __instance, ref IdentifiableId __result)
    {
        if (!SlimeManager.Slimes.TryFinding(x => x.FavFood == __instance.model.baitTypeId, out var id) || (id.GordoId == Ids.SAND_GORDO && !SlimeManager.MgExists) || Randoms.SHARED.GetInRange(0, 100) > 70)
            return true;

        __result = id.GordoId;
        return false;
    }
}