namespace OceanRange.Patches;

[HarmonyPatch(typeof(DamagePlayerOnTouch), nameof(DamagePlayerOnTouch.TryToDamage))]
public static class CocoDamageRegisterPatch
{
    public static bool Prefix(DamagePlayerOnTouch __instance, GameObject gameObj)
    {
        if (!__instance.TryGetComponent<CocoBehaviour>(out var coco))
            return true;

        coco.TryToDamage(gameObj);
        return false;
    }
}