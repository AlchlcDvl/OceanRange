using System.Collections.Generic;

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

    public override void Action() {}

    public override float Relevancy(bool isGrounded) => emotions.GetCurr(SlimeEmotions.Emotion.AGITATION) >= 0.5f ? 1f : 0f;

    public override void Selected() {}
}