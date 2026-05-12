// ReSharper disable UnassignedField.Global

// using System.Reflection;

namespace OceanRange.Data;

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

    [JsonRequired] public string Id;
    public double? UnlockAfter;

#if !UNITY
    [JsonIgnore] public bool Sent;
    [JsonIgnore] public bool Read;

    private Func<double, bool> _unlockFuncAnd;
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

    private Func<double, bool>[] AndSubscribers = [];
    private bool NoAndSubscribers = true;

    private void UpdateAndCache()
    {
        if (_unlockFuncAnd == null)
        {
            AndSubscribers = [];
            NoAndSubscribers = true;
            return;
        }

        AndSubscribers = [.. _unlockFuncAnd.GetInvocationList().Cast<Func<double, bool>>()];
        NoAndSubscribers = AndSubscribers.Length == 0;
    }

    // private Func<double, bool> _unlockFuncOr;
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

    // private Func<double, bool>[] OrSubscribers = [];
    // private bool NoOrSubscribers = true;

    // private void UpdateOrCache()
    // {
    //     if (_unlockFuncOr == null)
    //     {
    //         OrSubscribers = [];
    //         NoOrSubscribers = true;
    //         return;
    //     }

    //     OrSubscribers = [.. _unlockFuncOr.GetInvocationList().Cast<Func<double, bool>>()];
    //     NoOrSubscribers = OrSubscribers.Length == 0;
    // }

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Id = reader.ReadString();
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

        // if (!NoOrSubscribers)
        // {
        //     for (var i = 0; i < OrSubscribers.Length; i++)
        //     {
        //         if (OrSubscribers[i](time))
        //             return true;
        //     }
        // }

        if (NoAndSubscribers)
            return true;

        for (var i = 0; i < AndSubscribers.Length; i++)
        {
            if (!AndSubscribers[i](time))
                return false;
        }

        return true;
    }
#else
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
#endif
}