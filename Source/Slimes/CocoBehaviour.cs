namespace OceanRange.Slimes;

public sealed class CocoBehaviour : MonoBehaviour
{
    private DamagePlayerOnTouch Damage;

    public void Awake() => Damage = GetComponent<DamagePlayerOnTouch>();

    public void OnControllerCollision(GameObject gameObj)
    {
        if (Time.time >= Damage.nextTime && transform.position.y > gameObj.transform.position.y + 1.25f && gameObj.GetInterfaceComponent<Damageable>().Damage(Damage.damagePerTouch, gameObject))
            DeathHandler.Kill(gameObj, DeathHandler.Source.SLIME_DAMAGE_PLAYER_ON_TOUCH, gameObject, "CocoBehaviour.TryToDamage");

        Damage.nextTime = Time.time + Damage.repeatTime;
    }
}