namespace OceanRange.Slimes;

public sealed class CocoBehaviour : MonoBehaviour
{
    private DamagePlayerOnTouch damage;
    private Damageable damageable;

    public void Awake()
    {
        damage = GetComponent<DamagePlayerOnTouch>();
        damageable = gameObject.GetInterfaceComponent<Damageable>();
    }

    public void OnControllerCollision(GameObject gameObj)
    {
        if (Time.time >= damage.nextTime && transform.position.y > gameObj.transform.position.y + 1.25f && damageable.Damage(damage.damagePerTouch, gameObject))
            DeathHandler.Kill(gameObj, DeathHandler.Source.SLIME_DAMAGE_PLAYER_ON_TOUCH, gameObject, "CocoBehaviour.TryToDamage");

        damage.nextTime = Time.time + damage.repeatTime;
    }
}