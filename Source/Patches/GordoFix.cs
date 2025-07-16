using SRML.SR.Utils;

namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(GordoEat), nameof(GordoEat.Awake))]
public static class GordoIdFix
{
    public static void Prefix(GordoEat __instance)
    {
        if (!__instance.TryGetComponent<CustomGordo>(out var custom))
            return;

        __instance.director = IdHandlerUtils.GlobalIdDirector;
        __instance.director.persistenceDict.Add(__instance, custom.ID);
    }
}