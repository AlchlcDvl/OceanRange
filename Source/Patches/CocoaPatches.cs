namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(WeaponVacuum), nameof(WeaponVacuum.ExpelHeld))]
public static class CocoDamageRegisterPatch
{
    public static bool Prefix(WeaponVacuum __instance)
    {
        var ray = new Ray(__instance.vacOrigin.transform.position, __instance.vacOrigin.transform.up);
        var origin = ray.origin;
        var vel = (ray.direction * __instance.ejectSpeed) + __instance.GetComponentInParent<vp_FPController>().Velocity;
        origin = __instance.EnsureNotShootingIntoRock(origin, ray, __instance.heldRad, ref vel);
        var held = __instance.held;
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
        __instance.held = null;
        __instance.SetHeldRad(0f);

        if (held.TryGetComponent<Identifiable>(out var component4) && Identifiable.IsTarr(component4.id))
        {
            var val = (int)Math.Floor((__instance.timeDir.WorldTime() -  __instance.heldStartTime) * 0.01666666753590107);
            __instance.achieveDir.MaybeUpdateMaxStat(AchievementsDirector.IntStat.EXTENDED_TARR_HOLD, val);
        }

        __instance.heldStartTime = double.NaN;
        __instance.launchedHeld = true;
        __instance.ShootEffect();
        return false;
    }
}