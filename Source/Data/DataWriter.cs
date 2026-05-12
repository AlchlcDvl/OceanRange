#if UNITY
namespace OceanRange.Data;

public sealed class DataWriter(BinaryWriter writer) : IDisposable
{
    private readonly BinaryWriter Writer = writer;
    private readonly Dictionary<string, uint> PooledStrings = new(StringComparer.Ordinal);
    private uint Index = 1u;

    public void PoolSubstring(string value, int startIndex) => PoolString(value?.Substring(startIndex));

    public void PoolString(string value)
    {
        if (!string.IsNullOrEmpty(value) && !PooledStrings.ContainsKey(value))
            PooledStrings[value] = Index++;
    }

    public void PoolSubstrings(string[] values, int startIndex)
    {
        if (values.IsNullOrEmpty())
            return;

        for (var i = 0; i < values.Length; i++)
            PoolString(values[i]?.Substring(startIndex));
    }

    public void PoolSubstrings(ICollection<string> values, int startIndex)
    {
        if (values.IsNullOrEmpty())
            return;

        foreach (var value in values)
            PoolString(value?.Substring(startIndex));
    }

    public void PoolStrings(string[] values)
    {
        if (values.IsNullOrEmpty())
            return;

        for (var i = 0; i < values.Length; i++)
            PoolString(values[i]);
    }

    public void PoolStrings(ICollection<string> values)
    {
        if (values.IsNullOrEmpty())
            return;

        foreach (var value in values)
            PoolString(value);
    }

    public void PushPooledStrings()
    {
        var pooledStringsExist = PooledStrings.Count > 0;

        Writer.Write(pooledStringsExist);

        if (!pooledStringsExist)
            return;

        WritePackedUInt(Index);

        foreach (var value in PooledStrings.Keys)
            Writer.Write(value);
    }

    public void WriteBool(bool value) => Writer.Write(value);

    // private static uint ZigZagEncode(int value) => (uint)((value << 1) ^ (value >> 31));

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

    public void WriteString(string value)
    {
        if (PooledStrings.Count == 0)
        {
            Writer.Write(value ?? string.Empty);
            return;
        }

        if (string.IsNullOrEmpty(value))
        {
            WritePackedUInt(0);
            return;
        }

        if (!PooledStrings.TryGetValue(value, out var index))
            throw new ArgumentException(value + " was not pooled!");

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

    public void WriteVector3(Vector3 value)
    {
        WritePackedFloat(value.x);
        WritePackedFloat(value.y);
        WritePackedFloat(value.z);
    }

    public void WriteOrientation(Orientation value)
    {
        WriteVector3(value.Position);
        WriteVector3(value.Rotation);
        WriteVector3(value.Scale);
    }

    public void WriteStringArray(string[] array) => WriteArray(array, (w, v) => w.WriteString(v));

    public void WriteDouble(double value) => Writer.Write(value);

    public void WriteNullableDouble(double? value)
    {
        WriteBool(value.HasValue);

        if (value.HasValue)
            WriteDouble(value.Value);
    }

    public void WriteStringDictionary(Dictionary<string, string> dict) => WriteDictionary(dict, (w, v) => w.WriteString(v), (w, v) => w.WriteString(v));

    public void WriteStringToStringDictionary(Dictionary<string, Dictionary<string, string>> dict) => WriteDictionary(dict, (w, v) => w.WriteString(v), (w, v) => w.WriteStringDictionary(v));

    public void WriteNullableStringToStringDictionary(Dictionary<string, Dictionary<string, string>> dict)
    {
        var hasValue = dict != null;
        WriteBool(hasValue);

        if (hasValue)
            WriteStringToStringDictionary(dict);
    }

    public void WriteArray<T>(T[] array, Action<DataWriter, T> elementWriter)
    {
        var count = (uint)(array?.Length ?? 0);
        WritePackedUInt(count);

        if (count == 0)
            return;

        for (var i = 0; i < count; i++)
            elementWriter(this, array[i]);
    }

    public void WriteDictionary<TKey, TValue>(Dictionary<TKey, TValue> dict, Action<DataWriter, TKey> keyWriter, Action<DataWriter, TValue> valueWriter)
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

    public void WriteNullablePackedFloat(float? value)
    {
        WriteBool(value.HasValue);

        if (value.HasValue)
            WritePackedFloat(value.Value);
    }

    public void WriteNullablePackedUInt(uint? value)
    {
        WriteBool(value.HasValue);

        if (value.HasValue)
            WritePackedUInt(value.Value);
    }

    public void WriteSubstring(string value, int startIndex) => WriteString(value?.Substring(startIndex));

    public void Dispose() => Writer.Dispose();

    public void Flush() => Writer?.Flush();
}
#endif