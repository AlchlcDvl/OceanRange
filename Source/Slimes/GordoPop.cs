namespace OceanRange.Slimes;

public sealed class GordoPop : MonoBehaviour
{
    public CustomSlimeData Data;

    public void OnDisable() => Data.IsPopped = true;
}