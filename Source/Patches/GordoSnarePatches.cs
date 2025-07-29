namespace OceanRange.Patches;

[HarmonyPatch(typeof(GordoSnare)), HarmonyPriority(Priority.First)]
public static class GordoSnarePatches
{
    [HarmonyPatch(nameof(GordoSnare.GetGordoIdForBait))]
    public static bool Prefix(GordoSnare __instance, ref IdentifiableId __result)
    {
        if (!SlimeManager.Slimes.TryFinding(x => x.FavFood == __instance.model.baitTypeId, out var id) || Randoms.SHARED.GetInRange(0, 100) > 70)
            return true;

        __result = id.GordoId;
        return false;
    }

    [HarmonyPatch(nameof(GordoSnare.OnTriggerEnter))]
    public static bool Prefix(GordoSnare __instance, Collider col)
    {
        if (!SlimeManager.MgExists)
            return true;

        if (col.isTrigger || __instance.bait || __instance.isSnared || !col.TryGetComponent<Identifiable>(out var identifiable))
            return false;

        if (Identifiable.IsFood(identifiable.id) || identifiable.id == IdentifiableId.SILKY_SAND_CRAFT)
        {
            if (__instance.baitAttachedFx)
                SRBehaviour.SpawnAndPlayFX(__instance.baitAttachedFx, __instance.gameObject);

            Destroyer.DestroyActor(col.gameObject, "GordoSnare.OnTriggerEnter");
            __instance.AttachBait(identifiable.id);
        }

        return false;
    }
}