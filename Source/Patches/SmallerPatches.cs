namespace OceanRange.Patches;

// This patch exists because the assembly publicizer has issues trying to publicize events, why???
[HarmonyPatch(typeof(SlimeAppearanceApplicator), nameof(SlimeAppearanceApplicator.ApplyAppearance))]
public static class MineSlimeAppearanceFix
{
    public static void Postfix(SlimeAppearanceApplicator __instance)
    {
        if (__instance.Appearance && __instance.TryGetComponent<MineBehaviour>(out var mine))
            mine.ExplodeFX = __instance.Appearance.ExplosionAppearance.explodeFx;
    }
}

[HarmonyPatch(typeof(SlimeDiet), nameof(SlimeDiet.RefreshEatMap))]
public static class EatMapFix
{
    public static void Postfix(SlimeDiet __instance, SlimeDefinition definition)
    {
        // This is such a goofy oversight lmao, SRML used Identifiable.IsAnimal instead of directly comparing with the Identifiable.MEAT_CLASS, leading to chicks being eaten as well lol
        __instance.EatMap.RemoveAll(x => Identifiable.CHICK_CLASS.Contains(x.eats)); // TODO: Remove when SRML v0.3.0 comes out

        if (definition.IdentifiableId.IsAny(Ids.SAND_SLIME, Ids.SAND_GORDO))
        {
            __instance.EatMap.RemoveAll(x => x.eats == IdentifiableId.SILKY_SAND_CRAFT);
            __instance.EatMap.Add(new()
            {
                eats = IdentifiableId.SILKY_SAND_CRAFT,
                producesId = Ids.SAND_PLORT,
                isFavorite = true,
                favoriteProductionCount = __instance.FavoriteProductionCount,
                driver = SlimeEmotions.Emotion.NONE,
                minDrive = 0f,
                extraDrive = 0f,
                becomesId = IdentifiableId.NONE
            });
        }

        foreach (var (largoId, slimeId) in LargoManagerTemp.LargoMaps)
        {
            if (definition.IdentifiableId != slimeId || definition.Diet.MajorFoodGroups.Contains(FoodGroup.PLORTS) || !definition.Diet.Produces.TryFinding(Identifiable.IsPlort, out var plortId))
                continue;

            __instance.EatMap.RemoveAll(x => x.eats == plortId);
            __instance.EatMap.Add(new()
            {
                becomesId = largoId,
                eats = plortId,
                minDrive = 1f
            });
        }
    }
}

[HarmonyPatch(typeof(GordoEat), nameof(GordoEat.ImmediateReachedTarget))]
public static class EnsureGordoStaysPopped
{
    public static void Postfix(GordoEat __instance)
    {
        if (__instance.TryGetComponent<GordoPop>(out var pop))
            pop.Data.IsPopped = true;
    }
}

[HarmonyPatch(typeof(AutoSaveDirector))]
public static class EnsureAutoSaveDirectorData
{
    public static bool IsAutoSave;

    [HarmonyPatch(nameof(AutoSaveDirector.SaveAllNow))]
    public static void Prefix() => IsAutoSave = true;

    [HarmonyPatch(nameof(AutoSaveDirector.SaveGame))]
    public static void Postfix() => IsAutoSave = false;
}