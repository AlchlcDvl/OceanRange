namespace OceanRange.Patches;

[HarmonyPatch(typeof(TimeDirector), nameof(TimeDirector.LateUpdate))]
public static class FixAndProperlyShowMailPatch
{
    public static bool IsLoaded;

    public static void Postfix(TimeDirector __instance)
    {
        if (!IsLoaded)
            return;

        var time = __instance.WorldTime();

        foreach (var mail in Mailbox.Mail)
        {
            if (mail.Sent || mail.Read || !mail.ShouldUnlock(time))
                continue;

            SceneContext.Instance.MailDirector.SendMailIfExists(MailDirector.Type.PERSONAL, mail.Id);
            mail.Sent = true;
        }
    }
}