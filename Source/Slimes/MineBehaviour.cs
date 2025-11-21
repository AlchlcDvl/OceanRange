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

    private float NextPossibleExplode;
    private float NextExplodeDelayTime = MaxDelay;
    private SlimeFaceAnimator SfAnimator;
    private CalmedByWaterSpray Calmed;
    private ExplodeIndicatorMarker Marker;
    private bool Contact;
    private ExplodeState State;

    public override void Awake()
    {
        base.Awake();
        SfAnimator = GetComponent<SlimeFaceAnimator>();
        Calmed = GetComponent<CalmedByWaterSpray>();
        Marker = GetComponentsInChildren<ExplodeIndicatorMarker>(true)[0];

        var applicator = GetComponent<SlimeAppearanceApplicator>();

        if (applicator.Appearance)
            ExplodeFX = applicator.Appearance.ExplosionAppearance.explodeFx;
    }

    public override void OnEnable()
    {
        base.OnEnable();

        if (Time.time + MinDelay > NextPossibleExplode)
            NextPossibleExplode = Math.Max(NextPossibleExplode, Time.time + Randoms.SHARED.GetFloat(MinDelay));
    }

    public override void Start()
    {
        base.Start();
        NextExplodeDelayTime = BoomDelay();
        NextPossibleExplode = Time.time + (NextExplodeDelayTime * Randoms.SHARED.GetInRange(0.25f, 1f));
        Marker.SetActive(false);
    }

    public override float Relevancy(bool _) => Calmed.IsCalmed() || !Contact || State is not ExplodeState.Idle ? 0f : 1f;

    public override void Action() {}

    public override void Selected() => StartCoroutine(DelayedExplosion());

    public void FixedUpdate()
    {
        if (Calmed.IsCalmed())
            NextPossibleExplode += Time.fixedDeltaTime;
    }

    private float BoomDelay() => Mathf.Lerp(MinDelay, MaxDelay, Mathf.Clamp01(Randoms.SHARED.GetInRange(-0.1f, 0.1f) + (1f - emotions.GetCurr(SlimeEmotions.Emotion.AGITATION))));

    private IEnumerator DelayedExplosion()
    {
        Contact = false;
        State = ExplodeState.Preparing;
        Marker.SetActive(true);
        SfAnimator.SetTrigger("triggerGrimace");
        yield return Helpers.Wait(BoomSlimeExplode.EXPLOSION_PREP_TIME);
        Marker.SetActive(false);
        State = ExplodeState.Exploding;
        SpawnAndPlayFX(ExplodeFX, transform.position, transform.rotation);
        Explode();
        NextExplodeDelayTime = BoomDelay();
        NextPossibleExplode = Time.time + NextExplodeDelayTime;
        State = ExplodeState.Recovering;
        SfAnimator.SetTrigger("triggerFried");
        yield return Helpers.Wait(BoomSlimeExplode.EXPLOSION_RECOVERY_TIME);
        State = ExplodeState.Idle;
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
        State = ExplodeState.Idle;
    }

    public override bool CanRethink() => State == ExplodeState.Idle;

    public void OnControllerCollision(GameObject gameObj) => Contact = Time.fixedTime > NextPossibleExplode && (gameObj == SceneContext.Instance.Player || (gameObj.TryGetComponent<Identifiable>(out var id) && Identifiable.IsSlime(id.id)));
}