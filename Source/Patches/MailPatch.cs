namespace OceanRange.Patches;

[HarmonyPatch(typeof(TimeDirector), nameof(TimeDirector.LateUpdate))]
public static class FixAndProperlyShowMailPatch
{
    public static bool IsLoaded { set => _isLoaded = value; }

    private static bool _isLoaded;

    public static void Postfix(TimeDirector __instance)
    {
        if (!_isLoaded || Time.frameCount % 15 != 0)
            return;

        var time = __instance.WorldTime();

        foreach (var mail in Mailbox.Mail)
        {
            if (mail.ShouldUnlock(time))
                mail.Sent = SceneContext.Instance.MailDirector.SendMailIfExists(MailDirector.Type.PERSONAL, mail.Id);
        }
    }
}