namespace OceanRange.Slimes;

public sealed class RosiBehaviour : SRBehaviour
{
    public static readonly List<RosiBehaviour> All = [];

    public void Awake() => All.Add(this);

    public void OnDestroy() => All.Remove(this);
}