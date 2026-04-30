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

        var count = ReadPackedInt();
        PooledStrings = new string[count];
        PooledStrings[0] = string.Empty;

        for (var i = 1; i < count; i++)
            PooledStrings[i] = Reader.ReadString();
    }

    public uint ReadPackedInt() => (uint)ReadVarInt();

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

        var index = ReadPackedInt();
        return index == 0 && returnNullOnZero ? null : PooledStrings[index];
    }

    public float ReadPackedFloat() => Mathf.HalfToFloat(Reader.ReadUInt16());

    public float ReadFloat() => Reader.ReadSingle();

    public bool ReadBool() => Reader.ReadBoolean();

    public Color32 ReadColor32() => new(Reader.ReadByte(), Reader.ReadByte(), Reader.ReadByte(), Reader.ReadByte());

    public Color ReadColor() => new(ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat());

    public T[] ReadArray<T>(Func<DataReader, T> reader, bool returnNullOnZero = true)
    {
        var count = ReadPackedInt();

        if (count == 0 && returnNullOnZero)
            return null;

        var array = new T[count];

        for (var i = 0; i < count; i++)
            array[i] = reader(this);

        return array;
    }

    private static int ZigZagDecode(uint value) => (int)((value >> 1) ^ -(int)(value & 1));

    public void Dispose() => Reader.Dispose();
}