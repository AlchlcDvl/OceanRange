namespace OceanRange.Saves;

/// <summary>
/// A writer class that compresses data and converts it into a ulong array.
/// </summary>
public sealed class SaveWriter
{
    // The internal streams and writer.
    private readonly List<byte> Bytes = [];

    // Write methods for various data types.
    public void Write(bool value) => Bytes.Add((byte)(value ? 1 : 0));

    public void Write(int value) => Bytes.AddRange(BitConverter.GetBytes(value));

    /// <summary>
    /// Flushes and closes all internal streams, then converts the compressed data
    /// into a ulong array with padding.
    /// </summary>
    /// <returns>A ulong[] that represents the data that was fed.</returns>
    public ulong[] ToArray(out byte padding)
    {
        padding = (byte)((8 - (Bytes.Count % 8)) % 8);
        var paddedData = new byte[Bytes.Count + padding];

        for (var i = 0; i < Bytes.Count; i++)
            paddedData[i] = Bytes[i];

        var ulongArray = new ulong[paddedData.Length / 8];

        for (var i = 0; i < paddedData.Length; i += 8)
            ulongArray[i / 8] = BitConverter.ToUInt64(paddedData, i);

        return ulongArray;
    }
}

/// <summary>
/// A reader class that de-serializes a ulong array, decompresses it,
/// and allows reading of various data types.
/// </summary>
public sealed class SaveReader
{
    private readonly byte[] Data;
    private int Position;

    /// <summary>
    /// Initializes a new instance of the CompressedUlongArrayReader with a ulong array.
    /// </summary>
    /// <param name="data">The ulong array to read from.</param>
    /// <param name="padding">The number of padding bytes to remove.</param>
    public SaveReader(ulong[] data, byte padding)
    {
        var totalBytes = data.Length * 8;
        var list = new List<byte>(totalBytes);

        foreach (var val in data)
            list.AddRange(BitConverter.GetBytes(val));

        var limit = totalBytes - padding;

        while (totalBytes-- > limit)
            list.RemoveAt(totalBytes - 1);

        Data = [.. list];
    }

    // Read methods for various data types.
    public bool ReadBoolean() => Data[Position++] != 0;

    public int ReadInt32()
    {
        var result = BitConverter.ToInt32(Data, Position);
        Position += 4;
        return result;
    }
}