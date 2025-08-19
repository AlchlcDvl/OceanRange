using OceanRange.Patches;

namespace OceanRange.Saves;

public sealed class MailSaveData : ISaveData
{
    public bool Deprecated => false;

    public ulong[] Write(out byte padding)
    {
        var writer = new SaveWriter();
        writer.Write(Mailbox.Mail.Length);

        foreach (var mail in Mailbox.Mail)
        {
            writer.Write(mail.Read);
            writer.Write(mail.Sent);

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
        var length = reader.ReadInt32();

        for (var i = 0; i < length; i++)
        {
            var mail = Mailbox.Mail[i];
            mail.Read = reader.ReadBoolean();
            mail.Sent = reader.ReadBoolean();
        }
    }
}

public sealed class GordoSaveData : ISaveData
{
    public bool Deprecated => false;

    public static Dictionary<IdentifiableId, CustomSlimeData> Lookup;

    public ulong[] Write(out byte padding)
    {
        var writer = new SaveWriter();
        writer.Write(Lookup.Count);

        foreach (var (id, slimeData) in Lookup)
        {
            writer.Write(id.ToString());
            writer.Write(slimeData.IsPopped);

            if (!EnsureAutoSaveDirectorData.IsAutoSave)
                slimeData.IsPopped = false;
        }

        return writer.ToArray(out padding);
    }

    public void Read(ulong[] data, byte padding)
    {
        var reader = new SaveReader(data, padding);
        var count = reader.ReadInt32();

        while (count-- > 0)
        {
            var id = Helpers.ParseEnum<IdentifiableId>(reader.ReadString());
            var flag = reader.ReadBoolean();

            if (Lookup.TryGetValue(id, out var slimeData))
                slimeData.IsPopped = flag;
        }
    }
}