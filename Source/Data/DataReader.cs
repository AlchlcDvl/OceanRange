namespace OceanRange.Data;

public sealed class DataReader : IDisposable
{
    private readonly BinaryReader Reader;
    private readonly string[] PooledStrings;
    private readonly bool HasPooledStrings;

    public DataReader(BinaryReader reader)
    {
        Reader = reader;
        HasPooledStrings = reader.ReadBoolean();

        if (!HasPooledStrings)
            return;

        var count = ReadPackedUInt();
        PooledStrings = new string[count];
        PooledStrings[0] = string.Empty;

        for (var i = 1; i < count; i++)
            PooledStrings[i] = Reader.ReadString();
    }

    public uint ReadPackedUInt() => (uint)ReadVarInt();

    private ulong ReadVarInt()
    {
        var result = 0ul;
        var shift = 0;

        while (true)
        {
            var b = Reader.ReadByte();
            result |= (ulong)(b & 0x7F) << shift;

            if ((b & 0x80) == 0)
                break;

            shift += 7;
        }

        return result;
    }

    public string ReadString(bool returnNullOnZero = true)
    {
        if (!HasPooledStrings)
            return Reader.ReadString();

        var index = ReadPackedUInt();
        return index == 0 && returnNullOnZero ? null : PooledStrings[index];
    }

    public float ReadPackedFloat() => Mathf.HalfToFloat(Reader.ReadUInt16());

    public float ReadFloat() => Reader.ReadSingle();

    public bool ReadBool() => Reader.ReadBoolean();

    public Color32 ReadColor32() => new(Reader.ReadByte(), Reader.ReadByte(), Reader.ReadByte(), Reader.ReadByte());

    public Color ReadColor() => new(ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat());

    public string[] ReadStringArray() => ReadArray(r => r.ReadString());

    public T[] ReadArray<T>(Func<DataReader, T> reader, bool returnNullOnZero = true)
    {
        var count = ReadPackedUInt();

        if (count == 0 && returnNullOnZero)
            return null;

        var array = new T[count];

        for (var i = 0; i < count; i++)
            array[i] = reader(this);

        return array;
    }

    public Vector3 ReadVector3() => new(ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat());

    public Orientation ReadOrientation() => new(ReadVector3(), ReadVector3(), ReadVector3());

    // private static int ZigZagDecode(uint value) => (int)((value >> 1) ^ -(int)(value & 1));

    public T[] ReadEnumArray<T>() where T : struct, Enum
    {
        var count = ReadPackedUInt();
        var array = new T[count];

        for (var i = 0; i < count; i++)
            array[i] = Helpers.ParseEnum<T>(ReadString());

        return array;
    }

    private static readonly Dictionary<string, Type> CachedTypes = new(StringComparer.Ordinal);

    public Type ReadType()
    {
        var name = ReadString();

        if (string.IsNullOrEmpty(name))
            return null;

        if (CachedTypes.TryGetValue(name, out var cached))
            return cached;

        var type = Type.GetType(name) ?? throw new ArgumentException($"Cannot find type {name}!");
        CachedTypes[name] = type;
        return type;
    }

    public T? ReadNullableEnum<T>() where T : struct, Enum
    {
        var value = ReadString();
        return string.IsNullOrEmpty(value) ? null : Helpers.ParseOrAddEnumValue<T>(value);
    }

    public T ReadEnum<T>() where T : struct, Enum => Helpers.ParseEnum<T>(ReadString());

    public double ReadDouble() => Reader.ReadDouble();

    public double? ReadNullableDouble() => ReadBool() ? ReadDouble() : null;

    public Dictionary<string, string> ReadStringDictionary() => ReadDictionary(r => r.ReadString(), r => r.ReadString(), StringComparer.Ordinal);

    public Dictionary<string, Dictionary<string, string>> ReadStringToStringDictionary() => ReadDictionary(r => r.ReadString(), r => r.ReadStringDictionary(), StringComparer.Ordinal);

    public Dictionary<string, Dictionary<string, string>> ReadNullableStringToStringDictionary()
        => ReadBool() ? ReadStringToStringDictionary() : null;

    public Dictionary<TKey, TValue> ReadDictionary<TKey, TValue>(Func<DataReader, TKey> keyReader, Func<DataReader, TValue> valueReader, IEqualityComparer<TKey> comparer = null)
    {
        var dictCount = ReadPackedUInt();
        var dict = new Dictionary<TKey, TValue>((int)dictCount, comparer ?? EqualityComparer<TKey>.Default);

        for (var i = 0; i < dictCount; i++)
            dict[keyReader(this)] = valueReader(this);

        return dict;
    }

    public float? ReadNullablePackedFloat() => ReadBool() ? ReadPackedFloat() : null;

    public uint? ReadNullablePackedUInt() => ReadBool() ? ReadPackedUInt() : null;

    public T ReadFlagEnum<T>() where T : unmanaged, Enum
    {
        var count = ReadPackedUInt();
        var combined = 0L;

        for (var i = 0; i < count; i++)
        {
            var name = ReadString();

            if (Enum.TryParse<T>(name, out var val))
                combined |= FastCastToLong(val);
        }

        return FastCastFromLong<T>(combined);
    }

    private unsafe static long FastCastToLong<T>(T enumValue) where T : unmanaged, Enum
    {
        var size = sizeof(T);
        var ptr = &enumValue;

        return size switch
        {
            1 => *(byte*)ptr,
            2 => *(short*)ptr,
            4 => *(int*)ptr,
            8 => *(long*)ptr,
            _ => throw new NotSupportedException($"Unsupported enum size: {size} bytes"),
        };
    }

    private unsafe static T FastCastFromLong<T>(long longValue) where T : unmanaged, Enum
        => *(T*)&longValue;

    public void Dispose() => Reader.Dispose();
}