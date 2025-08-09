namespace OceanRange.Slimes;

public sealed class MesmerBehaviour : SRBehaviour
{
    public static readonly List<GameObjectActorModelIdentifiableIndex.Entry> AllMesmers = [];

    private GameObjectActorModelIdentifiableIndex.Entry IndexEntry;

    public void Awake()
    {
        IndexEntry = new()
        {
            id = GetComponent<Identifiable>().id,
            gameObject = gameObject
        };
        AllMesmers.Add(IndexEntry);
    }

    public void OnDestroy() => AllMesmers.Remove(IndexEntry);
}