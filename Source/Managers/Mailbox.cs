namespace OceanRange.Managers;

public static class Mailbox
{
    public static MailData[] Mail;

#if DEBUG
    [TimeDiagnostic("Mail Preload")]
#endif
    public static void PreloadMailData()
    {
        Mail = Inventory.GetJsonArray<MailData>("mailbox");
        Array.ForEach(Mail, PreloadMail);
    }

    private static void PreloadMail(MailData mailData) => MailRegistry.RegisterMailEntry(new MailRegistry.MailEntry(mailData.Id)
        .SetSubjectTranslation(mailData.Title)
        .SetFromTranslation(mailData.From)
        .SetBodyTranslation(mailData.Body)
        .SetReadCallback((_, _) => mailData.Read = true));

    [UsedImplicitly]
    public static void InitLisaIntroDetails(MailData mailData) => mailData.UnlockFuncAnd += _ => SceneContext.Instance.ProgressDirector.HasProgress(Ids.EXCHANGE_LISA);
}