using SRML.SR.Utils;

namespace OceanRange.Patches;

[HarmonyPatch(typeof(GordoEat))]
public static class GordoIdFix
{
    [HarmonyPatch(nameof(GordoEat.Awake)), HarmonyPrefix]
    public static void AwakePrefix(GordoEat __instance)
    {
        if (!__instance.TryGetComponent<CustomGordo>(out var custom))
            return;

        __instance.director = IdHandlerUtils.GlobalIdDirector;
        __instance.director.persistenceDict.Add(__instance, custom.ID);
    }

    [HarmonyPatch(nameof(GordoEat.OnDestroy)), HarmonyPrefix]
    public static bool OnDestroyPrefix(GordoEat __instance)
    {
        if (!__instance.TryGetComponent<CustomGordo>(out var custom))
            return true;

        if (SceneContext.Instance && !string.IsNullOrEmpty(custom.ID))
            SceneContext.Instance.GameModel.UnregisterGordo(custom.ID);

        return false;
    }

    [HarmonyPatch(nameof(GordoEat.Start)), HarmonyPrefix]
    public static bool StartPrefix(GordoEat __instance)
    {
        if (!SlimeManager.MgExists || !__instance.TryGetComponent<GordoIdentifiable>(out var identifiable) || identifiable.id != Ids.SAND_GORDO)
            return true;

        var count = __instance.GetEatenCount();

        if (count != -1 && count >= __instance.GetTargetCount())
            __instance.ImmediateReachedTarget();

        return false;
    }

    [HarmonyPatch(nameof(GordoEat.GetDirectFoodGroupsMsg))]
    public static bool Prefix(GordoEat __instance, ref string __result)
    {
        if (!SlimeManager.MgExists || !__instance.TryGetComponent<GordoIdentifiable>(out var identifiable) || identifiable.id != Ids.SAND_GORDO)
            return true;

        __result = "m.foodgroup.dirt_gordo";
        return false;
    }
}