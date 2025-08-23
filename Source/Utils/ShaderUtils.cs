namespace OceanRange.Utils;

public static class ShaderUtils
{
    private static readonly Dictionary<string, int> ShaderPropsMap = [];

    public static int GetOrSet(string prop)
    {
        if (!ShaderPropsMap.TryGetValue(prop, out var propInt))
            ShaderPropsMap[prop] = propInt = Shader.PropertyToID(prop);

        return propInt;
    }
}