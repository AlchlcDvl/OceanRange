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

        Mailbox.MailMap["exchangeintro_" + RancherId].UnlockFuncAnd +=
            _ => SceneContext.Instance.ProgressDirector.HasProgress(Helpers.AddEnumValue<ProgressType>("EXCHANGE_" + upper));
    }

    [JsonIgnore] private bool Handled;

    public void HandleTranslationData(RancherLangData langData)
    {
        if (Handled)
            return;

        var offerIds = new HashSet<string>();

        for (var i = 0; i < langData.Offers.Length; i++)
        {
            var id = $"m.offer_{i + 1}.{RancherId}";

            if (offerIds.Contains(id))
                continue;

            ExchangeOfferRegistry.RegisterOfferID(id);
            offerIds.Add(id);
        }

        var specId = $"m.bonusoffer.{RancherId}";

        if (!offerIds.Contains(specId))
            ExchangeOfferRegistry.RegisterOfferID(specId);

        if (!Main.ClsExists)
            return;

        var loadingIndices = new HashSet<int>();

        for (var i = 0; i < langData.LoadingTexts.Length; i++)
        {
            if (loadingIndices.Contains(i))
                continue;

            Translator.LoadingIds.Add(GetNextLoadingIdBypass());
            loadingIndices.Add(i);
        }

        Handled = true;
    }

    private static string GetNextLoadingIdBypass() => CLS.AddToLoading.GetNextLoadingId();
}