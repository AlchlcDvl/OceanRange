namespace OceanRange.Patches;

[HarmonyPatch(typeof(DamagePlayerOnTouch), nameof(DamagePlayerOnTouch.OnControllerCollision)), UsedImplicitly]
public static class CocoDamageRegisterPatch
{
    [UsedImplicitly]
    public static bool Prefix(DamagePlayerOnTouch __instance, GameObject gameObj)
    {
        if (!__instance.TryGetComponent<CocoBehaviour>(out var coco))
            return true;

        coco.OnControllerCollision(gameObj);
        return false;
    }
}