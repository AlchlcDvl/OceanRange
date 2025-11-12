namespace OceanRange.Patches;

// This patch exists because the assembly publicizer has issues trying to publicize events, why???
[HarmonyPatch(typeof(SlimeAppearanceApplicator), nameof(SlimeAppearanceApplicator.ApplyAppearance)), UsedImplicitly]
public static class MineSlimeAppearanceFix
{
    [UsedImplicitly]
    public static void Postfix(SlimeAppearanceApplicator __instance)
    {
        if (!__instance.Appearance)
            return;

        if (__instance.TryGetComponent<MineBehaviour>(out var mine))
            mine.ExplodeFX = __instance.Appearance.ExplosionAppearance.explodeFx;

        if (__instance.TryGetComponent<StealthFixer>(out var fixer))
            fixer.UpdateMaterialStealthController();
    }
}

[HarmonyPatch(typeof(SlimeDiet), nameof(SlimeDiet.RefreshEatMap)), UsedImplicitly]
public static class EatMapFix
{
    [UsedImplicitly]
    public static void Postfix(SlimeDiet __instance, SlimeDefinitions definitions, SlimeDefinition definition)
    {
        // This is such a goofy oversight lmao, SRML used Identifiable.IsAnimal instead of directly comparing with the Identifiable.MEAT_CLASS, leading to chicks being eaten as well lol
        __instance.EatMap.RemoveAll(x => Identifiable.CHICK_CLASS.Contains(x.eats)); // TODO: Remove when SRML v0.3.0 comes out

        if (definition.IdentifiableId.ToString().Contains("SAND"))
        {
            __instance.EatMap.RemoveAll(x => x.eats == IdentifiableId.SILKY_SAND_CRAFT);
            __instance.EatMap.Add(new()
            {
                eats = IdentifiableId.SILKY_SAND_CRAFT,
                producesId = definition.Diet.Produces[0],
                isFavorite = true,
                favoriteProductionCount = __instance.FavoriteProductionCount,
                driver = SlimeEmotions.Emotion.NONE,
                minDrive = 0f,
                extraDrive = 0f,
                becomesId = IdentifiableId.NONE
            });
        }

        if (definition.Diet.MajorFoodGroups.Contains(FoodGroup.PLORTS) || !Largopedia.LargoMaps.TryGetValue(definition.IdentifiableId, out var maps))
            return;

        foreach (var (largoId, slimeId) in maps)
        {
            var slimeDef = definitions.GetSlimeByIdentifiableId(slimeId);

            if (slimeDef.Diet.MajorFoodGroups.Contains(FoodGroup.PLORTS) || !slimeDef.Diet.Produces.TryFinding(Identifiable.IsPlort, out var plortId))
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

[HarmonyPatch(typeof(GordoEat), nameof(GordoEat.ImmediateReachedTarget)), UsedImplicitly]
public static class EnsureGordoStaysPopped
{
    [UsedImplicitly]
    public static void Postfix(GordoEat __instance)
    {
        if (__instance.TryGetComponent<GordoPop>(out var pop))
            pop.Data.IsPopped = true;
    }
}

[HarmonyPatch(typeof(AutoSaveDirector)), UsedImplicitly]
public static class EnsureAutoSaveDirectorData
{
    public static bool IsAutoSave;

    [HarmonyPatch(nameof(AutoSaveDirector.SaveAllNow)), UsedImplicitly]
    public static void Prefix() => IsAutoSave = true;

    [HarmonyPatch(nameof(AutoSaveDirector.SaveGame)), UsedImplicitly]
    public static void Postfix() => IsAutoSave = false;
}

[HarmonyPatch(typeof(ResourceBundle), nameof(ResourceBundle.LoadFromText)), UsedImplicitly]
public static class LatchCustomTranslations
{
    [UsedImplicitly]
    public static void Postfix(string path, Dictionary<string, string> __result)
    {
        if (!GameContext.Instance.MessageDirector.GetCultureLang().GetTranslations().TryGetValue(path, out var translations))
            return;

        foreach (var (id, text) in translations)
            __result[id] = text;
    }
}

[HarmonyPatch(typeof(ExchangeDirector), nameof(ExchangeDirector.Awake)), UsedImplicitly]
public static class FilterValues
{
    [UsedImplicitly]
    public static void Postfix(ExchangeDirector __instance)
    {
        __instance.catDict[Category.PLORTS] = [.. __instance.catDict[Category.PLORTS].Except(x => Slimepedia.PlortDataMap.TryGetValue(x, out var value) && !value.Exchangeable)];
        __instance.catDict[Category.SLIMES] = [.. __instance.catDict[Category.SLIMES].Except(x => Slimepedia.SlimeDataMap.TryGetValue(x, out var value) && !value.Exchangeable)];
    }
}

[HarmonyPatch(typeof(StalkConsumable)), UsedImplicitly]
public static class StalkConsumablePatch
{
    [HarmonyPatch(nameof(StalkConsumable.SetStealth)), UsedImplicitly]
    public static void Postfix(StalkConsumable __instance, bool isStealthed)
    {
        if (__instance.TryGetComponent<StealthFixer>(out var fixer))
            fixer.SetStealth(isStealthed);
    }

    [HarmonyPatch(nameof(StalkConsumable.ProcessCollisionEnter)), UsedImplicitly]
    public static bool Prefix(StalkConsumable __instance, Collision col)
    {
        if (Identifiable.BOOP_CLASS.Contains(__instance.identifiable.id) && __instance.pouncing && !__instance.stealth && !__instance.GetComponent<StealthFixer>() && col.gameObject == SceneContext.Instance.Player)
        {
            var vector = col.gameObject.transform.InverseTransformPoint(col.contacts[0].point);

            if (vector is { z: > 0.2f, y: > 1f })
                SceneContext.Instance.AchievementsDirector.AddToStat(AchievementsDirector.IntStat.TABBY_HEADBUTT, 1);
        }
        else if (__instance.feinting)
        {
            __instance.pivotNow = true;
            __instance.feinting = false;
        }

        return false;
    }
}