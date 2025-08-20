namespace OceanRange.Managers;

public static class Mailbox
{
    public static CustomMailData[] Mail;

#if DEBUG
    [TimeDiagnostic("Mail Preload")]
#endif
    public static void PreLoadMailData()
    {
        Mail = AssetManager.GetJsonArray<CustomMailData>("mailbox");
        Array.ForEach(Mail, PreLoadMail);
    }

    private static void PreLoadMail(CustomMailData mailData) => MailRegistry.RegisterMailEntry(new MailRegistry.MailEntry(mailData.Id)
        .SetSubjectTranslation(mailData.Title)
        .SetFromTranslation(mailData.From)
        .SetBodyTranslation(mailData.Body)
        .SetReadCallback((_, _) => mailData.Read = true));

    public static void InitLisaIntroDetails(CustomMailData mailData) => mailData.UnlockFuncAnd += _ => SceneContext.Instance.ProgressDirector.HasProgress(Ids.EXCHANGE_LISA);
}