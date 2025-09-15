using System.Reflection;

namespace OceanRange.Modules;

public sealed class MailData : JsonData
{
    private static readonly Dictionary<string, MethodInfo> Methods = [];

    static MailData()
    {
        foreach (var method in AccessTools.GetDeclaredMethods(typeof(Mailbox)))
        {
            if (method.Name.EndsWith("Details", StringComparison.Ordinal))
                Methods[method.Name] = method;
        }
    }

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
    // public event Func<double, bool> UnlockFuncOr;

    private Func<double, bool>[] Subscribers;

    [OnDeserialized]
    public void PopulateData(StreamingContext _)
    {
        if (Methods.TryGetValue("Init" + Name.Replace(" ", "") + "Details", out var method))
            method.Invoke(null, [this]);

        if (UnlockAfter.HasValue)
            UnlockFuncAnd += time => UnlockAfter.Value < time;

        Subscribers = UnlockFuncAnd?.GetInvocationList()?.Select(x => (Func<double, bool>)x)?.ToArray();
    }

    public bool ShouldUnlock(double time)
    {
        if (Sent || Read)
            return false;

        return /*UnlockFuncOr?.Invoke(time) == true || */Subscribers?.Length is null or 0 || Subscribers.All(subscriber => subscriber(time));
    }
}