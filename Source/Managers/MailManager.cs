namespace OceanRange.Managers;

public static class MailManager
{
    public static CustomMailData[] Mail;

#if DEBUG
    [TimeDiagnostic("Mail Preload")]
#endif
    public static void PreLoadMailData()
    {
        Mail = AssetManager.GetJson<CustomMailData[]>("mailbox");
        AssetManager.UnloadAsset<JsonAsset>("mailbox");

        foreach (var mail in Mail)
            PreLoadMail(mail);
    }

    private static void PreLoadMail(CustomMailData mailData) => MailRegistry.RegisterMailEntry(new MailRegistry.MailEntry(mailData.Id)
        .SetSubjectTranslation(mailData.Title)
        .SetFromTranslation(mailData.From)
        .SetBodyTranslation(mailData.Body)
        .SetReadCallback((_, _) => mailData.Read = true));
}