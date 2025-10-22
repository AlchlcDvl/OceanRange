namespace OceanRange.Modules;

public sealed class PersistentIdHandler : MonoBehaviour
{
    public string ID;
}

// public sealed class BlankBehaviour : MonoBehaviour; // Blank class to be used as a persistent check, similar to PersistentId class

public sealed class PediaOnomicsHandler : MonoBehaviour
{
    public XlateText Text;

    public void Awake() => Text = gameObject.FindChild("PlortLabel", true).GetComponent<XlateText>();
}

public sealed class ModelDataHandler : MonoBehaviour
{
    public float? Jiggle;
}

// public sealed class AppearanceFixer : MonoBehaviour
// {
//     private Action<Transform> Fixer;

//     public void Start() => Fixer(transform);

//     public void SetFixer(Action<Transform> fixer) => Fixer = fixer;
// }