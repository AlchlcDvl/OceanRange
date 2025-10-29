namespace OceanRange.Patches;

[HarmonyPatch(typeof(TimeDirector), nameof(TimeDirector.LateUpdate)), UsedImplicitly]
public static class FixAndProperlyShowMailPatch
{
    public static bool IsLoaded;

    [UsedImplicitly]
    public static void Postfix(TimeDirector __instance)
    {
        if (!IsLoaded)
            return;

        var time = __instance.WorldTime();

        foreach (var mail in Mailbox.Mail)
        {
            if (!mail.ShouldUnlock(time))
                continue;

            mail.Sent = true;
            SceneContext.Instance.MailDirector.SendMailIfExists(MailDirector.Type.PERSONAL, mail.Id);
        }
    }
}