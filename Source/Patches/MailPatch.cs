namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(TimeDirector), nameof(TimeDirector.LateUpdate))]
public static class FixAndProperlyShowMailPatch
{
    public static void Postfix(TimeDirector __instance)
    {
        var time = __instance.WorldTime();

        foreach (var mail in MailManager.Mail)
        {
            if (mail.UnlockAfter <= time)
                SceneContext.Instance.MailDirector.SendMailIfExists(MailDirector.Type.PERSONAL, mail.Id);
        }
    }
}