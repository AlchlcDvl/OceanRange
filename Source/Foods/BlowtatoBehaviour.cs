namespace OceanRange.Foods;

public sealed class BlowtatoBehaviour : CollidableActorBehaviour, Collidable
{
    public static GameObject ExplodeFX; // Set on mod load after fetching the prefab from the game

    private const float ExplodePower = 200f;
    private const float ExplodeRadius = 5f;
    private const float MinPlayerDamage = 5f;
    private const float MaxPlayerDamage = 10f;
    private const float MinimumExplosionVelocity = 17.5f;
    private const float ScaleDownFactor = 6f;

    public override void Awake()
    {
        base.Awake();
        collisionBehaviour = gameObject.EnsureComponent<CollisionAggregator>();
    }

    public void ProcessCollisionEnter(Collision col)
    {
        if (col.relativeVelocity.magnitude < MinimumExplosionVelocity)
            return;

        if (ExplodeFX)
        {
            var fx = SpawnAndPlayFX(ExplodeFX, transform.position, transform.rotation);
            fx.transform.localScale /= ScaleDownFactor;

            foreach (var comp in fx.GetComponentsInChildren<ParticleSystem>())
                SetScale(comp);
        }

        PhysicsUtil.Explode(gameObject, ExplodeRadius, ExplodePower, MinPlayerDamage, MaxPlayerDamage);
    }

    public void ProcessCollisionExit(Collision col) { }

    private static void SetScale(ParticleSystem particleSystem)
    {
        var main = particleSystem.main;
        main.startSizeMultiplier /= ScaleDownFactor;
    }
}