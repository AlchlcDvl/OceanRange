namespace OceanRange.Modules;

public sealed class AssetHandle(string name) : Handle(name)
{
    private readonly List<string> Paths = []; // Handles asset paths

    public void AddPath(string path)
    {
        var extension = path.TrueSplit('.').Last();

        if (Paths.Any(x => x.EndsWith(extension)))
            throw new InvalidOperationException($"Cannot add another {Name}.{extension} asset, please correct your asset naming and typing!");

        Paths.Add(path);
    }

    public T Load<T>(bool throwError = true) where T : UObject
    {
        var tType = typeof(T);

        if (Assets.TryGetValue(tType, out var asset))
            return asset as T;

        if (!AssetManager.AssetTypeExtensions.TryGetValue(tType, out var generator))
            return throwError ? throw new NotSupportedException($"{tType.Name} is not a valid asset type to load") : null;

        if (!Paths.TryFinding(x => x.EndsWith(generator.Extension), out var path))
            return throwError ? throw new FileNotFoundException($"There's no such {tType.Name} asset for {Name}") : null;

        asset = generator.LoadAsset(path);

        if (asset)
            Assets.Add(tType, asset);
        else
            return throwError ? throw new InvalidOperationException($"Something happened while trying to load {Name} of type {tType.Name}!") : null;

        asset.name = Name;
        return asset.DontDestroy() as T;
    }

    public void Unload<T>() where T : UObject
    {
        var tType = typeof(T);

        if (Assets.Remove(tType, out var asset))
            asset.Destroy();
    }
}

public sealed class ResourceHandle(string name) : Handle(name)
{
    public T Load<T>(bool throwError = true) where T : UObject
    {
        var tType = typeof(T);

        if (Assets.TryGetValue(tType, out var asset))
            return asset as T;

        asset = Array.Find(AssetManager.GetAllResources<T>(), x => x.name == Name);

        if (!asset)
            return throwError ? throw new FileNotFoundException($"{Name}, {tType.Name}") : null;

        Assets.Add(tType, asset);
        return (T)asset;
    }

    // public void Unload<T>() where T : UObject => Assets.Remove(typeof(T));
}

public abstract class Handle(string name)
{
    protected readonly string Name = name;
    protected readonly Dictionary<Type, UObject> Assets = []; // Handles loaded assets, by design assets can have the same name, but no two assets can have the same type (eg, there can't be two of Plort.png anywhere)
}