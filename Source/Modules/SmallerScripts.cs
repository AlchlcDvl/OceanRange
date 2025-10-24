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

public abstract class AppearanceFixer : MonoBehaviour
{
    public void Awake() => FixAppearance();

    protected abstract void FixAppearance();
}

public sealed class PhosphorHermitAppearanceFixer : AppearanceFixer
{
    protected override void FixAppearance()
    {
        var boneSlime = gameObject.FindChild("bone_slime", true).transform;
        boneSlime.Find("bone_wing_left").localPosition += new Vector3(0f, -0.1f, 0.4f);
        boneSlime.Find("bone_wing_right").localPosition += new Vector3(0f, -0.1f, 0.4f);
    }
}