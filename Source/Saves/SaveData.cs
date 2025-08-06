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

    private static readonly Func<CustomSlimeData, bool> HasGordoDel = HasGordo;

    public ulong[] Write(out byte padding)
    {
        var writer = new SaveWriter();
        var gordos = SlimeManager.Slimes.Where(HasGordoDel).ToArray();
        writer.Write(gordos.Length);

        foreach (var gordo in gordos)
        {
            writer.Write((int)gordo.GordoId);
            writer.Write(gordo.IsPopped);
            gordo.IsPopped = false;
        }

        return writer.ToArray(out padding);
    }

    public void Read(ulong[] data, byte padding)
    {
        var reader = new SaveReader(data, padding);
        var count = reader.ReadInt32();

        while (count-- > 0)
        {
            var id = (IdentifiableId)reader.ReadInt32();
            var gordo = Array.Find(SlimeManager.Slimes, x => x.GordoId == id);
            gordo.IsPopped = reader.ReadBoolean();
        }
    }

    private static bool HasGordo(CustomSlimeData slimeData) => slimeData.HasGordo;
}