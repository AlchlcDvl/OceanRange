using OceanRange.Patches;

namespace OceanRange.Saves;

public sealed class MailSaveData : ISaveData
{
    public bool Deprecated => false;

    public ulong[] Write(out byte padding)
    {
        using var writer = new SaveWriter();
        writer.WriteInt(Mailbox.Mail.Length);

        foreach (var mail in Mailbox.Mail)
        {
            writer.WriteBool(mail.Read);

            if (!mail.Read)
                writer.WriteBool(mail.Sent);

            if (EnsureAutoSaveDirectorData.IsAutoSave)
                continue;

            mail.Read = false;
            mail.Sent = false;
        }

        return writer.ToArray(out padding);
    }

    public void Read(ulong[] data, byte padding)
    {
        using var reader = new SaveReader(data, padding);
        var length = reader.ReadInt();

        for (var i = 0; i < length; i++)
        {
            var mail = Mailbox.Mail[i];
            mail.Read = reader.ReadBool();

            if (!mail.Read)
                mail.Sent = reader.ReadBool();
        }
    }
}

public sealed class GordoSaveData : ISaveData
{
    public bool Deprecated => false;

    public static readonly Dictionary<IdentifiableId, bool> Lookup = new(Identifiable.idComparer);

    public ulong[] Write(out byte padding)
    {
        using var writer = new SaveWriter();
        writer.WriteInt(Lookup.Count);

        foreach (var id in Lookup.Keys)
        {
            writer.WriteEnum(id);
            writer.WriteBool(Lookup[id]);

            if (!EnsureAutoSaveDirectorData.IsAutoSave)
                Lookup[id] = false;
        }

        return writer.ToArray(out padding);
    }

    public void Read(ulong[] data, byte padding)
    {
        using var reader = new SaveReader(data, padding);
        var count = reader.ReadInt();

        while (count-- > 0)
        {
            var id = reader.ReadEnum<IdentifiableId>();
            var flag = reader.ReadBool();

            if (Lookup.ContainsKey(id))
                Lookup[id] = flag;
        }
    }
}