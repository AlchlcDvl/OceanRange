namespace TheOceanRange.Slimes;

public class RosaBehaviour : SlimeSubbehaviour
{
    public static List<RosaBehaviour> All = [];

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