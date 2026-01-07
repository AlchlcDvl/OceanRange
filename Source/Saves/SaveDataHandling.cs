using System.Runtime.CompilerServices;
using System.Text;

namespace OceanRange.Saves;

/// <summary>
/// A writer class that stores data and converts it into a ulong array.
/// </summary>
public sealed class SaveWriter : IDisposable
{
    private readonly MemoryStream _stream;

    // The internal writer.
    private readonly BinaryWriter _writer;

    // private byte _currentPackingByte;
    // private int _currentBitIndex;

    public SaveWriter()
    {
        _stream = new MemoryStream();
        _writer = new BinaryWriter(_stream, Encoding.UTF8);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteBool(bool value) => _writer.Write(value);

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void WriteSByte(sbyte value) => _writer.Write(value);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteByte(byte value) => _writer.Write(value);

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void WriteShort(short value) => _writer.Write(value);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteUShort(ushort value) => _writer.Write(value);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteInt(int value) => _writer.Write(value);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteUInt(uint value) => _writer.Write(value);

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void WriteLong(long value) => _writer.Write(value);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteULong(ulong value) => _writer.Write(value);

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void WriteFloat(float value) => _writer.Write(value);

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void WriteDouble(double value) => _writer.Write(value);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteString(string value) => _writer.Write(value ?? string.Empty);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public void WriteEnum<T>(T value) where T : struct, Enum => SaveWriterDels.Enum<T>.Func(this, value);

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void WriteVector3(Vector3 value)
    // {
    //     _writer.Write(value.x);
    //     _writer.Write(value.y);
    //     _writer.Write(value.z);
    // }

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void WriteQuaternion(Quaternion value)
    // {
    //     _writer.Write(value.x);
    //     _writer.Write(value.y);
    //     _writer.Write(value.z);
    //     _writer.Write(value.w);
    // }

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void ResetPackingBools()
    // {
    //     _currentPackingByte = 0;
    //     _currentBitIndex = 0;
    // }

    // public void WritePackedBool(bool value)
    // {
    //     if (value)
    //         _currentPackingByte |= (byte)(1 << _currentBitIndex);

    //     _currentBitIndex++;

    //     if (_currentBitIndex == 8)
    //     {
    //         _writer.Write(_currentPackingByte);
    //         ResetPackingBools();
    //     }
    // }

    // public void EndPackingBools()
    // {
    //     if (_currentBitIndex > 0)
    //         _writer.Write(_currentPackingByte);

    //     ResetPackingBools();
    // }

    public void Dispose()
    {
        _writer.Dispose();
        _stream.Dispose();
        // ReSharper disable once GCSuppressFinalizeForTypeWithoutDestructor
        GC.SuppressFinalize(this);
    }

    public ulong[] ToArray(out byte padding)
    {
        var array = _stream.ToArray();
        padding = (byte)((8 - (array.Length % 8)) % 8);
        var totalBytes = array.Length + padding;
        var ulongArray = new ulong[totalBytes / 8];
        Buffer.BlockCopy(array, 0, ulongArray, 0, array.Length);
        return ulongArray;
    }
}

/// <summary>
/// A reader class that de-serializes a ulong array and allows reading of various data types.
/// </summary>
public sealed class SaveReader : IDisposable
{
    private readonly MemoryStream _stream;
    private readonly BinaryReader _reader;

    private byte _currentPackedByte;
    private int _currentBitIndex = 8;

    /// <summary>
    /// Initializes a new instance of the SaveReader with a ulong array.
    /// </summary>
    /// <param name="data">The ulong array to read from.</param>
    /// <param name="padding">The number of padding bytes to remove.</param>
    public unsafe SaveReader(ulong[] data, byte padding)
    {
        var totalBytes = (data.Length * 8) - padding;
        var byteData = new byte[totalBytes];

        fixed (byte* dest = byteData)
        {
            fixed (ulong* src = data)
                Buffer.MemoryCopy(src, dest, totalBytes, totalBytes);
        }
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public byte ReadByte() => _reader.ReadByte();

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public sbyte ReadSByte() => _reader.ReadSByte();

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public int ReadInt() => _reader.ReadInt32();

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public long ReadLong() => _reader.ReadInt64();

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public float ReadFloat() => _reader.ReadSingle();

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public double ReadDouble() => _reader.ReadDouble();

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public short ReadShort() => _reader.ReadInt16();

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public ushort ReadUShort() => _reader.ReadUInt16();

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public uint ReadUInt() => _reader.ReadUInt32();

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public ulong ReadULong() => _reader.ReadUInt64();

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public string ReadString() => _reader.ReadString();

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public bool ReadBool() => _reader.ReadBoolean();

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    public T ReadEnum<T>() where T : struct, Enum => SaveReaderDels.Enum<T>.Func(this);

    // public bool ReadPackedBool()
    // {
    //     if (_currentBitIndex >= 8)
    //     {
    //         _currentPackedByte = _reader.ReadByte();
    //         _currentBitIndex = 0;
    //     }

    //     var value = (_currentPackedByte & (1 << _currentBitIndex)) != 0;
    //     _currentBitIndex++;
    //     return value;
    // }

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void EndPackingBools() => _currentBitIndex = 8;

    // [MethodImpl(MethodImplOptions.AggressiveInlining)]
    // public void Skip(int count) => _stream.Position += count;

    public void Dispose()
    {
        _reader.Dispose();
        _stream.Dispose();
        // ReSharper disable once GCSuppressFinalizeForTypeWithoutDestructor
        GC.SuppressFinalize(this);
    }
}