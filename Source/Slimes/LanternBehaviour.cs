namespace OceanRange.Slimes;

public sealed class LanternBehaviour : SRBehaviour, ControllerCollisionListener, CaveTrigger.Listener
{
    public static GameObject FlashbangPrefab;

    private readonly HashSet<GameObject> caves = [];

    private TimeDirector timeDir;
    private SlimeAppearanceApplicator applicator;
    private float fleeingUntil;
    private bool waitForPhysicsUpdate;
    private bool wasFleeing;
    private bool wasSleeping;

    public float FlashDuration = 3.5f;
    public float FadeDuration = 3.5f;

    public CanMoveHandler CanMove;

    public bool Fleeing { get; private set; }

    public void Awake()
    {
        applicator = GetComponent<SlimeAppearanceApplicator>();
        CanMove = this.EnsureComponent<CanMoveHandler>();
        timeDir = SceneContext.Instance.TimeDirector;
        waitForPhysicsUpdate = true;
    }

    public void OnEnable() => waitForPhysicsUpdate = true;

    public void FixedUpdate()
    {
        waitForPhysicsUpdate = false;

        if (Fleeing)
        {
            Fleeing = Time.fixedTime < fleeingUntil;

            if (!wasFleeing)
            {
                applicator.SetExpression(SlimeExpression.Alarm);
                wasFleeing = true;
            }

            return;
        }

        wasFleeing = false;
        CanMove.CanMove = caves.Count > 0 || timeDir.CurrHour().IsInLoopedRange(0f, 24f, 6f, 18f, false);

        if (!CanMove.CanMove)
        {
            if (!wasSleeping)
            {
                applicator.SetExpression(Ids.Sleeping);
                wasSleeping = true;
            }
        }
        else
        {
            wasSleeping = false;
        }
    }

    public void Update()
    {
        if (waitForPhysicsUpdate)
            return;

        if (caves.Count > 0)
            UnityWorkarounds.SafeRemoveAllNulls(caves);
    }

    public void OnControllerCollision(GameObject gameObj)
    {
        if (CanMove.CanMove || gameObj != SceneContext.Instance.Player)
            return;

        CanMove.CanMove = Fleeing = true;
        fleeingUntil = Time.fixedTime + 10f;

        var flash = Instantiate(FlashbangPrefab);
        flash.transform.localScale *= 25f;
        DontDestroyOnLoad(flash);

        var effect = flash.AddComponent<FlashbangEffect>();
        effect.SetFlashDuration(FlashDuration);
        effect.SetFadeDuration(FadeDuration);
    }

    public void OnCaveEnter(GameObject caveObj, bool _1, AmbianceDirector.Zone _2) => caves.Add(caveObj);

    public void OnCaveExit(GameObject caveObj, bool _1, AmbianceDirector.Zone _2) => caves.Remove(caveObj);
}