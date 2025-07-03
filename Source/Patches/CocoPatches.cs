namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(DamagePlayerOnTouch), "TryToDamage")]
public static class CocoDamagePlayer
{
    public static bool Prefix(DamagePlayerOnTouch __instance, GameObject gameObj)
    {
        if (!__instance.GetComponent<CocoBehaviour>())
            return true;

        return __instance.transform.position.y > gameObj.transform.position.y + 1;
    }
}

[HarmonyPatch(typeof(DamagePlayerOnTouch_Trigger), nameof(DamagePlayerOnTouch_Trigger.RegistryUpdate))]
public static class CocoDamagePlayerTrigger
{
    public static bool Prefix(DamagePlayerOnTouch_Trigger __instance)
    {
        if (!__instance.GetComponent<CocoBehaviour>())
            return true;

        return __instance.transform.position.y > __instance.GetPrivateField<GameObject>("damageGameObject").transform.position.y + 1;
    }
}