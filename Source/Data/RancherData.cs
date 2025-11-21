// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

public sealed class RancherData : JsonData
{
    [JsonRequired] public Category[] Rewards;
    [JsonRequired] public Category[] Requests;
    [JsonRequired] public Category[] RareRewards;

    public IdentifiableId[] IndivRewards;
    public IdentifiableId[] IndivRequests;
    public IdentifiableId[] IndivRareRewards;

    [JsonIgnore] public string RancherId;
    [JsonIgnore] public RancherName RancherName;
    [JsonIgnore] public ExchangeDirector.Rancher Rancher;

    protected override void OnDeserialise()
    {
        RancherId = Name.ToLowerInvariant();

        var upper = Name.ToUpperInvariant();

        RancherName = Helpers.AddEnumValue<RancherName>(upper);

        Rancher = new()
        {
            name = RancherId,
            defaultImg = Inventory.GetSprite(RancherId + "_default"),
            icon = Inventory.GetSprite(RancherId),
            requestCategories = Requests,
            rewardCategories = Rewards,
            rareRewardCategories = RareRewards,
            indivRequests = IndivRequests ?? [],
            indivRewards = IndivRewards ?? [],
            indivRareRewards = IndivRareRewards ?? []
        };

        var exchange = Helpers.AddEnumValue<ProgressType>("EXCHANGE_" + upper);
        Mailbox.MailMap["exchangeintro_" + RancherId].UnlockFuncAnd += _ => SceneContext.Instance.ProgressDirector.HasProgress(exchange);
    }

    private static readonly HashSet<string> OfferIds = [];
    private static readonly Dictionary<Language, HashSet<int>> LoadingIndices = new(LanguageComparer.Instance);

    public void HandleTranslationData(RancherLangData langData, Language lang)
    {
        Rancher.numBlurbs = langData.Offers.Length;

        for (var i = 0; i < langData.Offers.Length; i++)
        {
            var id = $"m.offer_{i + 1}.{RancherId}";

            if (OfferIds.Add(id))
                ExchangeOfferRegistry.RegisterOfferID(id);
        }

        var specId = $"m.bonusoffer.{RancherId}";

        if (OfferIds.Add(specId))
            ExchangeOfferRegistry.RegisterOfferID(specId);

        if (!Main.ClsExists || Translator.LoadingIds.ContainsKey(lang) || LoadingIndices.ContainsKey(lang))
            return;

        var ids = Translator.LoadingIds[lang] = [];
        var indices = LoadingIndices[lang] = [];

        for (var i = 0; i < langData.LoadingTexts.Length; i++)
        {
            if (!indices.Add(i))
                continue;

            var id = GetNextLoadingIdBypass(lang);
            ids.Add(id);
            AddLocalTipTextBypass(id, lang);
        }
    }

    private static string GetNextLoadingIdBypass(Language lang) => CLS.AddToLoading.GetNextLoadingId(lang);

    private static void AddLocalTipTextBypass(string id, Language lang) => CLS.AddToLoading.AddLocalTipText(id, lang);
}