namespace OceanRange.Slimes;

// WIP awe behaviour
public sealed class AweTowardsMesmers : SlimeSubbehaviour
{
    private Identifiable target;
    private List<Identifiable> attractors = [];
    private TimeDirector timeDir;
    private SlimeFaceAnimator sfAnimator;
    private double nextActivationTime;
    private float endTime;

    public override void Awake()
    {
        base.Awake();
        timeDir = SceneContext.Instance.TimeDirector;
        sfAnimator = GetComponent<SlimeFaceAnimator>();
    }

    public override float Relevancy(bool isGrounded)
    {
        if (attractors.Count == 0 || !isGrounded || !timeDir.HasReached(nextActivationTime))
            return 0f;

        target = Randoms.SHARED.Pick(attractors, null);

        if (target == null)
        {
            attractors.Remove(target);
            target = null;
            return 0f;
        }

        return target ? Randoms.SHARED.GetInRange(0.05f, 0.5f) : 0f;
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

    public void RegisterMesmer(Identifiable mesmer) => attractors.Add(mesmer);

    public void UnregisterMesmer(Identifiable mesmer) => attractors.Remove(mesmer);
}