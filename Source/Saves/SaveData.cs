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
            mail.Sent = mail.Read || reader.ReadBool();
        }
    }
}

public sealed class GordoSaveDataV01 : ISaveData
{
    public bool Deprecated => true;

    public ulong[] Write(out byte padding)
    {
        using var writer = new SaveWriter();
        writer.WriteInt(GordoSaveDataV02.Lookup.Count);

        foreach (var (id, flag) in GordoSaveDataV02.Lookup)
        {
            writer.WriteEnum(id);
            writer.WriteBool(flag.IsPopped);

            if (!EnsureAutoSaveDirectorData.IsAutoSave)
                flag.IsPopped = false;
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

            if (GordoSaveDataV02.Lookup.TryGetValue(id, out var value))
                value.IsPopped = flag;
        }
    }
}

public sealed class GordoSaveDataV02 : ISaveData
{
    public bool Deprecated => false;

    private static readonly Dictionary<byte, IdentifiableId> IdToIdentifier = [];
    public static readonly Dictionary<IdentifiableId, GordoData> Lookup = new(Identifiable.idComparer);

    public ulong[] Write(out byte padding)
    {
        using var writer = new SaveWriter();
        writer.WriteByte((byte)Lookup.Count);

        foreach (var data in Lookup.Values)
        {
            writer.WriteBool(data.IsPopped);
            writer.WriteByte(data.Identifier);

            if (!EnsureAutoSaveDirectorData.IsAutoSave)
                data.IsPopped = false;
        }

        return writer.ToArray(out padding);
    }

    public void Read(ulong[] data, byte padding)
    {
        using var reader = new SaveReader(data, padding);
        var count = reader.ReadByte();

        while (count-- > 0)
        {
            var flag = reader.ReadBool();
            var identifier = reader.ReadByte();

            if (IdToIdentifier.TryGetValue(identifier, out var id) && Lookup.TryGetValue(id, out var value))
                value.IsPopped = flag;
        }
    }

    public static void AddGordo(IdentifiableId id)
    {
        if (!Lookup.ContainsKey(id))
            Lookup[id] = new GordoData { IsPopped = false, Identifier = (byte)Lookup.Count };

        if (!IdToIdentifier.ContainsValue(id))
            IdToIdentifier[Lookup[id].Identifier] = id;
    }

    public sealed class GordoData
    {
        public bool IsPopped;
        public byte Identifier;
    }
}