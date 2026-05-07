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

#if !UNITY
    [JsonIgnore] public bool Sent;
    [JsonIgnore] public bool Read;

    public event Func<double, bool> UnlockFuncAnd;
    // public event Func<double, bool> UnlockFuncOr;

    private Func<double, bool>[] Subscribers;
    private bool NoSubscribers;
#endif

#if UNITY
    public override void FindStrings(DataWriter writer)
    {
        base.FindStrings(writer);
        writer.PoolString(Id);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Id);
        writer.WriteNullableDouble(UnlockAfter);
    }
#else
    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Id = reader.ReadString();
        UnlockAfter = reader.ReadNullableDouble();
    }

    public override void OnDeserialise()
    {
        // if (Methods.TryGetValue("Init" + Name.Replace(" ", string.Empty) + "Details", out var method))
        //     method.Invoke(null, [this]);

        Subscribers = UnlockFuncAnd?.GetInvocationList().Cast<Func<double, bool>>().ToArray();
        NoSubscribers = Subscribers.IsNullOrEmpty();
    }

    public bool ShouldUnlock(double time)
    {
        if (Sent || Read || UnlockAfter.GetValueOrDefault() > time)
            return false;

        return /*UnlockFuncOr?.Invoke(time) == true || */NoSubscribers || Subscribers.All(subscriber => subscriber(time));
    }
#endif
}