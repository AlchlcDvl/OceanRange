namespace OceanRange.Modules;

[HarmonyPatch(typeof(PediaUI))]
public static class PediaUIPatches
{
    [HarmonyPatch(nameof(PediaUI.Awake))]
    public static void Prefix(PediaUI __instance) => __instance.EnsureComponent<PediaOnomicsHandler>();

    [HarmonyPatch(nameof(PediaUI.PopulateSlimesDesc))]
    public static void Prefix(PediaUI __instance, string lowerName)
    {
        if (!__instance.TryGetComponent<PediaOnomicsHandler>(out var handler))
            return;

        if (!Translator.SlimeToOnomicsMap.TryGetValue(lowerName, out var key))
            key = "plorts";

        handler.Text.SetKey("l." + key);
    }
}