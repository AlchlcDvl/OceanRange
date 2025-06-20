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

    // public static Vector3 Multiply(this Vector3 value, float x, float y, float z) => new(value.x * x, value.y * y, value.z * z);

    // public static Vector3 Multiply(this Vector3 value, float scale) => value.Multiply(scale, scale, scale);

    // public static Vector3 Multiply(this Vector3 value, Vector3 scale) => value.Multiply(scale.x, scale.y, scale.z);

    // public static Vector2 Multiply(this Vector2 value, float x, float y) => new(value.x * x, value.y * y);

    // public static Vector2 Multiply(this Vector2 value, Vector2 scale) => value.Multiply(scale.x, scale.y);

    // public static Vector3 Abs(this Vector3 value) => new(Mathf.Abs(value.x), Mathf.Abs(value.y), Mathf.Abs(value.z));

    // public static float Sum(this IEnumerable<float> source)
    // {
    //     var num = 0f;

    //     foreach (var item in source)
    //         num += item;

    //     return (float)num;
    // }

    // public static float Sum(this Vector3 source) => source.x + source.y + source.z;

    // public static float Sum(this Vector2 source) => source.x + source.y;

    // public static float[] ToArray(this Vector3 value) => [value.x, value.y, value.z];
}