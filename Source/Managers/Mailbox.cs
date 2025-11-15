namespace OceanRange.Managers;

public static class Mailbox
{
    public static MailData[] Mail;
    public static Dictionary<string, MailData> MailMap;

#if DEBUG
    [TimeDiagnostic("Mail Preload")]
#endif
    public static void PreloadMailData()
    {
        Mail = Inventory.GetJsonArray<MailData>("mailbox");
        MailMap = Mail.ToDictionary(x => x.Id);
        Array.ForEach(Mail, PreloadMail);
    }

    private static void PreloadMail(MailData mailData) => MailRegistry.RegisterMailEntry(new MailRegistry.MailEntry(mailData.Id).SetReadCallback((_, _) => mailData.Read = true));
}