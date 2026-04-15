namespace OceanRange.Slimes;

public sealed class LanternBehaviour : SRBehaviour, ControllerCollisionListener, CaveTrigger.Listener
{
    private readonly HashSet<GameObject> Caves = [];

    private TimeDirector timeDir;
    private SlimeAppearanceApplicator applicator;
    private float fleeingUntil;
    private bool waitForPhysicsUpdate;
    private CanMoveHandler canMove;

    public bool Fleeing { get; private set; }

    public void Awake()
    {
        applicator = GetComponent<SlimeAppearanceApplicator>();
        canMove = this.EnsureComponent<CanMoveHandler>();
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
            applicator.SetExpression(SlimeExpression.Alarm);
            return;
        }

        if (Caves.Count > 0)
        {
            canMove.CanMove = true;
            return;
        }

        canMove.CanMove = timeDir.CurrHour().IsInLoopedRange(0f, 24f, 6f, 18f, false);

        if (!canMove.CanMove)
            applicator.SetExpression(Ids.Sleeping);
    }

    public void Update()
    {
        if (waitForPhysicsUpdate)
            return;

        if (Caves.Count > 0)
            UnityWorkarounds.SafeRemoveAllNulls(Caves);
    }

    public void OnControllerCollision(GameObject gameObj)
    {
        if (canMove.CanMove)
            return;

        canMove.CanMove = Fleeing = gameObj == SceneContext.Instance.Player;

        if (Fleeing)
            fleeingUntil = Time.fixedTime + 10f;
    }

    public void OnCaveEnter(GameObject caveObj, bool _1, AmbianceDirector.Zone _2) => Caves.Add(caveObj);

    public void OnCaveExit(GameObject caveObj, bool _1, AmbianceDirector.Zone _2) => Caves.Remove(caveObj);
}