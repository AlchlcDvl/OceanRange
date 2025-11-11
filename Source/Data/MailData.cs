// ReSharper disable UnassignedField.Global

// using System.Reflection;

namespace OceanRange.Data;

public sealed class MailData : JsonData
{
    // private static readonly Dictionary<string, MethodInfo> Methods = [];

    // static MailData()
    // {
    //     foreach (var method in AccessTools.GetDeclaredMethods(typeof(Mailbox)))
    //     {
    //         if (method.Name.EndsWith("Details", StringComparison.Ordinal))
    //             Methods[method.Name] = method;
    //     }
    // }

    [JsonRequired] public string Id;

    public double? UnlockAfter;

    [JsonIgnore] public bool Sent;
    [JsonIgnore] public bool Read;

    public event Func<double, bool> UnlockFuncAnd;
    // public event Func<double, bool> UnlockFuncOr;

    private Func<double, bool>[] Subscribers;

    private bool NoSubscribers;

    protected override void OnDeserialise()
    {
        // if (Methods.TryGetValue("Init" + Name.Replace(" ", string.Empty) + "Details", out var method))
        //     method.Invoke(null, [this]);

        Subscribers = UnlockFuncAnd?.GetInvocationList()?.Select(x => (Func<double, bool>)x)?.ToArray();

        NoSubscribers = Subscribers?.Length is null or 0;
    }

    public bool ShouldUnlock(double time)
    {
        if (Sent || Read || UnlockAfter > time)
            return false;

        return /*UnlockFuncOr?.Invoke(time) == true || */NoSubscribers || Subscribers.All(subscriber => subscriber(time));
    }
}