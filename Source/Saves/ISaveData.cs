namespace OceanRange.Saves;

/// <summary>Defines a contract for objects that can be serialized to and deserialized from a compact array of unsigned 64-bit integers.</summary>
public interface ISaveData
{
    /// <summary>Gets a value indicating whether this data format is deprecated.</summary>
    /// <value><c>true</c> if the data format is obsolete or no longer supported; otherwise, <c>false</c>.</value>
    bool Deprecated { get; }

    /// <summary>Serializes the object's current state into an array of unsigned long integers.</summary>
    /// <param name="padding">When this method returns, contains the byte value representing the padding applied to the final element of the array to align the data.</param>
    /// <returns>An array of <c><see cref="ulong"/></c> containing the binary representation of the object's data.</returns>
    ulong[] Write(out byte padding);

    /// <summary>Deserializes the provided data to restore the object's state.</summary>
    /// <param name="data">The array of <see cref="ulong"/> containing the serialized data to read.</param>
    /// <param name="padding">The padding value originally returned by the <see cref="Write"/> method, indicating how the final data block should be interpreted.</param>
    void Read(ulong[] data, byte padding);
}