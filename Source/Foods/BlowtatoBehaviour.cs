namespace OceanRange.Foods;

public sealed class BlowtatoBehaviour : CollidableActorBehaviour, Collidable
{
    public static GameObject ExplodeFX;

    private const float ExplodePower = 200f;
    private const float ExplodeRadius = 5f;
    private const float MinPlayerDamage = 5f;
    private const float MaxPlayerDamage = 10f;
    private const float MinimumExplosionVelocity = 17.5f;

    public override void Awake()
    {
        base.Awake();
        collisionBehaviour = this.EnsureComponent<CollisionAggregator>();
    }

    public void ProcessCollisionEnter(Collision col)
    {
        if (col.relativeVelocity.magnitude < MinimumExplosionVelocity)
            return;

        if (ExplodeFX)
        {
            var fx = SpawnAndPlayFX(ExplodeFX, transform.position, transform.rotation);
            fx.transform.localScale /= 6f;

            if (fx.TryGetComponent<ParticleSystem>(out var particleSys))
                SetScale(particleSys);

            foreach (var comp in fx.GetComponentsInChildren<ParticleSystem>())
                SetScale(comp);
        }

        PhysicsUtil.Explode(gameObject, ExplodeRadius, ExplodePower, MinPlayerDamage, MaxPlayerDamage);
    }

    public void ProcessCollisionExit(Collision col) { }

    private static void SetScale(ParticleSystem particleSystem)
    {
#pragma warning disable IDE0059 // Unnecessary assignment of a value
        var main = particleSystem.main;
        main.startSizeMultiplier /= 6f;
#pragma warning restore IDE0059 // Unnecessary assignment of a value
    }
}