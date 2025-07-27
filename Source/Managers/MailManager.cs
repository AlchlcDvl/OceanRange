namespace OceanRange.Managers;

public static class MailManager
{
    public static readonly List<CustomMailData> Mail = [];

#if DEBUG
    [TimeDiagnostic("Mail Preload")]
#endif
    public static void PreLoadMailData()
    {
        Mail.AddRange(AssetManager.GetJson<CustomMailData[]>("mailbox"));

        AssetManager.UnloadAsset<JsonAsset>("mailbox");

        Mail.ForEach(PreLoadMail);
    }

    private static void PreLoadMail(CustomMailData mailData) => MailRegistry.RegisterMailEntry(new MailRegistry.MailEntry(mailData.Id)
        .SetSubjectTranslation(mailData.Title)
        .SetFromTranslation(mailData.From)
        .SetBodyTranslation(mailData.Body)
        .SetReadCallback((_, _) => mailData.Read = true));
}