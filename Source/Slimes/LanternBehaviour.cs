namespace OceanRange.Slimes;

public sealed class LanternBehaviour : SRBehaviour, ControllerCollisionListener, CaveTrigger.Listener
{
    private readonly HashSet<GameObject> Caves = [];

    private TimeDirector TimeDir;
    private SlimeAppearanceApplicator Applicator;
    private float FleeingUntil;
    private bool WaitForPhysicsUpdate;

    public CanMoveHandler CanMove;
    public bool Fleeing;

    public void Awake()
    {
        Applicator = GetComponent<SlimeAppearanceApplicator>();
        CanMove = this.EnsureComponent<CanMoveHandler>();
        TimeDir = SceneContext.Instance.TimeDirector;
        WaitForPhysicsUpdate = true;
    }

    public void OnEnable() => WaitForPhysicsUpdate = true;

    public void FixedUpdate()
    {
        WaitForPhysicsUpdate = false;

        if (Fleeing)
        {
            Fleeing = Time.fixedTime < FleeingUntil;
            Applicator.SetExpression(SlimeExpression.Alarm);
            return;
        }

        if (Caves.Count > 0)
        {
            CanMove.CanMove = true;
            return;
        }

        CanMove.CanMove = TimeDir.CurrHour().IsInLoopedRange(0f, 24f, 6f, 18f, false);

        if (!CanMove.CanMove)
            Applicator.SetExpression(Ids.Sleeping);
    }

    public void Update()
    {
        if (WaitForPhysicsUpdate)
            return;

        if (Caves.Count > 0)
            UnityWorkarounds.SafeRemoveAllNulls(Caves);
    }

    public void OnControllerCollision(GameObject gameObj)
    {
        if (CanMove.CanMove)
            return;

        CanMove.CanMove = Fleeing = gameObj == SceneContext.Instance.Player;

        if (Fleeing)
            FleeingUntil = Time.fixedTime + 10f;
    }

    public void OnCaveEnter(GameObject caveObj, bool _1, AmbianceDirector.Zone _2) => Caves.Add(caveObj);

    public void OnCaveExit(GameObject caveObj, bool _1, AmbianceDirector.Zone _2) => Caves.Remove(caveObj);
}