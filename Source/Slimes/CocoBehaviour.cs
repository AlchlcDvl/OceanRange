namespace OceanRange.Slimes;

// Had to recreate DamagePlayerOnTouch because using Rock slimes as a base just no longer allowed Coco slimes to move
public sealed class CocoBehaviour : SRBehaviour, ControllerCollisionListener
{
    private const int DamagePerTouch = 10;
    private const float RepeatTime = 1f;

    private float NextTime;

    public void Awake() => ResetDamageAmnesty();

    public void ResetDamageAmnesty() => NextTime = Time.time + 0.1f;

    public void OnControllerCollision(GameObject gameObj)
    {
        if (Time.time >= NextTime && transform.position.y > gameObj.transform.position.y + 1.25f && gameObj.GetInterfaceComponent<Damageable>().Damage(DamagePerTouch, gameObject))
            DeathHandler.Kill(gameObj, DeathHandler.Source.SLIME_DAMAGE_PLAYER_ON_TOUCH, gameObject, "CocoBehaviour.TryToDamage");

        NextTime = Time.time + RepeatTime;
    }
}