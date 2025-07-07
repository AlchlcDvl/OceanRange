using System.Collections;

namespace TheOceanRange.Slimes;

public sealed class MineBehaviour : SlimeSubbehaviour, ControllerCollisionListener
{
    private enum ExplodeState
    {
        IDLE,
        PREPARING,
        EXPLODING,
        RECOVERING
    }

    private const float ExplodePower = 600f;
    private const float ExplodeRadius = 7f;
    private const float MinPlayerDamage = 15f;
    private const float MaxPlayerDamage = 45f;
    private const float MAX_DELAY = 15f;
    private const float MIN_DELAY = 5f;

    private GameObject ExplodeFX;
    private float NextPossibleExplode;
    private float NextExplodeDelayTime = MAX_DELAY;
    private SlimeFaceAnimator SfAnimator;
    private CalmedByWaterSpray Calmed;
    private SlimeAppearanceApplicator SlimeAppearanceApplicator;
    private ExplodeIndicatorMarker Marker;
    private bool Contact;
    private ExplodeState State;

    public override void Awake()
    {
        base.Awake();
        SfAnimator = GetComponent<SlimeFaceAnimator>();
        Calmed = GetComponent<CalmedByWaterSpray>();
        SlimeAppearanceApplicator = GetComponent<SlimeAppearanceApplicator>();
        Marker = GetComponentsInChildren<ExplodeIndicatorMarker>(true)[0];

        if (SlimeAppearanceApplicator.Appearance != null)
            ExplodeFX = SlimeAppearanceApplicator.Appearance.ExplosionAppearance.explodeFx;

        SlimeAppearanceApplicator.OnAppearanceChanged += appearance => ExplodeFX = appearance.ExplosionAppearance.explodeFx;
    }

    public override void OnEnable()
    {
        base.OnEnable();

        if (Time.time + MIN_DELAY > NextPossibleExplode)
            NextPossibleExplode = Math.Max(NextPossibleExplode, Time.time + Randoms.SHARED.GetFloat(MIN_DELAY));
    }

    public override void Start()
    {
        base.Start();
        NextExplodeDelayTime = BoomDelay();
        NextPossibleExplode = Time.time + (NextExplodeDelayTime * Randoms.SHARED.GetInRange(0.25f, 1f));
        Marker.SetActive(false);
    }

    public override float Relevancy(bool _) => Calmed.IsCalmed() || !Contact ? 0f : 1f;

    public override void Action() {}

    public override void Selected() => StartCoroutine(DelayedExplosion());

    public void FixedUpdate()
    {
        if (Calmed.IsCalmed())
            NextPossibleExplode += Time.fixedDeltaTime;
    }

    private float BoomDelay() => Mathf.Lerp(MIN_DELAY, MAX_DELAY, Mathf.Clamp01(Randoms.SHARED.GetInRange(-0.1f, 0.1f) + (1f - emotions.GetCurr(SlimeEmotions.Emotion.AGITATION))));

    private IEnumerator DelayedExplosion()
    {
        Contact = false;
        State = ExplodeState.PREPARING;
        Marker.SetActive(true);
        SfAnimator.SetTrigger("triggerGrimace");
        yield return new WaitForSeconds(BoomSlimeExplode.EXPLOSION_PREP_TIME);
        Marker.SetActive(false);
        State = ExplodeState.EXPLODING;
        SpawnAndPlayFX(ExplodeFX, transform.position, transform.rotation);
        Explode();
        NextExplodeDelayTime = BoomDelay();
        NextPossibleExplode = Time.time + NextExplodeDelayTime;
        State = ExplodeState.RECOVERING;
        SfAnimator.SetTrigger("triggerFried");
        yield return new WaitForSeconds(BoomSlimeExplode.EXPLOSION_RECOVERY_TIME);
        State = ExplodeState.IDLE;
    }

    private void Explode()
    {
        PhysicsUtil.Explode(gameObject, ExplodeRadius, ExplodePower, MinPlayerDamage, MaxPlayerDamage);

        if (gameObject.layer == LayerMask.NameToLayer("Launched"))
            SceneContext.Instance.AchievementsDirector.AddToStat(AchievementsDirector.IntStat.LAUNCHED_BOOM_EXPLODE, 1);
    }

    public override void OnDisable()
    {
        base.OnDisable();
        State = ExplodeState.IDLE;
    }

    public override bool CanRethink() => State == ExplodeState.IDLE;

    public void OnControllerCollision(GameObject gameObj) => Contact = Time.fixedTime > NextPossibleExplode && gameObj == SceneContext.Instance.Player;
}