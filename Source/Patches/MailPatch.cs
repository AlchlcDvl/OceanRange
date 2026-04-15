namespace OceanRange.Patches;

[HarmonyPatch(typeof(TimeDirector), nameof(TimeDirector.LateUpdate))]
public static class FixAndProperlyShowMailPatch
{
    public static bool IsLoaded { private get; set; }

    public static void Postfix(TimeDirector __instance)
    {
        if (!IsLoaded || Time.frameCount % 15 != 0)
            return;

        var time = __instance.WorldTime();

        foreach (var mail in Mailbox.Mail)
        {
            if (mail.ShouldUnlock(time))
                mail.Sent = SceneContext.Instance.MailDirector.SendMailIfExists(MailDirector.Type.PERSONAL, mail.Id);
        }
    }
}