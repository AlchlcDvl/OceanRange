using System.Reflection;

namespace OceanRange.Data;

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

    [JsonRequired] public string Id;

    public double? UnlockAfter;

    [JsonIgnore] public bool Sent;
    [JsonIgnore] public bool Read;

    public event Func<double, bool> UnlockFuncAnd;
    // public event Func<double, bool> UnlockFuncOr;

    private Func<double, bool>[] Subscribers;

    protected override void OnDeserialise()
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