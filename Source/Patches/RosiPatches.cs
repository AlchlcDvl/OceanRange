namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeEat), nameof(SlimeEat.Produce))]
public static class SlimeEatProduce
{
    public static void Prefix(SlimeEat __instance, ref int count)
    {
        if (!__instance.GetComponent<RosiBehaviour>())
            return;

        var collider = CorralRegion.allCorrals.Find(x => x.GetComponent<Collider>().bounds.Contains(__instance.transform.position))?.GetComponent<Collider>();
        count = Mathf.Min(collider ? RosiBehaviour.All.Count(item => collider.bounds.Contains(item.transform.position)) : 1, 10);
    }
}