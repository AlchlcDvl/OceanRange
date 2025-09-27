namespace OceanRange.Utils;

public static class ShaderUtils
{
    private static readonly Dictionary<string, int> ShaderPropsMap = [];
    private static readonly Dictionary<string, Shader> ShaderMap = [];

    public static int GetOrSet(string prop)
    {
        if (!ShaderPropsMap.TryGetValue(prop, out var propInt))
            ShaderPropsMap[prop] = propInt = Shader.PropertyToID(prop);

        return propInt;
    }

    public static Shader FindShader(string name)
    {
        if (!ShaderMap.TryGetValue(name, out var shader))
            ShaderMap[name] = shader = Shader.Find(name);

        return shader;
    }
}