namespace TheOceanRange.Slimes;

public sealed class LanternBehaviour : SRBehaviour, ControllerCollisionListener
{
    private TimeDirector TimeDir;
    private SlimeAppearanceApplicator Applicator;
    private float FleeingUntil;

    public bool CanMove;
    public bool Fleeing;

    public void Awake()
    {
        Applicator = GetComponent<SlimeAppearanceApplicator>();
        TimeDir = SceneContext.Instance.TimeDirector;
    }

    public void FixedUpdate()
    {
        if (Fleeing)
        {
            Fleeing = Time.fixedTime < FleeingUntil;

            if (Fleeing)
            {
                Applicator.SetExpression(SlimeFace.SlimeExpression.Alarm);
                return;
            }
        }

        CanMove = TimeDir.CurrHour().IsInLoopedRange(0f, 24f, 6f, 18f, false);

        if (!CanMove)
            Applicator.SetExpression(Ids.Sleeping);
    }

    public void OnControllerCollision(GameObject gameObj)
    {
        if (CanMove)
            return;

        CanMove = Fleeing = gameObj == SceneContext.Instance.Player;
        FleeingUntil = Time.fixedTime + 10f;
    }
}