namespace OceanRange.Foods;

public sealed class BlowtatoBehaviour : CollidableActorBehaviour, Collidable
{
    public static GameObject ExplodeFX;

    private const float ExplodePower = 200f;
    private const float ExplodeRadius = 5f;
    private const float MinPlayerDamage = 5f;
    private const float MaxPlayerDamage = 10f;
    private const float MinimumExplosionVelocity = 15f;

    public override void Awake()
    {
        base.Awake();
        collisionBehaviour = this.EnsureComponent<CollisionAggregator>();
    }

    public void ProcessCollisionEnter(Collision col)
    {
        if (col.relativeVelocity.magnitude < MinimumExplosionVelocity)
            return;

        if (ExplodeFX != null)
            SpawnAndPlayFX(ExplodeFX, transform.position, transform.rotation);

        PhysicsUtil.Explode(gameObject, ExplodeRadius, ExplodePower, MinPlayerDamage, MaxPlayerDamage);
    }

    public void ProcessCollisionExit(Collision col) { }
}