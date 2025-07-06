namespace TheOceanRange.Slimes;

public sealed class RosiBehaviour : SlimeSubbehaviour
{
    public static List<RosiBehaviour> All = [];

    public override void Awake()
    {
        base.Awake();
        All.Add(this);
    }

    public override void OnDestroy() => All.Remove(this);

    public override float Relevancy(bool _) => emotions.GetCurr(SlimeEmotions.Emotion.AGITATION) >= 0.5f ? 1f : 0f;

    public override void Selected() {}

    public override void Action() {}
}