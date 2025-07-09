using System.Reflection;

namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(WeaponVacuum), "ExpelHeld")]
public static class CocoDamageRegisterPatch
{
    private static readonly MethodInfo EnsureNotShootingIntoRock = AccessTools.Method(typeof(WeaponVacuum), "EnsureNotShootingIntoRock");

    public static bool Prefix(WeaponVacuum __instance)
    {
        var componentInParent = __instance.GetComponentInParent<vp_FPController>();
        var ray = new Ray(__instance.vacOrigin.transform.position, __instance.vacOrigin.transform.up);
        var origin = ray.origin;
        var vel = (ray.direction * __instance.ejectSpeed) + componentInParent.Velocity;
        var array = new object[] {origin, ray, __instance.GetPrivateField<float>("heldRad"), vel};
        origin = (Vector3)EnsureNotShootingIntoRock.Invoke(__instance, array);
        vel = (Vector3)array[3];
        var held = __instance.GetPrivateField<GameObject>("held");
        held.transform.position = origin;
        held.GetComponent<Rigidbody>().velocity = vel;

        if (held.TryGetComponent<Vacuumable>(out var component))
        {
            component.release();
            component.Launch(0);

            if (held.TryGetComponent<SlimeEat>(out var component2))
                component2.CancelChomp(SceneContext.Instance.Player);
        }

        if (held.TryGetComponent<DamagePlayerOnTouch>(out var component3))
            component3.ResetDamageAmnesty();

        if (held.TryGetComponent<CocoaBehaviour>(out var component5))
            component5.ResetDamageAmnesty();

        __instance.lockJoint.connectedBody = null;
        __instance.SetField("held", null);
        __instance.InvokeMethod("SetHeldRad", 0f);

        if (held.TryGetComponent<Identifiable>(out var component4) && Identifiable.IsTarr(component4.id))
        {
            var val = (int)Math.Floor((__instance.GetPrivateField<TimeDirector>("timeDir").WorldTime() -  __instance.GetPrivateField<double>("heldStartTime")) * 0.01666666753590107);
            __instance.GetPrivateField<AchievementsDirector>("achieveDir").MaybeUpdateMaxStat(AchievementsDirector.IntStat.EXTENDED_TARR_HOLD, val);
        }

        __instance.SetField("heldStartTime", double.NaN);
        __instance.SetField("launchedHeld", true);
        __instance.InvokeMethod("ShootEffect");
        return false;
    }
}