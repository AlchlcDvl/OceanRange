namespace OceanRange.Utils;

public static class ShaderUtils
{
    private static readonly Dictionary<string, int> ShaderPropsMap = new(StringComparer.Ordinal);
    // private static readonly Dictionary<string, Shader> ShaderMap = new(StringComparer.Ordinal);

    private static readonly Func<string, int> ShaderPropGettingFunc = Shader.PropertyToID;
    // private static readonly Func<string, Shader> ShaderGettingFunc = Shader.Find;

    public static int GetOrSet(string prop) => ShaderPropsMap.GetOrAdd(prop, ShaderPropGettingFunc);

    // public static Shader FindShader(string name) => ShaderMap.GetOrAdd(name, ShaderGettingFunc);
}