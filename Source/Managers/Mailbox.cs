namespace OceanRange.Managers;

public static class Mailbox
{
    public static MailData[] Mail;

#if DEBUG
    [TimeDiagnostic("Mail Preload")]
#endif
    public static void PreloadMailData()
    {
        Mail = Inventory.GetModData<Starmail>("mailbox").Mail;
        Array.ForEach(Mail, PreloadMail);
    }

    private static void PreloadMail(MailData mailData) => MailRegistry.RegisterMailEntry(new MailRegistry.MailEntry(mailData.Id).SetReadCallback((_, _) => mailData.Read = true));

    [UsedImplicitly]
    public static void InitLisaIntroDetails(MailData mailData) => mailData.UnlockFuncAnd += _ => SceneContext.Instance.ProgressDirector.HasProgress(Ids.EXCHANGE_LISA);
}