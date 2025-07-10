namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(TargetingUI), "GetIdentifiableInfoText")]
public static class PatchForSandSlimeDiet
{
    public static bool Prefix(TargetingUI __instance, IdentifiableId identId, ref string __result)
    {
        if (identId != Ids.SAND_SLIME)
            return true;

        __result = __instance.GetPrivateField<MessageBundle>("uiBundle").Xlate(MessageUtil.Compose("m.hudinfo_diet", "m.foodgroup.dirt"));;
        return false;
    }
}