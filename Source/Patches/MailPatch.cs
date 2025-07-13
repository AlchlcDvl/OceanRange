namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(TimeDirector), nameof(TimeDirector.LateUpdate))]
public static class FixAndProperlyShowMailPatch
{
    public static void Postfix(TimeDirector __instance)
    {
        foreach (var mail in MailManager.Mail)
        {
            if (__instance.WorldTime() <= mail.UnlockAfter)
                SceneContext.Instance.MailDirector.SendMailIfExists(MailDirector.Type.PERSONAL, mail.Id);
        }
    }
}