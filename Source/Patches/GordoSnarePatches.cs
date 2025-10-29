namespace OceanRange.Patches;

// TODO: Remove when the pr is merged and SRML 0.3.0 is out
[HarmonyPatch(typeof(GordoSnare), nameof(GordoSnare.GetGordoIdForBait)), HarmonyPriority(Priority.First + 1), UsedImplicitly]
public static class GordoSnarePatch
{
    public static IdentifiableId[] Pinks;

    [UsedImplicitly]
    public static bool Prefix(GordoSnare __instance, ref IdentifiableId __result)
    {
        var dictionary = new Dictionary<IdentifiableId, float>(Identifiable.idComparer);
        var normalIds = new List<IdentifiableId>();
        var favIds = new List<IdentifiableId>();

        foreach (var gordoEntry in GameContext.Instance.LookupDirector.GordoEntries)
        {
            var gordo = gordoEntry.GetComponent<GordoIdentifiable>();

            if (Pinks.Contains(gordo.id) || !gordo.nativeZones.Any(ZoneDirector.HasAccessToZone))
                continue;

            var diet = gordoEntry.GetComponent<GordoEat>().slimeDefinition.Diet;
            var list2 = new List<SlimeDiet.EatMapEntry>();
            diet.AddEatMapEntries(__instance.model.baitTypeId, list2);
            var eatMapEntry = list2.FirstOrDefault();

            if (eatMapEntry == null)
                continue;

            var (message, ids) = eatMapEntry.isFavorite ? ("Found favorite", favIds) : ("Adding potential", normalIds);
            Log.Debug(message, "gordo", gordo.id, "hasAccess", true);
            ids.Add(gordo.id);
        }

        if (normalIds.Count > 0)
        {
            var value = (float)__instance.foodTypeSnareWeight / normalIds.Count;

            foreach (var normalId in normalIds)
                dictionary.Add(normalId, value);
        }

        if (favIds.Count > 0)
        {
            var value = (float)__instance.favoredFoodSnareWeight / favIds.Count;

            foreach (var favId in favIds)
                dictionary.Add(favId, value);
        }

        if (Pinks.Length > 0)
        {
            var value = (float)__instance.pinkSnareWeight / Pinks.Length;

            foreach (var pink in Pinks)
                dictionary.Add(pink, value);
        }

        __result = Randoms.SHARED.Pick(dictionary, Randoms.SHARED.Pick(Pinks));
        return false;
    }
}