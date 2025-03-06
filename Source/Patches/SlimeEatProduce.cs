namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(SlimeEat), "Produce")]
public static class SlimeEatProduce
{
    public static void Prefix(SlimeEat __instance, ref int count, GameObject produces)
    {
        if (!__instance.GetComponent<RosaBehaviour>())
            return;

        Collider val = null;
        var flag = false;
        Bounds bounds;

        foreach (var allCorral in CorralRegion.)
        {
            bounds = ((Component)allCorral).GetComponent<Collider>().bounds;
            if (((Bounds)(ref bounds)).Contains(((Component)__instance).transform.position))
            {
                val = ((Component)allCorral).GetComponent<Collider>();
                flag = true;
                break;
            }
        }

        if (!flag)
        {
            count = 1;
            return;
        }

        int num = 0;
        foreach (RosaBehaviour item in RosaBehaviour.All)
        {
            bounds = val.bounds;
            if (((Bounds)(ref bounds)).Contains(((Component)item).transform.position))
            {
                num++;
            }
        }
        count = num;
    }
}
