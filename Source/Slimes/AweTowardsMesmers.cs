namespace OceanRange.Slimes;

public sealed class AweTowardsMesmers : FindConsumable
{
    private GameObject Target;
    private TimeDirector TimeDir;
    private SlimeFaceAnimator SfAnimator;
    private double NextActivationTime;
    private float EndTime;

    public override void Awake()
    {
        base.Awake();
        TimeDir = SceneContext.Instance.TimeDirector;
        SfAnimator = GetComponent<SlimeFaceAnimator>();
    }

    public override float Relevancy(bool isGrounded)
    {
        if (!isGrounded || !TimeDir.HasReached(NextActivationTime))
            return 0f;

        Target = FindNearestConsumable(out _);
        return Target ? Randoms.SHARED.GetInRange(0.1f, 1f) : 0f;
    }

    public override void Action()
    {
        if (Target)
            RotateTowards(GetGotoPos(Target.gameObject) - transform.position, 5f, 1f);
    }

    public override void Selected()
    {
        SfAnimator.SetTrigger("triggerLongAwe");
        NextActivationTime = TimeDir.HoursFromNow(1f);
        EndTime = Time.time + 3f;
    }

    public override bool CanRethink() => Time.time >= EndTime;

    public override Dictionary<IdentifiableId, DriveCalculator> GetSearchIds()
    {
        var driveCalc = new DriveCalculator(SlimeEmotions.Emotion.NONE, 0f, 0f);
        var result = new Dictionary<IdentifiableId, DriveCalculator>(Identifiable.idComparer) { [Ids.MESMER_SLIME] = driveCalc };

        foreach (var largo in SlimeManager.MesmerLargos)
            result[largo] = driveCalc;

        return result;
    }
}