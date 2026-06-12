namespace OceanRange.Modules;

// public sealed class PlatformComparer : IEqualityComparer<RuntimePlatform>
// {
//     public static readonly PlatformComparer Instance = new();

//     public bool Equals(RuntimePlatform id1, RuntimePlatform id2) => id1 == id2;

//     public int GetHashCode(RuntimePlatform id) => (int)id;
// }

public sealed class RancherNameComparer : IEqualityComparer<RancherName>
{
    public static readonly RancherNameComparer Instance = new();

    public bool Equals(RancherName id1, RancherName id2) => id1 == id2;

    public int GetHashCode(RancherName id) => (int)id;
}

public sealed class LanguageComparer : IEqualityComparer<Language>
{
    public static readonly LanguageComparer Instance = new();

    public bool Equals(Language id1, Language id2) => id1 == id2;

    public int GetHashCode(Language id) => (int)id;
}

public sealed class LoadStateComparer : IEqualityComparer<LoadState>
{
    public static readonly LoadStateComparer Instance = new();

    public bool Equals(LoadState id1, LoadState id2) => id1 == id2;

    public int GetHashCode(LoadState id) => (int)id;
}