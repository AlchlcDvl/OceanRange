namespace TheOceanRange.Slimes;

// Had to recreate DamagePlyerOnTouch because using Rock slimes as a base just no longer allowed Coco slimes to move
public sealed class CocoBehaviour : SRBehaviour, ControllerCollisionListener
{
    public const int DamagePerTouch = 10;
    public const float RepeatTime = 1f;

    private bool Blocked;
    private float NextTime;

    public void Awake() => ResetDamageAmnesty();

    public void ResetDamageAmnesty() => NextTime = Time.time + 0.1f;

    public void OnControllerCollision(GameObject gameObj)
    {
        if (Time.time >= NextTime)
            TryToDamage(gameObj);
    }

    public void OnCollisionEnter(Collision col)
    {
        if (Time.time >= NextTime && col.gameObject == SRSingleton<SceneContext>.Instance.Player)
            TryToDamage(col.gameObject);
    }

    public void SetBlocked(bool blocked) => Blocked = blocked;

    private void TryToDamage(GameObject gameObj)
    {
        if (!Blocked && transform.position.y > gameObj.transform.position.y + 1 && gameObj.GetInterfaceComponent<Damageable>().Damage(DamagePerTouch, gameObject))
            DeathHandler.Kill(gameObj, DeathHandler.Source.SLIME_DAMAGE_PLAYER_ON_TOUCH, gameObject, "CocoBehaviour.TryToDamage");

        NextTime = Time.time + RepeatTime;
    }
}