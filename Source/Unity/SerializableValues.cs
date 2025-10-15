namespace OceanRange.Unity.Json;

[Serializable]
public abstract class SerializableKeyValuePair<TKey, TValue>
{
    public TKey Key;
    public TValue Value;

    public void Deconstruct(out TKey key, out TValue value)
    {
        key = Key;
        value = Value;
    }
}

[Serializable]
public sealed class SerializableStringColorPair : SerializableKeyValuePair<string, Color>;

[Serializable]
public sealed class SerializableStringStringPair : SerializableKeyValuePair<string, string>;

[Serializable]
public sealed class SerializableStringStringArrayPair : SerializableKeyValuePair<string, string[]>;

[Serializable]
public sealed class SerializableStringVector3ArrayPair : SerializableKeyValuePair<string, Vector3[]>;

[Serializable]
public sealed class SerializableStringZoneRequirementDataPair : SerializableKeyValuePair<string, ZoneRequirementData>;

[Serializable]
public sealed class SerializableStringStringPairListPair : SerializableKeyValuePair<string, List<SerializableStringStringPair>>;

[Serializable]
public sealed class SerializableStringStringPairListPairListPair : SerializableKeyValuePair<string, List<SerializableStringStringPairListPair>>;

[Serializable]
public sealed class SerializableStringStringVector3ArrayPairListPair : SerializableKeyValuePair<string, List<SerializableStringVector3ArrayPair>>;