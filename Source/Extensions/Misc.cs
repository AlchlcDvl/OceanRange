using System;
using SRML.Utils;

namespace TheOceanRange;

public static class Misc
{
    public static T Parse<T>(string value) where T : struct, Enum => (T)Enum.Parse(typeof(T), value);

    public static Material Clone(this Material material)
    {
        var val = new Material(material);
        val.CopyPropertiesFromMaterial(material);
        return val;
    }

    public static T DeepCopy<T>(this T obj) where T : UObject => (T)PrefabUtils.DeepCopyObject(obj);

    // public static UObject DeepCopy<T>(this T obj) where T : UObject => PrefabUtils.DeepCopyObject(obj);
}