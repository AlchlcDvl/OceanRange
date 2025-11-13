namespace OceanRange.Modules;

public sealed class EnumMetadata(Type enumType)
{
    public readonly bool IsFlags = enumType.IsDefined<FlagsAttribute>();
    public readonly string ZeroName = Enum.ToObject(enumType, 0).ToString();
    public readonly List<(object, string)> Values = [.. Enum.GetValues(enumType).Cast<object>().Zip(Enum.GetNames(enumType))];

    private static readonly Dictionary<Type, EnumMetadata> MetadataCache = [];

    private static EnumMetadata Create(Type enumType) => new(enumType);

    public static EnumMetadata Get(Type enumType) => MetadataCache.GetOrAdd(enumType, Create);

    public static bool TryGet(Type enumType, out EnumMetadata metadata) => MetadataCache.TryGetValue(enumType, out metadata);
}