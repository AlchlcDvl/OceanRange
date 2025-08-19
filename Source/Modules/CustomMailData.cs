using System.Runtime.Serialization;

namespace OceanRange.Modules;

public sealed class CustomMailData : JsonData
{
    [JsonProperty("id"), JsonRequired]
    public string Id;

    [JsonProperty("title"), JsonRequired]
    public string Title;

    [JsonProperty("from"), JsonRequired]
    public string From;

    [JsonProperty("body"), JsonRequired]
    public string Body;

    [JsonProperty("unlockAfter")]
    public double? UnlockAfter;

    [JsonIgnore]
    public bool Sent;

    [JsonIgnore]
    public bool Read;

    public event Func<double, bool> UnlockFuncAnd;
    public event Func<double, bool> UnlockFuncOr;

    private Func<double, bool>[] Subscribers;

    [OnDeserialized]
    public void PopulateData(StreamingContext _)
    {
        AccessTools.Method(typeof(Mailbox), "Init" + Name.Replace(" ", "") + "Details")?.Invoke(null, [this]);

        if (UnlockAfter != null)
            UnlockFuncAnd += time => UnlockAfter.Value < time;

        Subscribers = UnlockFuncAnd?.GetInvocationList()?.Select(x => (Func<double, bool>)x)?.ToArray();
    }

    public bool ShouldUnlock(double time)
    {
        if (Sent || Read)
            return false;

        if (UnlockFuncOr?.Invoke(time) == true || Subscribers?.Length is null or 0)
            return true;

        foreach (var subscriber in Subscribers)
        {
            if (!subscriber(time))
                return false;
        }

        return true;
    }
}