namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeFace), nameof(SlimeFace.GetExpressionFace))]
public static class PatchNewExpression
{
    public static bool Prefix(SlimeFace.SlimeExpression expression, ref SlimeExpressionFace __result)
    {
        if (expression != Ids.Sleeping)
            return true;

        __result = SlimeManager.SleepingFace;
        return false;
    }
}