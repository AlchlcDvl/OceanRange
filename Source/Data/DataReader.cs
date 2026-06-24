using System.Runtime.CompilerServices;

namespace OceanRange.Data;

public sealed class DataReader(BinaryReader reader, string[]? pool) : IDisposable
{
    private readonly bool hasPooledStrings = pool != null;

    public uint ReadPackedUInt() => (uint)ReadVarInt();

    public ulong ReadPackedULong() => ReadVarInt();

    public int ReadPackedInt() => ZigZagDecode((uint)ReadVarInt());

    private ulong ReadVarInt()
    {
        var result = 0ul;
        var shift = 0;

        while (true)
        {
            var b = reader.ReadByte();
            result |= (ulong)(b & 0x7F) << shift;

            if ((b & 0x80) == 0)
                break;

            shift += 7;
        }

        return result;
    }

    public string? ReadString(bool returnNullOnZero = true)
    {
        if (!hasPooledStrings)
            return reader.ReadString();

        var index = ReadPackedUInt();
        return index == 0 && returnNullOnZero ? null : pool![index];
    }

    public float ReadPackedFloat() => Mathf.HalfToFloat(reader.ReadUInt16());

    public double ReadDouble() => reader.ReadDouble();

    // public float ReadFloat() => reader.ReadSingle();

    public bool ReadBool() => reader.ReadBoolean();

    public byte ReadByte() => reader.ReadByte();

    private sbyte ReadSByte() => reader.ReadSByte();

    public Color32 ReadColor32() => new(reader.ReadByte(), reader.ReadByte(), reader.ReadByte(), reader.ReadByte());

    public Color ReadColor() => new(ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat());

    public string?[]? ReadStringArray() => ReadArray(r => r.ReadString());

    public T[]? ReadArray<T>(Func<DataReader, T> readerDel, bool returnNullOnZero = true)
    {
        var count = ReadPackedUInt();

        if (count == 0 && returnNullOnZero)
            return null;

        var array = new T[count];

        for (var i = 0; i < count; i++)
            array[i] = readerDel(this);

        return array;
    }

    public T[] ReadArrayContents<T>(int count, Func<DataReader, T> readFunc)
    {
        var array = new T[count];

        for (var i = 0; i < count; i++)
            array[i] = readFunc(this);

        return array;
    }

    public void ReadListContents<T>(List<T> list, int count, Func<DataReader, T> readFunc)
    {
        for (var i = 0; i < count; i++)
            list.Add(readFunc(this));
    }

    public Vector2 ReadVector2() => new(ReadPackedFloat(), ReadPackedFloat());

    public Vector3 ReadVector3() => new(ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat());

    public Vector4 ReadVector4() => new(ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat(), ReadPackedFloat());

    public Bounds ReadBounds() => new(ReadVector3(), ReadVector3());

    public Orientation ReadOrientation() => new(ReadVector3(), ReadVector3(), ReadVector3());

    private static int ZigZagDecode(uint value) => (int)((value >> 1) ^ -(int)(value & 1));

    public T[]? ReadEnumArray<T>(bool returnNullOnZero = false) where T : struct, Enum
    {
        var count = ReadPackedUInt();

        if (count == 0)
            return returnNullOnZero ? null : [];

        var array = new T[count];

        for (var i = 0; i < count; i++)
            array[i] = Helpers.ParseOrAddEnumValue<T>(ReadString()!);

        return array;
    }

    private static readonly Dictionary<string, Type> CachedTypes = new(StringComparer.Ordinal);

    public Type? ReadType()
    {
        var name = ReadString()!;

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
        return string.IsNullOrEmpty(value) ? null : Helpers.ParseOrAddEnumValue<T>(value!);
    }

    public T ReadEnum<T>() where T : struct, Enum => Helpers.ParseEnum<T>(ReadString()!);

    private double ReadDouble() => reader.ReadDouble();

    public double? ReadNullableDouble() => ReadBool() ? ReadDouble() : null;

    private Dictionary<string?, string?>? ReadStringDictionary() => ReadDictionary(r => r.ReadString(), r => r.ReadString(), StringComparer.Ordinal);

    public Dictionary<string?, Dictionary<string?, string?>?>? ReadStringToStringDictionary() => ReadDictionary(r => r.ReadString(), r => r.ReadStringDictionary(), StringComparer.Ordinal);

    public Dictionary<string?, Dictionary<string?, string?>?>? ReadNullableStringToStringDictionary()
        => ReadBool() ? ReadStringToStringDictionary() : null;

    public Dictionary<TKey, TValue>? ReadDictionary<TKey, TValue>(Func<DataReader, TKey> keyReader, Func<DataReader, TValue> valueReader, IEqualityComparer<TKey>? comparer = null, bool returnNullOnZero = true)
    {
        var dictCount = ReadPackedUInt();

        if (dictCount == 0)
            return returnNullOnZero ? null : [];

        var dict = new Dictionary<TKey, TValue>((int)dictCount, comparer ?? EqualityComparer<TKey>.Default);

        for (var i = 0; i < dictCount; i++)
            dict[keyReader(this)] = valueReader(this);

        return dict;
    }

    public float? ReadNullablePackedFloat() => ReadBool() ? ReadPackedFloat() : null;

    // public uint? ReadNullablePackedUInt() => ReadBool() ? ReadPackedUInt() : null;

    public int? ReadNullablePackedInt() => ReadBool() ? ReadPackedInt() : null;

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

    private static unsafe long FastCastToLong<T>(T enumValue) where T : unmanaged, Enum
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

    private static unsafe T FastCastFromLong<T>(long longValue) where T : unmanaged, Enum
        => *(T*)&longValue;

    public int[] ReadDeltaEncodedIndices()
    {
        var count = ReadPackedUInt();

        if (count == 0)
            return [];

        var indices = new int[count];
        var previousIndex = 0;

        for (var i = 0; i < count; i++)
        {
            var delta = ReadPackedInt();
            var currentIndex = previousIndex + delta;
            indices[i] = currentIndex;
            previousIndex = currentIndex;
        }

        return indices;
    }

    public float[] ReadXorEncodedFloats(int? expectedCount = null)
    {
        var count = ReadPackedUInt();

        if (expectedCount.HasValue && expectedCount.Value != (int)count)
            throw new InvalidDataException($"Expected {expectedCount.Value} floats, found {count}.");

        if (count == 0)
            return [];

        var values = new float[count];
        var previousBits = ReadPackedUInt();
        values[0] = BitConverter.UInt32BitsToSingle(previousBits);

        for (var i = 1; i < count; i++)
        {
            previousBits ^= ReadPackedUInt();
            values[i] = BitConverter.UInt32BitsToSingle(previousBits);
        }

        return values;
    }

    public double[] ReadXorEncodedDoubles(int? expectedCount = null)
    {
        var count = ReadPackedUInt();

        if (expectedCount.HasValue && expectedCount.Value != (int)count)
            throw new InvalidDataException($"Expected {expectedCount.Value} doubles, found {count}.");

        if (count == 0)
            return [];

        var values = new double[count];
        var previousBits = ReadPackedULong();
        values[0] = BitConverter.Int64BitsToDouble(unchecked((long)previousBits));

        for (var i = 1; i < count; i++)
        {
            previousBits ^= ReadPackedULong();
            values[i] = BitConverter.Int64BitsToDouble(unchecked((long)previousBits));
        }

        return values;
    }

    public Vector3 ReadQuantizedPosition(Bounds bounds)
    {
        var packed = reader.ReadUInt32();

        var nx = (packed & 0x3FF) / 1023f;
        var ny = ((packed >> 10) & 0x3FF) / 1023f;
        var nz = ((packed >> 20) & 0x3FF) / 1023f;

        return new(
            bounds.min.x + (nx * bounds.size.x),
            bounds.min.y + (ny * bounds.size.y),
            bounds.min.z + (nz * bounds.size.z)
        );
    }

    public Vector3 ReadQuantizedNormal()
    {
        var x = ReadSByte() / 127f;
        var y = ReadSByte() / 127f;
        return OctDecode(new Vector2(x, y));
    }

    public Vector4 ReadQuantizedTangent()
    {
        var x = ReadSByte() / 127f;
        var y = ReadSByte() / 127f;
        var w = ReadByte() > 0 ? 1f : -1f;

        var dir = OctDecode(new Vector2(x, y));
        return new Vector4(dir.x, dir.y, dir.z, w);
    }

    public Vector2 ReadQuantizedUV2()
    {
        return new Vector2(
            reader.ReadUInt16() / 65535f,
            reader.ReadUInt16() / 65535f
        );
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    private static float SignNotZero(float v) => v >= 0f ? 1f : -1f;

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    private static Vector3 OctDecode(Vector2 encoded)
    {
        var v = new Vector3(encoded.x, encoded.y, 1f - Mathf.Abs(encoded.x) - Mathf.Abs(encoded.y));

        if (v.z < 0f)
        {
            var x = v.x;
            var y = v.y;
            v.x = (1f - Mathf.Abs(y)) * SignNotZero(x);
            v.y = (1f - Mathf.Abs(x)) * SignNotZero(y);
        }

        return v.normalized;
    }

    public void Dispose() => reader.Dispose();
}