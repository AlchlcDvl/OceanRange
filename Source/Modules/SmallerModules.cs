namespace OceanRange.Modules;

public sealed class PersistentId : MonoBehaviour
{
    public string ID;
}

public struct Orientation(Vector3 pos, Vector3 rot)
{
    public Vector3 Position = pos;
    public Vector3 Rotation = rot;

    // public Orientation(float xPos, float yPos, float zPos, float xRot, float yRot, float zRot)
    //     : this(new(xPos, yPos, zPos), new(xRot, yRot, zRot)) { }
}

// public sealed class BlankBehaviour : MonoBehaviour; // Blank class to be used as a persistent check, similar to PersistentId class