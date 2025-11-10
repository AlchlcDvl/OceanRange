using System.Linq.Expressions;

namespace OceanRange.Modules;

public sealed class EnumMetadata
{
    public readonly bool IsFlags;
    public readonly string ZeroName;
    public readonly List<(object, string)> Values;
    public readonly Func<ulong, object> FromUInt64;

    public EnumMetadata(Type enumType)
    {
        IsFlags = enumType.IsDefined<FlagsAttribute>();
        Values = [.. Enum.GetValues(enumType).Cast<object>().Zip(Enum.GetNames(enumType))];
        ZeroName = Enum.ToObject(enumType, 0).ToString();

        var underlying = Enum.GetUnderlyingType(enumType);
        FromUInt64 = MakeFromUInt64(enumType, underlying);
    }

    private static Func<ulong, object> MakeFromUInt64(Type enumType, Type underlying)
    {
        var value = Expression.Parameter(typeof(ulong), "value");
        var converted = Expression.ConvertChecked(value, underlying);
        var boxed = Expression.Convert(Expression.Convert(converted, enumType), typeof(object));
        return Expression.Lambda<Func<ulong, object>>(boxed, value).Compile();
    }

    private static readonly Dictionary<Type, EnumMetadata> MetadataCache = [];

    private static EnumMetadata Create(Type enumType) => new(enumType);

    public static EnumMetadata Get(Type enumType) => MetadataCache.GetOrAdd(enumType, Create);

    public static bool TryGet(Type enumType, out EnumMetadata metadata) => MetadataCache.TryGetValue(enumType, out metadata);
}