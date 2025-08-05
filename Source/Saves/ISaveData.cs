namespace OceanRange.Saves;

public interface ISaveData
{
    bool Deprecated { get; }

    ulong[] Write(out byte padding);

    void Read(ulong[] data, byte padding);
}