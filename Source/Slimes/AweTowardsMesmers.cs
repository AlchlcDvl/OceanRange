namespace OceanRange.Slimes;

public sealed class AweTowardsMesmers : FindConsumable
{
    private GameObject target;
    private TimeDirector timeDir;
    private SlimeFaceAnimator sfAnimator;
    private double nextActivationTime;
    private float endTime;
    private float nextSearchTime;

    private static readonly Dictionary<IdentifiableId, DriveCalculator> SearchIdCache = new(Identifiable.idComparer);
    private static readonly DriveCalculator DriveCalculator = new(SlimeEmotions.Emotion.NONE, 0f, 0f);

    public static void InitCalculator()
    {
        SearchIdCache.Clear();

        foreach (var largo in Largopedia.Mesmers)
            SearchIdCache[largo] = DriveCalculator;
    }

    public override void Awake()
    {
        base.Awake();
        timeDir = SceneContext.Instance.TimeDirector;
        sfAnimator = GetComponent<SlimeFaceAnimator>();
    }

    public override float Relevancy(bool isGrounded)
    {
        if (!isGrounded || !timeDir.HasReached(nextActivationTime))
            return 0f;

        if (Time.time >= nextSearchTime)
        {
            target = FindNearestConsumable(out _);
            nextSearchTime = Time.time + 1.5f;
        }

        return target ? Randoms.SHARED.GetInRange(0.1f, 1f) : 0f;
    }

    public override void Action()
    {
        if (target)
            RotateTowards(GetGotoPos(target.gameObject) - transform.position, 5f, 1f);
    }

    public override void Selected()
    {
        sfAnimator.SetTrigger("triggerLongAwe");
        nextActivationTime = timeDir.HoursFromNow(1f);
        endTime = Time.time + 3f;
    }

    public override bool CanRethink() => Time.time >= endTime;

    public override Dictionary<IdentifiableId, DriveCalculator> GetSearchIds() => SearchIdCache;
}