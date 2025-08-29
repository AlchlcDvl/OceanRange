namespace OceanRange.Patches;

[HarmonyPatch(typeof(SlimeEat), nameof(SlimeEat.OnEat))]
public static class IncreaseHermitAffection
{
    public static void Postfix(SlimeEat __instance, bool isFavorite)
    {
        if (__instance.TryGetComponent<HermitBehaviour>(out var hermit) && hermit.CanMove.CanMove)
            hermit.Affection += isFavorite ? 0.2f : 0.1f;
    }
}