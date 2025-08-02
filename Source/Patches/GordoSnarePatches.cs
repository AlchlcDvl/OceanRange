namespace OceanRange.Patches;

// TODO: Remove when the pr is merged and SRML 0.3.0 is out
[HarmonyPatch(typeof(GordoSnare), nameof(GordoSnare.GetGordoIdForBait)), HarmonyPriority(Priority.First + 1)]
public static class GordoSnarePatch
{
    private static readonly Func<Zone, bool> HasAccessToZone = ZoneDirector.HasAccessToZone;

    public static IdentifiableId[] Pinks;

    public static bool Prefix(GordoSnare __instance, ref IdentifiableId __result)
    {
        var dictionary = new Dictionary<IdentifiableId, float>(Identifiable.idComparer);
        var normalIds = new List<IdentifiableId>();
        var favIds = new List<IdentifiableId>();

        foreach (var gordoEntry in GameContext.Instance.LookupDirector.GordoEntries)
        {
            var gordo = gordoEntry.GetComponent<GordoIdentifiable>();

            if (Pinks.Contains(gordo.id) || !gordo.nativeZones.Any(HasAccessToZone))
                continue;

            var diet = gordoEntry.GetComponent<GordoEat>().slimeDefinition.Diet;
            var list2 = new List<SlimeDiet.EatMapEntry>();
            diet.AddEatMapEntries(__instance.model.baitTypeId, list2);
            var eatMapEntry = list2.FirstOrDefault();

            if (eatMapEntry == null)
                continue;

            var (message, ids) = eatMapEntry.isFavorite ? ("Found favorite", favIds) : ("Adding potential", normalIds);
            Log.Debug(message, "gordo", gordo.id, "hasAccess", true);

            if (gordo.id != Ids.SAND_GORDO && !eatMapEntry.isFavorite)
                ids.Add(gordo.id);
        }

        if (normalIds.Count > 0)
        {
            var value = (float)__instance.foodTypeSnareWeight / normalIds.Count;

            for (var j = 0; j < normalIds.Count; j++)
                dictionary.Add(normalIds[j], value);
        }

        if (favIds.Count > 0)
        {
            var value = (float)__instance.favoredFoodSnareWeight / favIds.Count;

            for (var j = 0; j < favIds.Count; j++)
                dictionary.Add(favIds[j], value);
        }

        if (Pinks.Length > 0)
        {
            var value = (float)__instance.pinkSnareWeight / Pinks.Length;

            for (var j = 0; j < Pinks.Length; j++)
                dictionary.Add(Pinks[j], value);
        }

        var pink = Randoms.SHARED.Pick(Pinks);
        __result = Randoms.SHARED.Pick(dictionary, pink);
        return false;
    }
}