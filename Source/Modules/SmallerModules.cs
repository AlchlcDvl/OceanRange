namespace OceanRange.Modules;

public sealed class PersistentId : MonoBehaviour
{
    public string ID;
}

// public sealed class ValueMismatchException(string mainValue, object value1, object value2) : Exception($"{mainValue} contained {value1} but not {value2} or vice versa!");

// public sealed class BlankBehaviour : MonoBehaviour; // Blank class to be used as a persistent check, similar to PersistentId class

// public sealed record class Out<T>(T Value); // To be used as an out param for coroutines

public sealed class PediaOnomicsHandler : MonoBehaviour
{
    public XlateText Text;

    public void Awake() => Text = gameObject.FindChild("PlortLabel", true).GetComponent<XlateText>();
}