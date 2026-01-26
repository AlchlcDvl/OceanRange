using System.Collections;

namespace OceanRange.Slimes;

// Replicated version of Boom slime's explosion behaviour
public sealed class MineBehaviour : SlimeSubbehaviour, ControllerCollisionListener
{
    private enum ExplodeState : byte
    {
        Idle,
        Preparing,
        Exploding,
        Recovering
    }

    private const float ExplodePower = 900f;
    private const float ExplodeRadius = 10f;
    private const float MinPlayerDamage = 15f;
    private const float MaxPlayerDamage = 45f;
    private const float MaxDelay = 15f;
    private const float MinDelay = 5f;

    public GameObject ExplodeFX;
    public bool IsLargo;

    private float nextPossibleExplode;
    private float nextExplodeDelayTime = MaxDelay;
    private SlimeFaceAnimator sfAnimator;
    private CalmedByWaterSpray calmed;
    private ExplodeIndicatorMarker marker;
    private bool contact;
    private ExplodeState state;

    public override void Awake()
    {
        base.Awake();
        sfAnimator = GetComponent<SlimeFaceAnimator>();
        calmed = GetComponent<CalmedByWaterSpray>();
        marker = GetComponentsInChildren<ExplodeIndicatorMarker>(true)[0];

        if (!TryGetComponent<SlimeAppearanceApplicator>(out var applicator))
            return;

        UpdateFX(applicator.Appearance);
        applicator.OnAppearanceChanged += UpdateFX;
    }

    private void UpdateFX(SlimeAppearance appearance)
    {
        if (appearance)
            ExplodeFX = appearance.ExplosionAppearance.explodeFx;
    }

    public override void OnEnable()
    {
        base.OnEnable();

        if (Time.time + MinDelay > nextPossibleExplode)
            nextPossibleExplode = Math.Max(nextPossibleExplode, Time.time + Randoms.SHARED.GetFloat(MinDelay));
    }

    public override void Start()
    {
        base.Start();
        nextExplodeDelayTime = BoomDelay();
        nextPossibleExplode = Time.time + (nextExplodeDelayTime * Randoms.SHARED.GetInRange(0.25f, 1f));
        marker.SetActive(false);
    }

    public override float Relevancy(bool _) => calmed.IsCalmed() || !contact || state is not ExplodeState.Idle ? 0f : 1f;

    public override void Action() {}

    public override void Selected() => StartCoroutine(DelayedExplosion());

    public void FixedUpdate()
    {
        if (calmed.IsCalmed())
            nextPossibleExplode += Time.fixedDeltaTime;
    }

    private float BoomDelay() => Mathf.Lerp(MinDelay, MaxDelay, Mathf.Clamp01(Randoms.SHARED.GetInRange(-0.1f, 0.1f) + (1f - emotions.GetCurr(SlimeEmotions.Emotion.AGITATION))));

    private IEnumerator DelayedExplosion()
    {
        contact = false;
        state = ExplodeState.Preparing;
        marker.SetActive(true);
        sfAnimator.SetTrigger("triggerGrimace");
        yield return Helpers.Wait(BoomSlimeExplode.EXPLOSION_PREP_TIME);
        marker.SetActive(false);
        state = ExplodeState.Exploding;
        SpawnAndPlayFX(ExplodeFX, transform.position, transform.rotation);
        Explode();
        nextExplodeDelayTime = BoomDelay();
        nextPossibleExplode = Time.time + nextExplodeDelayTime;
        state = ExplodeState.Recovering;
        sfAnimator.SetTrigger("triggerFried");
        yield return Helpers.Wait(BoomSlimeExplode.EXPLOSION_RECOVERY_TIME);
        state = ExplodeState.Idle;
    }

    private void Explode()
    {
        if (IsLargo)
            PhysicsUtil.Explode(gameObject, ExplodeRadius * 2f, ExplodePower * 2f, MinPlayerDamage * 1.2f, MaxPlayerDamage * 1.2f);
        else
            PhysicsUtil.Explode(gameObject, ExplodeRadius, ExplodePower, MinPlayerDamage, MaxPlayerDamage);

        if (gameObject.layer == LayerMask.NameToLayer("Launched"))
            SceneContext.Instance.AchievementsDirector.AddToStat(AchievementsDirector.IntStat.LAUNCHED_BOOM_EXPLODE, 1);
    }

    public override void OnDisable()
    {
        base.OnDisable();
        state = ExplodeState.Idle;
    }

    public override bool CanRethink() => state == ExplodeState.Idle;

    public void OnControllerCollision(GameObject gameObj) => contact = Time.fixedTime > nextPossibleExplode && (gameObj == SceneContext.Instance.Player || (gameObj.TryGetComponent<Identifiable>(out var id) && Identifiable.IsSlime(id.id)));
}