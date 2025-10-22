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
        RancherName = Helpers.AddEnumValue<RancherName>(Name.ToUpperInvariant());

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
    }

    [JsonIgnore] private bool Handled;

    public void HandleTranslationData(RancherLangData langData)
    {
        if (Handled)
            return;

        for (var i = 0; i < langData.Offers.Length; i++)
        {
            var id = $"m.offer_{i + 1}.{RancherId}";

            if (Translator.OfferIds.Contains(id))
                continue;

            ExchangeOfferRegistry.RegisterOfferID(id);
            Translator.OfferIds.Add(id);
        }

        var specId = $"m.bonusoffer.{RancherId}";

        if (!Translator.OfferIds.Contains(specId))
            ExchangeOfferRegistry.RegisterOfferID(specId);

        if (!Main.ClsExists)
            return;

        for (var i = 0; i < langData.LoadingTexts.Length; i++)
        {
            if (Translator.LoadingIndices.Contains(i))
                continue;

            Translator.LoadingIds.Add(GetNextLoadingIdBypass());
            Translator.LoadingIndices.Add(i);
        }

        Handled = true;
    }

    private static string GetNextLoadingIdBypass() => CLS.AddToLoading.GetNextLoadingId();
}