namespace OceanRange.Saves;

/// <summary>
/// A writer class that stores data and converts it into a ulong array.
/// </summary>
public sealed class SaveWriter
{
    // The internal writer.
    private readonly List<byte> Bytes = [];

    // Write methods for various data types. More to come as more and more data types are added
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
        var totalBytes = Bytes.Count + padding;
        var ulongArray = new ulong[totalBytes / 8];
        Buffer.BlockCopy(Bytes.ToArray(), 0, ulongArray, 0, Bytes.Count);
        return ulongArray;
    }
}

/// <summary>
/// A reader class that de-serializes a ulong array and allows reading of various data types.
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
    public unsafe SaveReader(ulong[] data, byte padding)
    {
        var totalBytes = (data.Length * 8) - padding;
        Data = new byte[totalBytes];

        fixed (byte* dest = Data)
        {
            fixed (ulong* src = data)
                Buffer.MemoryCopy(src, dest, totalBytes, totalBytes);
        }
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