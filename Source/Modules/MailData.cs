using System.Reflection;

namespace OceanRange.Modules;

public sealed class Starmail(BinaryReader reader) : Holder(reader)
{
    public MailData[] Mail;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);
        Mail = reader.ReadArray(Helpers.ReadModData<MailData>);
    }
}

public sealed class MailData : ModData
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

    public string Id;
    public double? UnlockAfter;

    public bool Sent;
    public bool Read;

    public event Func<double, bool> UnlockFuncAnd;
    // public event Func<double, bool> UnlockFuncOr;

    private Func<double, bool>[] Subscribers;

    public override void DeserialiseFrom(BinaryReader reader)
    {
        base.DeserialiseFrom(reader);

        Id = reader.ReadString();
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