namespace OceanRange.Utils;

public static class ShaderUtils
{
    private static readonly Dictionary<string, int> ShaderPropsMap = [];
    // private static readonly Dictionary<string, Shader> ShaderMap = [];

    public static int GetOrSet(string prop) => ShaderPropsMap.GetOrAdd(prop, Shader.PropertyToID);

    // public static Shader FindShader(string name) => ShaderMap.GetOrAdd(name, Shader.Find);
}