namespace OceanRange.Patches;

[HarmonyPatch(typeof(GordoSnare)), HarmonyPriority(Priority.First + 1)]
public static class GordoSnarePatches
{
    private static readonly Func<Zone, bool> HasAccessToZone = ZoneDirector.HasAccessToZone;

    public static IdentifiableId[] Pinks;

    [HarmonyPatch(nameof(GordoSnare.GetGordoIdForBait))]
    public static bool Prefix(GordoSnare __instance, ref IdentifiableId __result)
    {
        var dictionary = new Dictionary<IdentifiableId, float>(Identifiable.idComparer);
        var id = IdentifiableId.NONE;
        var ids = new List<IdentifiableId>();

        foreach (var gordoEntry in GameContext.Instance.LookupDirector.GordoEntries)
        {
            var component2 = gordoEntry.GetComponent<GordoIdentifiable>();

            if (Pinks.Contains(component2.id))
                continue;

            var diet = gordoEntry.GetComponent<GordoEat>().slimeDefinition.Diet;
            var list2 = new List<SlimeDiet.EatMapEntry>();
            diet.AddEatMapEntries(__instance.model.baitTypeId, list2);
            var eatMapEntry = list2.FirstOrDefault();
            var flag = component2.nativeZones.Any(HasAccessToZone);

            if (!flag || eatMapEntry == null)
                continue;

            Log.Debug(eatMapEntry.isFavorite ? "Found favorite" : "Adding potential", "gordo", component2.id, "hasAccess", flag);

            if (eatMapEntry.isFavorite)
                id = component2.id;
            else
                ids.Add(component2.id);
        }

        if (ids.Count > 0)
        {
            var value = (float)__instance.foodTypeSnareWeight / ids.Count;

            for (var j = 0; j < ids.Count; j++)
                dictionary.Add(ids[j], value);
        }

        if (id != 0)
            dictionary.Add(id, __instance.favoredFoodSnareWeight);

        var pink = Randoms.SHARED.Pick(Pinks);
        dictionary.Add(pink, __instance.pinkSnareWeight);
        __result = Randoms.SHARED.Pick(dictionary, pink);
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