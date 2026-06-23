namespace OceanRange.Slimes;

// Had to recreate DamagePlayerOnTouch because using Rock slimes as a base just no longer allowed Coco slimes to move
// Az from the future here; attempting to add my own hook did not work, as it would just knockout players instead of damaging them
public sealed class CocoBehaviour : SRBehaviour, ControllerCollisionListener
{
    private const int DamagePerTouch = 10;
    private const float RepeatTime = 1f;

    private float nextTime;

    public void Awake() => ResetDamageAmnesty();

    public void ResetDamageAmnesty() => nextTime = Time.time + 0.1f;

    public void OnControllerCollision(GameObject gameObj)
    {
        if (Time.time >= nextTime && gameObj == SceneContext.Instance.Player && transform.position.y >= gameObj.transform.position.y + 1.25f &&
            gameObj.GetInterfaceComponent<Damageable>().Damage(DamagePerTouch, gameObject))
        {
            DeathHandler.Kill(gameObj, DeathHandler.Source.SLIME_DAMAGE_PLAYER_ON_TOUCH, gameObject, "CocoBehaviour.TryToDamage");
        }

        nextTime = Time.time + RepeatTime;
    }
}