namespace OceanRange.Slimes;

public sealed class MesmerBehaviour : SRBehaviour
{
    public static readonly List<GameObjectActorModelIdentifiableIndex.Entry> AllMesmers = [];

    private GameObjectActorModelIdentifiableIndex.Entry IndexEntry;

    public void Awake()
    {
        var identifiable = GetComponent<Identifiable>();
        IndexEntry = new()
        {
            id = identifiable.id,
            gameObject = gameObject,
            actorModel = identifiable.model
        };
        AllMesmers.Add(IndexEntry);
    }

    public void OnDestroy() => AllMesmers.Remove(IndexEntry);
}