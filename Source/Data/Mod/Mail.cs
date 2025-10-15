namespace OceanRange.Data;

public sealed partial class MailData : ModData
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

    [JsonProperty] public double? UnlockAfter;

    public bool Sent;
    public bool Read;

    public event Func<double, bool> UnlockFuncAnd;
    // public event Func<double, bool> UnlockFuncOr;

    private Func<double, bool>[] Subscribers;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Id = reader.ReadString2();
        UnlockAfter = reader.ReadNullable(Helpers.ReadDouble2);
    }

    public override void OnDeserialise()
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