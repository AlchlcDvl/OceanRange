namespace OceanRange.Slimes;

public sealed class RosiBehaviour : SlimeSubbehaviour
{
    public static readonly List<RosiBehaviour> All = [];

    public override void Awake()
    {
        base.Awake();
        All.Add(this);
    }

    public override void OnDestroy() => All.Remove(this);

    public override float Relevancy(bool _) => 1f;

    public override void Selected() {}

    public override void Action() {}
}