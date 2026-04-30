namespace OceanRange.Data;

public sealed class DataWriter(BinaryWriter writer) : IDisposable
{
    private readonly BinaryWriter Writer = writer;
    private readonly Dictionary<string, uint> PooledStrings = [];
    private int Index = 1;

    public void PoolString(string value)
    {
        if (!string.IsNullOrEmpty(value) && !PooledStrings.ContainsKey(value))
            PooledStrings[value] = (uint)Index++;
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

        WritePackedInt((uint)Index);

        foreach (var value in PooledStrings.Keys)
            Writer.Write(value);
    }

    public void WriteBool(bool value) => Writer.Write(value);

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

    public void WritePackedInt(uint value) => WriteVarInt(value);

    public void WriteString(string value)
    {
        if (PooledStrings.Count == 0)
        {
            Writer.Write(value ?? string.Empty);
            return;
        }

        if (string.IsNullOrEmpty(value))
        {
            WritePackedInt(0);
            return;
        }

        if (!PooledStrings.TryGetValue(value, out var index))
            throw new ArgumentException(value + " was not pooled!");

        WritePackedInt(index);
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

    public void Dispose() => Writer.Dispose();

    public void Flush() => Writer?.Flush();
}