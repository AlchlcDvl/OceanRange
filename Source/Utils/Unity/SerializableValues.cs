namespace OceanRange.Data.Unity;

[Serializable]
public abstract class StringDictEntry<TValue>
{
    public string Key;
    public TValue Value;

    public void Deconstruct(out string key, out TValue value)
    {
        key = Key;
        value = Value;
    }
}

[Serializable]
public sealed class StringColorDictEntry : StringDictEntry<Color>;

[Serializable]
public sealed class StringStringDictEntry : StringDictEntry<string>;

[Serializable]
public sealed class StringStringArrayDictEntry : StringDictEntry<string[]>;

[Serializable]
public sealed class StringVector3ArrayDictEntry : StringDictEntry<Vector3[]>;

[Serializable]
public sealed class StringZoneRequirementDataDictEntry : StringDictEntry<ZoneRequirementData>;

[Serializable]
public sealed class NestedStringStringDictEntryLayer1 : StringDictEntry<List<StringStringDictEntry>>;

[Serializable]
public sealed class NestedStringVector3ArrayDictEntry : StringDictEntry<List<StringVector3ArrayDictEntry>>;

[Serializable]
public sealed class NestedStringStringDictEntryLayer2 : StringDictEntry<List<NestedStringStringDictEntryLayer1>>;