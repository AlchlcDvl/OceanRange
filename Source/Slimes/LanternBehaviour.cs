namespace OceanRange.Slimes;

public sealed class LanternBehaviour : SRBehaviour, ControllerCollisionListener, CaveTrigger.Listener
{
    private readonly HashSet<GameObject> caves = [];

    private TimeDirector timeDir;
    private SlimeAppearanceApplicator applicator;
    private float fleeingUntil;
    private bool waitForPhysicsUpdate;
    private bool wasFleeing;
    private bool wasSleeping;

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

        if (caves.Count > 0)
            CanMove.CanMove = true;
        else
            CanMove.CanMove = timeDir.CurrHour().IsInLoopedRange(0f, 24f, 6f, 18f, false);

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
        if (CanMove.CanMove || Fleeing)
            return;

        CanMove.CanMove = Fleeing = gameObj == SceneContext.Instance.Player;

        if (!Fleeing)
            return;

        fleeingUntil = Time.fixedTime + 10f;
    }

    public void OnCaveEnter(GameObject caveObj, bool _1, AmbianceDirector.Zone _2) => caves.Add(caveObj);

    public void OnCaveExit(GameObject caveObj, bool _1, AmbianceDirector.Zone _2) => caves.Remove(caveObj);
}