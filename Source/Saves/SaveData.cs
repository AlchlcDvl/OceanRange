using OceanRange.Patches;

namespace OceanRange.Saves;

public sealed class MailSaveData : ISaveData
{
    public bool Deprecated => false;

    public ulong[] Write(out byte padding)
    {
        var writer = new SaveWriter();
        writer.Write(MailManager.Mail.Length);

        foreach (var mail in MailManager.Mail)
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
            var mail = MailManager.Mail[i];
            mail.Read = reader.ReadBoolean();
            mail.Sent = reader.ReadBoolean();
        }
    }
}

public sealed class GordoSaveData : ISaveData
{
    public bool Deprecated => false;

    private static Dictionary<IdentifiableId, CustomSlimeData> Lookup;

    public ulong[] Write(out byte padding)
    {
        var writer = new SaveWriter();
        Lookup ??= SlimeManager.Slimes.Where(x => x.HasGordo && x.NaturalGordoSpawn).ToDictionary(x => x.GordoId);
        writer.Write(Lookup.Count);

        foreach (var (id, slimeData) in Lookup)
        {
            writer.Write((int)id);
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
        Lookup ??= SlimeManager.Slimes.Where(x => x.HasGordo && x.NaturalGordoSpawn).ToDictionary(x => x.GordoId);

        while (count-- > 0)
        {
            var id = (IdentifiableId)reader.ReadInt32();
            var flag = reader.ReadBoolean();

            if (Lookup.TryGetValue(id, out var slimeData))
                slimeData.IsPopped = flag;
        }
    }
}