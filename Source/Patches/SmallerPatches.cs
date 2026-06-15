using OceanRange.Saves;

namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeDiet), nameof(SlimeDiet.RefreshEatMap))]
public static class EatMapFix
{
    public static void Postfix(SlimeDiet __instance, SlimeDefinition definition)
    {
        if (definition.IdentifiableId != Ids.SAND_SLIME)
            return;

        __instance.EatMap.RemoveAll(x => x.eats == IdentifiableId.SILKY_SAND_CRAFT);
        __instance.EatMap.Add(new()
        {
            eats = IdentifiableId.SILKY_SAND_CRAFT,
            producesId = definition.Diet.Produces[0],
            isFavorite = true,
            driver = SlimeEmotions.Emotion.NONE
        });
    }
}

[HarmonyPatch(typeof(GordoEat), nameof(GordoEat.ImmediateReachedTarget))]
public static class EnsureGordoStaysPopped
{
    public static void Postfix(GordoEat __instance)
    {
        if (__instance.TryGetComponent<GordoIdentifiable>(out var identifiable))
            GordoSaveDataV02.Lookup[identifiable.id].IsPopped = true;
    }
}

[HarmonyPatch(typeof(AutoSaveDirector))]
public static class EnsureAutoSaveDirectorData
{
    public static bool IsAutoSave { get; private set; }

    [HarmonyPatch(nameof(AutoSaveDirector.SaveAllNow))]
    public static void Prefix() => IsAutoSave = true;

    [HarmonyPatch(nameof(AutoSaveDirector.SaveGame))]
    public static void Postfix() => IsAutoSave = false;
}

[HarmonyPatch(typeof(ResourceBundle), nameof(ResourceBundle.LoadFromText))]
public static class LatchCustomTranslations
{
    public static void Postfix(string path, Dictionary<string, string> __result)
    {
        if (!GameContext.Instance.MessageDirector.GetCultureLang().GetTranslations().TryGetValue(path, out var translations))
            return;

        foreach (var (id, text) in translations)
            __result[id] = text;
    }
}

[HarmonyPatch(typeof(MessageDirector), nameof(MessageDirector.Awake))]
public static class HookLanguageLoading
{
    public static void Prefix(MessageDirector __instance) => Translator.MessageDirectorHook(__instance);
}

[HarmonyPatch(typeof(ExchangeDirector), nameof(ExchangeDirector.Awake))]
public static class FilterValues
{
    public static void Postfix(ExchangeDirector __instance)
    {
        __instance.catDict[Category.PLORTS] = [.. __instance.catDict[Category.PLORTS].Except(x => Slimepedia.PlortDataMap.TryGetValue(x, out var value) && !value.Exchangeable)];
        __instance.catDict[Category.SLIMES] = [.. __instance.catDict[Category.SLIMES].Except(x => Slimepedia.SlimeDataMap.TryGetValue(x, out var value) && !value.Exchangeable)];
    }
}

[HarmonyPatch(typeof(StalkConsumable))]
public static class StalkConsumablePatch
{
    [HarmonyPatch(nameof(StalkConsumable.SetStealth))]
    public static void Postfix(StalkConsumable __instance, bool isStealthed)
    {
        if (__instance.TryGetComponent<StealthFixer>(out var fixer) && !__instance.HasComponent<MimicBehaviour>())
            fixer.SetStealth(isStealthed);
    }

    [HarmonyPatch(nameof(StalkConsumable.ProcessCollisionEnter))]
    public static bool Prefix(StalkConsumable __instance, Collision col)
    {
        if (Identifiable.BOOP_CLASS.Contains(__instance.identifiable.id) && __instance.pouncing && !__instance.stealth && !__instance.HasComponent<StealthFixer>() && col.gameObject == SceneContext.Instance.Player && !__instance.HasComponent<MimicBehaviour>())
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

[HarmonyPatch(typeof(SlimeFace), nameof(SlimeFace.OnEnable))]
public static class FixOnEnableFromRunningEarly
{
    public static bool Prefix(SlimeFace __instance) => __instance is { ExpressionFaces: not null, _expressionToFaceLookup: not null };
}

[HarmonyPatch(typeof(DLCDirector), nameof(DLCDirector.RegisterPackages))]
public static class ClearMeshes
{
    private static bool Uploaded;

    public static void Postfix()
    {
        if (Uploaded)
            return;

        foreach (var mesh in Inventory.GetAllMeshes())
            mesh.UploadMeshData(true);

        Uploaded = true;
    }
}

// TODO: Remove when SRML implements this
[HarmonyPatch(typeof(SlimeAppearanceUI), nameof(SlimeAppearanceUI.ShouldShowSlimeInList))]
public static class CorrectlyCheckSlimes
{
    public static bool Prefix(SlimeDefinition slime, ref bool __result)
    {
        if (Identifiable.IsLargo(slime.IdentifiableId) || Identifiable.IsGordo(slime.IdentifiableId))
            __result = false;
        else
            __result = slime.AppearancesDynamic.Count > 0;

        return false;
    }
}