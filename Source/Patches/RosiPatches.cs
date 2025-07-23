namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeEat), nameof(SlimeEat.Produce))]
public static class SlimeEatProduce
{
    public static void Prefix(SlimeEat __instance, ref int count)
    {
        if (!__instance.GetComponent<RosiBehaviour>())
            return;

        Collider val = null;
        var flag = false;

        foreach (var allCorral in CorralRegion.allCorrals)
        {
            var collider = allCorral.GetComponent<Collider>();

            if (!collider.bounds.Contains(__instance.transform.position))
                continue;

            val = collider;
            flag = true;
            break;
        }

        count = flag && val ? RosiBehaviour.All.Count(item => val.bounds.Contains(item.transform.position)) : 1;
    }
}