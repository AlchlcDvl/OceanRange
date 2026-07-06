#if UNITY
using System.Runtime.CompilerServices;

namespace OceanRange.Data;

public sealed class DataWriter(BinaryWriter writer, Dictionary<string, uint>? sharedStringPool = null) : IDisposable
{
    private readonly BinaryWriter Writer = writer;
    private readonly Dictionary<string, uint>? PooledStrings = sharedStringPool;
    private readonly bool HasSharedPool = sharedStringPool != null;

    public void WriteBool(bool value) => Writer.Write(value);

    public void WriteByte(byte value) => Writer.Write(value);

    public void WriteSByte(sbyte value) => Writer.Write(value);

    private static uint ZigZagEncode(int value) => (uint)((value << 1) ^ (value >> 31));

    private void WriteVarInt(ulong value)
    {
        while (value >= 0x80)
        {
            Writer.Write((byte)(value | 0x80));
            value >>= 7;
        }

        Writer.Write((byte)value);
    }

    public void WritePackedUInt(uint value) => WriteVarInt(value);

    public void WritePackedULong(ulong value) => WriteVarInt(value);

    public void WritePackedInt(int value) => WriteVarInt(ZigZagEncode(value));

    public void WriteString(string? value)
    {
        if (!HasSharedPool)
        {
            Writer.Write(value ?? string.Empty);
            return;
        }

        if (string.IsNullOrEmpty(value))
        {
            WritePackedUInt(0);
            return;
        }

        if (!PooledStrings!.TryGetValue(value!, out var index))
            throw new ArgumentException($"'{value!}' was not found in the global string pool!");

        WritePackedUInt(index);
    }

    public void WritePackedFloat(float value) => Writer.Write(Mathf.FloatToHalf(value));

    public void WriteColor32(Color32 value)
    {
        Writer.Write(value.r);
        Writer.Write(value.g);
        Writer.Write(value.b);
        Writer.Write(value.a);
    }

    public void WriteColor(Color value)
    {
        WritePackedFloat(value.r);
        WritePackedFloat(value.g);
        WritePackedFloat(value.b);
        WritePackedFloat(value.a);
    }

    public void WriteVector2(Vector2 value)
    {
        WritePackedFloat(value.x);
        WritePackedFloat(value.y);
    }

    public void WriteVector3(Vector3 value)
    {
        WritePackedFloat(value.x);
        WritePackedFloat(value.y);
        WritePackedFloat(value.z);
    }

    public void WriteVector4(Vector4 value)
    {
        WritePackedFloat(value.x);
        WritePackedFloat(value.y);
        WritePackedFloat(value.z);
        WritePackedFloat(value.w);
    }

    public void WriteBounds(Bounds bounds)
    {
        WriteVector3(bounds.center);
        WriteVector3(bounds.size);
    }

    public void WriteOrientation(Orientation value)
    {
        WriteVector3(value.Position);
        WriteVector3(value.Rotation);
        WriteVector3(value.Scale);
    }

    public void WriteStringArray(string[] array) => WriteArray(array, (w, v) => w.WriteString(v));

    public void WriteDouble(double value) => Writer.Write(value);

    public void WriteNullableDouble(Optional<double> value)
    {
        WriteBool(value.HasValue);

        if (value.HasValue)
            WriteDouble(value.Value);
    }

    public void WriteStringDictionary(Dictionary<string, string>? dict) => WriteDictionary(dict, (w, v) => w.WriteString(v), (w, v) => w.WriteString(v));

    public void WriteStringToStringDictionary(Dictionary<string, Dictionary<string, string>>? dict) => WriteDictionary(dict, (w, v) => w.WriteString(v), (w, v) => w.WriteStringDictionary(v));

    public void WriteNullableStringToStringDictionary(Optional<Dictionary<string, Dictionary<string, string>>> dict)
    {
        var hasValue = dict.HasValue;
        WriteBool(hasValue);

        if (hasValue)
            WriteStringToStringDictionary(dict.Value);
    }

    public void WriteArray<T>(T[]? array, Action<DataWriter, T> elementWriter)
    {
        var count = (uint)(array?.Length ?? 0);
        WritePackedUInt(count);

        if (count == 0)
            return;

        for (var i = 0; i < count; i++)
            elementWriter(this, array![i]);
    }

    public void WriteArrayContents<T>(T[]? array, Action<DataWriter, T> elementWriter)
    {
        if (array == null)
            return;

        for (var i = 0; i < array.Length; i++)
            elementWriter(this, array[i]);
    }

    public void WriteListContents<T>(List<T>? list, Action<DataWriter, T> elementWriter)
    {
        if (list == null)
            return;

        for (var i = 0; i < list.Count; i++)
            elementWriter(this, list[i]);
    }

    public void WriteDictionary<TKey, TValue>(Dictionary<TKey, TValue>? dict, Action<DataWriter, TKey> keyWriter, Action<DataWriter, TValue> valueWriter)
    {
        WritePackedUInt((uint)(dict?.Count ?? 0));

        if (dict == null)
            return;

        foreach (var (key, value) in dict)
        {
            keyWriter(this, key);
            valueWriter(this, value);
        }
    }

    public void WriteNullablePackedFloat(Optional<float> value)
    {
        WriteBool(value.HasValue);

        if (value.HasValue)
            WritePackedFloat(value.Value);
    }

    public void WriteNullablePackedUInt(Optional<uint> value)
    {
        WriteBool(value.HasValue);

        if (value.HasValue)
            WritePackedUInt(value.Value);
    }

    public void WriteNullablePackedInt(Optional<int> value)
    {
        WriteBool(value.HasValue);

        if (value.HasValue)
            WritePackedInt(value.Value);
    }

    public void WriteSubstring(string? value, int startIndex) => WriteString(value?.Substring(startIndex));

    public void WriteDeltaEncodedInts(int[] indices)
    {
        if (indices == null || indices.Length == 0)
        {
            WritePackedUInt(0);
            return;
        }

        WritePackedUInt((uint)indices.Length);

        var previousIndex = 0;

        for (var i = 0; i < indices.Length; i++)
        {
            var currentIndex = indices[i];
            var delta = currentIndex - previousIndex;
            WritePackedInt(delta);
            previousIndex = currentIndex;
        }
    }

    public void WriteXorEncodedFloats(IReadOnlyList<float>? values)
    {
        var count = (uint)(values?.Count ?? 0);
        WritePackedUInt(count);

        if (count == 0)
            return;

        var previousBits = values![0].ToUIntBits();
        WritePackedUInt(previousBits);

        for (var i = 1; i < count; i++)
        {
            var currentBits = values[i].ToUIntBits();
            var xorDelta = currentBits ^ previousBits;

            WritePackedUInt(xorDelta);
            previousBits = currentBits;
        }
    }

    public void WriteXorEncodedDoubles(IReadOnlyList<double>? values)
    {
        var count = (uint)(values?.Count ?? 0);
        WritePackedUInt(count);

        if (count == 0)
            return;

        var previousBits = values![0].ToULongBits();
        WritePackedULong(previousBits);

        for (var i = 1; i < count; i++)
        {
            var currentBits = values[i].ToULongBits();
            var xorDelta = currentBits ^ previousBits;

            WritePackedULong(xorDelta);
            previousBits = currentBits;
        }
    }

    public void WriteQuantizedPosition(Vector3 pos, Bounds bounds)
    {
        var nx = NormalizeWithinBounds(pos.x, bounds.min.x, bounds.size.x);
        var ny = NormalizeWithinBounds(pos.y, bounds.min.y, bounds.size.y);
        var nz = NormalizeWithinBounds(pos.z, bounds.min.z, bounds.size.z);

        var qx = (uint)(nx * 1023f) & 0x3FF;
        var qy = (uint)(ny * 1023f) & 0x3FF;
        var qz = (uint)(nz * 1023f) & 0x3FF;

        var packed = qx | (qy << 10) | (qz << 20);
        Writer.Write(packed);
    }

    public void WriteQuantizedUV2(Vector2 uv)
    {
        Writer.Write((ushort)(Mathf.Clamp01(uv.x) * 65535f));
        Writer.Write((ushort)(Mathf.Clamp01(uv.y) * 65535f));
    }

    public void WriteQuantizedNormal(Vector3 normal)
    {
        var octNormal = OctEncode(normal);
        WriteSByte(QuantizeMinus1To1ToSbyte(octNormal.x));
        WriteSByte(QuantizeMinus1To1ToSbyte(octNormal.y));
    }

    public void WriteQuantizedTangent(Vector4 tangent)
    {
        var tangentDir = new Vector3(tangent.x, tangent.y, tangent.z);
        var octTangent = OctEncode(tangentDir);

        WriteSByte(QuantizeMinus1To1ToSbyte(octTangent.x));
        WriteSByte(QuantizeMinus1To1ToSbyte(octTangent.y));
        WriteByte(tangent.w > 0 ? (byte)1 : (byte)0);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    private static float NormalizeWithinBounds(float value, float min, float size) => size > 0f ? (value - min) / size : 0f;

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    private static sbyte QuantizeMinus1To1ToSbyte(float value) => (sbyte)(Mathf.Clamp(value, -1f, 1f) * 127f);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    private static Vector2 OctEncode(Vector3 v)
    {
        var l1Norm = Mathf.Abs(v.x) + Mathf.Abs(v.y) + Mathf.Abs(v.z);

        if (l1Norm < 0.0001f)
            return Vector2.zero;

        var res = new Vector2(v.x / l1Norm, v.y / l1Norm);

        if (v.z < 0f)
        {
            var x = res.x;
            var y = res.y;
            res.x = (1f - Mathf.Abs(y)) * SignNotZero(x);
            res.y = (1f - Mathf.Abs(x)) * SignNotZero(y);
        }

        return res;
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    private static float SignNotZero(float v) => v >= 0f ? 1f : -1f;

    public void Dispose() => Writer.Dispose();

    public void Flush() => Writer.Flush();
}
#endif