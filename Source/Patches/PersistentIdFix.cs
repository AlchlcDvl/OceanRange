using SRML.SR.Utils;

namespace OceanRange.Patches;

[HarmonyPatch(typeof(IdHandler), nameof(IdHandler.id), MethodType.Getter), UsedImplicitly]
public static class PersistentIdFix
{
    [UsedImplicitly]
    public static bool Prefix(IdHandler __instance, ref string __result)
    {
        if (__instance.director || !__instance.TryGetComponent<PersistentIdHandler>(out var id))
            return true;

        __result = id.ID;

        if (!__instance.director)
        {
            __instance.director = __instance.GetRequiredComponentInParent<IdDirector>() ?? IdHandlerUtils.GlobalIdDirector;
            __instance.director?.persistenceDict?.Add(__instance, __result);
        }

        return false;
    }
}