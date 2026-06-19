// ReSharper disable UnassignedField.Global

// using System.Reflection;

namespace OceanRange.Data;

[Serializable]
public sealed class MailData : JsonData
{
    // private static readonly Dictionary<string, Action<MailData>> Methods = new(StringComparer.Ordinal);

    // static MailData()
    // {
    //     foreach (var method in AccessTools.GetDeclaredMethods(typeof(Mailbox)))
    //     {
    //         if (method.Name.EndsWith("Details", StringComparison.Ordinal))
    //             Methods[method.Name] = Helpers.CompileAction<MailData>(method);
    //     }
    // }

    // protected override bool SerialiseName => true;

    [JsonRequired] public string Id;

#if !UNITY
    [JsonProperty] public double? UnlockAfter;

    [JsonIgnore] public bool Sent;
    [JsonIgnore] public bool Read;

    private Func<double, bool>? _unlockFuncAnd;
    public event Func<double, bool> UnlockFuncAnd
    {
        add
        {
            _unlockFuncAnd += value;
            UpdateAndCache();
        }
        remove
        {
            _unlockFuncAnd -= value;
            UpdateAndCache();
        }
    }

    private Func<double, bool>[] andSubscribers = [];
    private bool noAndSubscribers = true;

    private void UpdateAndCache()
    {
        if (_unlockFuncAnd == null)
        {
            andSubscribers = [];
            noAndSubscribers = true;
            return;
        }

        andSubscribers = [.. _unlockFuncAnd.GetInvocationList().Cast<Func<double, bool>>()];
        noAndSubscribers = andSubscribers.Length == 0;
    }

    // private Func<double, bool>? _unlockFuncOr;
    // public event Func<double, bool> UnlockFuncOr
    // {
    //     add
    //     {
    //         _unlockFuncOr += value;
    //         UpdateOrCache();
    //     }
    //     remove
    //     {
    //         _unlockFuncOr -= value;
    //         UpdateOrCache();
    //     }
    // }

    // private Func<double, bool>[] orSubscribers = [];
    // private bool noOrSubscribers = true;

    // private void UpdateOrCache()
    // {
    //     if (_unlockFuncOr == null)
    //     {
    //         orSubscribers = [];
    //         noOrSubscribers = true;
    //         return;
    //     }

    //     orSubscribers = [.. _unlockFuncOr.GetInvocationList().Cast<Func<double, bool>>()];
    //     noOrSubscribers = orSubscribers.Length == 0;
    // }

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Id = reader.ReadString()!;
        UnlockAfter = reader.ReadNullableDouble();
    }

    // public override void OnDeserialise()
    // {
    //     if (Methods.TryGetValue("Init" + Name.Replace(" ", string.Empty) + "Details", out var method))
    //         method.Invoke(this);
    // }

    public bool ShouldUnlock(double time)
    {
        if (Sent || Read || UnlockAfter.GetValueOrDefault() > time)
            return false;

        // if (!noOrSubscribers)
        // {
        //     for (var i = 0; i < orSubscribers.Length; i++)
        //     {
        //         if (orSubscribers[i](time))
        //             return true;
        //     }
        // }

        if (noAndSubscribers)
            return true;

        for (var i = 0; i < andSubscribers.Length; i++)
        {
            if (!andSubscribers[i](time))
                return false;
        }

        return true;
    }
#else
    [JsonProperty] public Optional<double> UnlockAfter;

    public override void FindStrings(StringPooler pooler)
    {
        base.FindStrings(pooler);
        pooler.PoolString(Id);
    }

    public override void WriteTo(DataWriter writer)
    {
        base.WriteTo(writer);
        writer.WriteString(Id);
        writer.WriteNullableDouble(UnlockAfter);
    }
#endif
}