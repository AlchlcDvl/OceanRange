namespace OceanRange.Slimes;

public sealed class RosiBehaviour : SRBehaviour
{
    public static readonly HashSet<RosiBehaviour> All = [];

    public void Awake() => All.Add(this);

    public void OnDestroy() => All.Remove(this);
}