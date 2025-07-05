namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(SlimeEat), "Produce")]
public static class SlimeEatProduce
{
    public static void Prefix(SlimeEat __instance, ref int count)
    {
        if (!__instance.GetComponent<RosiBehaviour>())
            return;

        Collider val = null;
        var flag = false;

        foreach (var allCorral in CorralTracker.AllCorrals)
        {
            var collider = allCorral.GetComponent<Collider>();

            if (!collider.bounds.Contains(__instance.transform.position))
                continue;

            val = collider;
            flag = true;
            break;
        }

        if (!flag || !val)
        {
            count = 1;
            return;
        }

        var num = 0;

        foreach (var item in RosiBehaviour.All)
        {
            if (val.bounds.Contains(item.transform.position))
                num++;
        }

        count = num;
    }
}

[HarmonyPatch(typeof(CorralRegion))]
public static class CorralTracker
{
    public static readonly List<CorralRegion> AllCorrals = [];

    [HarmonyPatch(nameof(CorralRegion.Awake))]
    public static void Postfix(CorralRegion __instance) => AllCorrals.Add(__instance);

    [HarmonyPatch(nameof(CorralRegion.OnDestroy))]
    public static void Prefix(CorralRegion __instance) => AllCorrals.Remove(__instance);
}