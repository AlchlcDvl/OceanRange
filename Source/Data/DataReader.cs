namespace OceanRange.Data;

public sealed class DataReader : IDisposable
{
    public static readonly Func<DataReader, string> String = reader => reader.ReadString();

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

    private static readonly Dictionary<string, Type> CachedTypes = [];

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
        return string.IsNullOrEmpty(value) ? null : Helpers.ParseEnum<T>(value);
    }

    public double ReadDouble() => Reader.ReadDouble();

    public double? ReadNullableDouble() => ReadBool() ? ReadDouble() : null;

    public Dictionary<string, string> ReadStringDictionary()
    {
        var count = ReadPackedUInt();
        var dict = new Dictionary<string, string>((int)count);

        for (var i = 0; i < count; i++)
            dict[ReadString()] = ReadString();

        return dict;
    }

    public Dictionary<string, Dictionary<string, string>> ReadStringToStringDictionary()
    {
        var count = ReadPackedUInt();
        var dict = new Dictionary<string, Dictionary<string, string>>((int)count);

        for (var i = 0; i < count; i++)
            dict[ReadString()] = ReadStringDictionary();

        return dict;
    }

    public Dictionary<string, Dictionary<string, string>> ReadNullableStringToStringDictionary()
        => ReadBool() ? ReadStringToStringDictionary() : null;

    public void Dispose() => Reader.Dispose();
}