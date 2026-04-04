namespace OceanRange.Managers;

[Manager(ManagerType.Mailbox)]
public static class Mailbox
{
    public static MailData[] Mail;
    public static Dictionary<string, MailData> MailMap;

#if DEBUG
    [TimeDiagnostic("Mail Preload")]
#endif
    [PreloadMethod]
    public static void PreloadMailData()
    {
        Mail = Inventory.GetJsonArray<MailData>("mailbox");

        MailMap = new(Mail.Length);

        foreach (var item in Mail)
        {
            MailMap.Add(item.Id, item);
            PreloadMail(item);
        }
    }

    private static void PreloadMail(MailData mailData) => MailRegistry.RegisterMailEntry(new MailRegistry.MailEntry(mailData.Id).SetReadCallback((_, _) => mailData.Read = true));
}