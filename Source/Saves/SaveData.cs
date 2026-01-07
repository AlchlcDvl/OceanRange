using OceanRange.Patches;

namespace OceanRange.Saves;

public sealed class MailSaveData : ISaveData
{
    public bool Deprecated => false;

    public ulong[] Write(out byte padding)
    {
        var writer = new SaveWriter();
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
        var reader = new SaveReader(data, padding);
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

public sealed class GordoSaveDataV01 : ISaveData
{
    public bool Deprecated => true;

    public ulong[] Write(out byte padding)
    {
        var writer = new SaveWriter();
        writer.WriteInt(GordoSaveDataV02.Lookup.Count);

        foreach (var id in GordoSaveDataV02.Lookup.Keys)
        {
            writer.WriteString(id.ToString());
            writer.WriteBool(GordoSaveDataV02.Lookup[id]);

            if (!EnsureAutoSaveDirectorData.IsAutoSave)
                GordoSaveDataV02.Lookup[id] = false;
        }

        return writer.ToArray(out padding);
    }

    public void Read(ulong[] data, byte padding)
    {
        var reader = new SaveReader(data, padding);
        var count = reader.ReadInt();

        while (count-- > 0)
        {
            var id = Helpers.ParseEnum<IdentifiableId>(reader.ReadString());
            var flag = reader.ReadBool();

            if (GordoSaveDataV02.Lookup.ContainsKey(id))
                GordoSaveDataV02.Lookup[id] = flag;
        }
    }
}

public sealed class GordoSaveDataV02 : ISaveData
{
    public bool Deprecated => false;

    public static readonly Dictionary<IdentifiableId, bool> Lookup = new(Identifiable.idComparer);

    public ulong[] Write(out byte padding)
    {
        var writer = new SaveWriter();
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
        var reader = new SaveReader(data, padding);
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