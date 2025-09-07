namespace OceanRange.Managers;

public static class Contacts
{
    private static RancherData[] Ranchers;

#if DEBUG
    [TimeDiagnostic("Contacts Preload")]
#endif
    public static void PreloadRancherData()
    {
        Ranchers = Inventory.GetJsonArray<RancherData>("contacts");

        ExchangeOfferRegistry.RegisterCategory(Ids.OCEAN, [.. Slimepedia.Slimes.SelectMany(x => new[] { x.MainId, x.PlortId })]);

        SRCallbacks.PreSaveGameLoad += PreOnSaveLoad;
    }

#if DEBUG
    [TimeDiagnostic("Contacts OnSavePreload")]
#endif
    private static void PreOnSaveLoad(SceneContext context)
    {
        var background = context.ExchangeDirector.ranchers[1].chatBackground;

        foreach (var rancher in Ranchers)
            rancher.Rancher.chatBackground = background;
    }

#if DEBUG
    [TimeDiagnostic("Contacts Load")]
#endif
    public static void LoadAllRanchers() => Array.ForEach(Ranchers, LoadRancher);

    private static void LoadRancher(RancherData rancher)
    {
        rancher.Rancher = new()
        {
            name = rancher.RancherId,
            defaultImg = Inventory.GetSprite("lisa_default"),
            icon = Inventory.GetSprite("lisa"),
            numBlurbs = rancher.Dialogues.Length,
            requestCategories = [Ids.OCEAN],
            rewardCategories = [Category.PLORTS, Category.MEAT],
            rareRewardCategories = [Category.CRAFT_MATS],
            indivRequests = [],
            indivRewards = [],
            indivRareRewards = []
        };

        ExchangeOfferRegistry.RegisterRancher(rancher.Rancher);
        ExchangeOfferRegistry.RegisterRancherID(rancher.RancherId);

        for (var i = 0; i < rancher.Dialogues.Length; i++)
        {
            var id = $"m.offer_{i + 1}.{rancher.RancherId}";
            ExchangeOfferRegistry.RegisterOfferID(id);
            TranslationPatcher.AddExchangeTranslation(id, rancher.Dialogues[i]);
        }

        var specId = $"m.bonusoffer.{rancher.RancherId}";
        ExchangeOfferRegistry.RegisterOfferID(specId);
        TranslationPatcher.AddExchangeTranslation(specId, rancher.SpecialDialogue);

        TranslationPatcher.AddExchangeTranslation($"m.rancher.{rancher.RancherId}", rancher.FullName);

        if (Main.ClsExists)
            Main.AddTipTextBypass(rancher.LoadingText);
    }
}