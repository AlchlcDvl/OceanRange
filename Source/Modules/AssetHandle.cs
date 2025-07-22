namespace OceanRange.Modules;

public sealed class AssetHandle(string name)
{
    private readonly string Name = name;
    public readonly Dictionary<string, bool> Paths = []; // Handles asset paths, the bool flag indicates if it's from the bundle or not
    private readonly Dictionary<UObject, string> LoadedFrom = []; // Handles if assets have been loaded
    private readonly Dictionary<Type, UObject> Assets = []; // Handles loaded assets, by design assets can have the same name, but no two assets can have the same type (eg, there' can't be two of Plort.png anywhere)

    public T Load<T>(bool throwError = true) where T : UObject
    {
        var tType = typeof(T);

        if (Assets.TryGetValue(tType, out var asset))
            return asset as T;

        if (!AssetManager.AssetTypeExtensions.TryGetValue(tType, out var generator))
            return throwError ? throw new NotSupportedException($"{tType.Name} is not a valid asset type to load") : null;

        if (!Paths.TryFinding(x => x.Key.EndsWith(generator.Extension), out var tuple))
            return throwError ? throw new FileNotFoundException($"There's no such {tType.Name} asset for {Name}") : null;

        asset = (tuple.Value ? AssetManager.Bundle.LoadAsset<T> : generator.LoadAsset)(tuple.Key);

        if (asset)
        {
            LoadedFrom.Add(asset, tuple.Key);
            Assets.Add(tType, asset);
        }
        else
            return throwError ? throw new InvalidOperationException($"Something happened while trying to load {Name} of type {tType.Name}!") : null;

        asset.name = Name;
        return asset.DontDestroy() as T;
    }

    public void Unload<T>() where T : UObject
    {
        var tType = typeof(T);

        if (!Assets.TryGetValue(tType, out var asset))
            return;

        LoadedFrom.Remove(asset);
        Assets.Remove(tType);
        asset.Destroy();
    }
}