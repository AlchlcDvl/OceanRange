using UnityEngine;
using System.IO;
using System.Collections.Generic;
using OceanRange.Unity;

[CreateAssetMenu(menuName = "OceanRange/Data/Model")]
public sealed class ModelData : JsonData
{
    public OptionalFloat Gloss;
    public string Pattern;
    public OptionalInt SameAs;
    public OptionalInt MatSameAs;
    public OptionalInt ColorsSameAs;
    public bool CloneSameAs;
    public bool CloneMatOrigin = true;
    public bool CloneFallback = true;
    public string MatOriginSlime;
    public string ColorsOrigin;
    // public string Shader;
    private Dictionary<string, Color> ColorPropsJson;
    public string Mesh;
    public bool SkipNull;
    public bool IgnoreLodIndex;
    public bool Skip;
    public bool InvertColorOriginColors;

    public override void SerialiseTo(BinaryWriter writer)
    {

    }
}