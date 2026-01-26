namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeEat), nameof(SlimeEat.Produce))]
public static class SlimeEatProduce
{
    public static void Prefix(SlimeEat __instance, ref int count)
    {
        if (!__instance.HasComponent<RosiBehaviour>() || !CorralRegion.allCorrals.TryFinding(x => x.GetComponent<Collider>().bounds.Contains(__instance.transform.position), out var corral))
            return;

        var bounds = corral.GetComponent<Collider>().bounds;
        count = Mathf.RoundToInt(Mathf.Pow(RosiBehaviour.All.Count(item => bounds.Contains(item.transform.position)), 0.51f));
    }
}