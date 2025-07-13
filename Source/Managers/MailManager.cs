namespace TheOceanRange.Managers;

public static class MailManager
{
    public static readonly List<CustomMailData> Mail = [];

    public static void PreLoadMailData()
    {
        Mail.AddRange(AssetManager.GetJson<CustomMailData[]>("mailbox"));
        Mail.ForEach(PreLoadMail);

        AssetManager.UnloadAsset<JsonAsset>("mailbox");
    }

    private static void PreLoadMail(CustomMailData mailData) => MailRegistry.RegisterMailEntry(new MailRegistry.MailEntry(mailData.Id)
        .SetSubjectTranslation(mailData.Title)
        .SetFromTranslation(mailData.From)
        .SetBodyTranslation(mailData.Body));
}