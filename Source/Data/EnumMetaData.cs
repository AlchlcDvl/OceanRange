using System.Linq.Expressions;

namespace OceanRange.Data;

public sealed class EnumMetadata(Type enumType)
{
    public readonly bool IsFlags = enumType.IsDefined<FlagsAttribute>();
    public readonly Func<object, ulong> ToULong = CompileToULong(enumType);
    public readonly string ZeroName = Enum.ToObject(enumType, 0).ToString();
    public readonly List<(ulong, string)> Values = GenerateValues(enumType);

    private static readonly Dictionary<Type, EnumMetadata> MetadataCache = [];
    private static readonly Func<Type, EnumMetadata> Create = enumType => new(enumType);
    private static readonly Dictionary<Type, Func<object, ulong>> CompiledDelegates = [];

    private static List<(ulong, string)> GenerateValues(Type enumType) => [.. Enum.GetValues(enumType).Cast<object>().Select(CompileToULong(enumType)).Zip(Enum.GetNames(enumType))];

    public void AddEnumValue(object value, string name) => Values.Add((ToULong(value), name));

    public static EnumMetadata Get(Type enumType) => MetadataCache.GetOrAdd(enumType, Create);

    public static bool TryGet(Type enumType, out EnumMetadata metadata) => MetadataCache.TryGetValue(enumType, out metadata);

    private static Func<object, ulong> CompileToULong(Type enumType)
    {
        if (CompiledDelegates.TryGetValue(enumType, out var existing))
            return existing;

        var parameter = Expression.Parameter(typeof(object), "value");
        var conversion = Expression.Convert(Expression.Convert(parameter, enumType), typeof(ulong));
        var result = Expression.Lambda<Func<object, ulong>>(conversion, parameter).Compile();
        CompiledDelegates[enumType] = result;
        return result;
    }
}