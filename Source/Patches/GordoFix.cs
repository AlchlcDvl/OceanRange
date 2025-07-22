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
}