// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;


#if UNITY
[Serializable]
#endif
public sealed  class RancherData : JsonData
{
#if !UNITY
    [JsonRequired] public Category[] Rewards;
    [JsonRequired] public Category[] Requests;
    [JsonRequired] public Category[] RareRewards;

    public IdentifiableId[] IndivRewards;
    public IdentifiableId[] IndivRequests;
    public IdentifiableId[] IndivRareRewards;

    [JsonIgnore] public string RancherId;
    [JsonIgnore] public RancherName RancherName;
    [JsonIgnore] public ExchangeDirector.Rancher Rancher;

    private static ProgressType ExchangeThreshold = ProgressType.EXCHANGE_BOB;

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);

        Rewards = reader.ReadEnumArray<Category>();
        Requests = reader.ReadEnumArray<Category>();
        RareRewards = reader.ReadEnumArray<Category>();
        IndivRewards = reader.ReadEnumArray<IdentifiableId>();
        IndivRequests = reader.ReadEnumArray<IdentifiableId>();
        IndivRareRewards = reader.ReadEnumArray<IdentifiableId>();
    }

    public override void OnDeserialise()
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
            indivRequests = IndivRequests,
            indivRewards = IndivRewards,
            indivRareRewards = IndivRareRewards
        };

        var exchange = Helpers.AddEnumValue("EXCHANGE_" + upper, ++ExchangeThreshold);
        Mailbox.MailMap["exchangeintro_" + RancherId].UnlockFuncAnd += _ =>
            SceneContext.Instance.ProgressDirector.HasProgress(exchange);
    }

    private static readonly HashSet<string> OfferIds = new(StringComparer.Ordinal);
    private static readonly Dictionary<Language, HashSet<int>> LoadingIndices = new(LanguageComparer.Instance);

    public void HandleTranslationData(RancherLangData langData, Language lang)
    {
        if (Rancher.numBlurbs != langData.Offers.Length)
        {
            Rancher.numBlurbs = langData.Offers.Length;

            for (var i = 0; i < langData.Offers.Length; i++)
            {
                var id = $"m.offer_{i + 1}.{RancherId}";

                if (OfferIds.Add(id)) // In case the number of offers changes between languages
                    ExchangeOfferRegistry.RegisterOfferID(id);
            }
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
#else
    [JsonRequired] public string[] Rewards;
    [JsonRequired] public string[] Requests;
    [JsonRequired] public string[] RareRewards;

    public string[] IndivRewards;
    public string[] IndivRequests;
    public string[] IndivRareRewards;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);

        pooler.PoolStrings(Rewards);
        pooler.PoolStrings(Requests);
        pooler.PoolStrings(RareRewards);
        pooler.PoolStrings(IndivRewards);
        pooler.PoolStrings(IndivRequests);
        pooler.PoolStrings(IndivRareRewards);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);

        writer.WriteStringArray(Rewards);
        writer.WriteStringArray(Requests);
        writer.WriteStringArray(RareRewards);
        writer.WriteStringArray(IndivRewards);
        writer.WriteStringArray(IndivRequests);
        writer.WriteStringArray(IndivRareRewards);
    }
#endif
}