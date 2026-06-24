#if !UNITY
namespace OceanRange.Data;

public sealed partial class MailData
{
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

    public override void ReadFrom(DataReader reader)
    {
        base.ReadFrom(reader);
        Id = reader.ReadString()!;
        UnlockAfter = reader.ReadNullableDouble();
    }

    public bool ShouldUnlock(double time)
    {
        if (Sent || Read || UnlockAfter.GetValueOrDefault() > time)
            return false;

        if (noAndSubscribers)
            return true;

        for (var i = 0; i < andSubscribers.Length; i++)
        {
            if (!andSubscribers[i](time))
                return false;
        }

        return true;
    }
}
#endif
