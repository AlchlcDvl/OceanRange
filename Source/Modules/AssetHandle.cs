namespace OceanRange.Modules;

/// <summary>
/// The handle class specialised to handle mod assets.
/// </summary>
public sealed class AssetHandle(string name) : IDisposable
{
    /// <summary>
    /// Contains the manifest paths of the assets.
    /// </summary>
    private readonly Dictionary<string, string> Paths = [];

    /// <summary>
    /// The collective name of the assets contained by this handle.
    /// </summary>
    private readonly string Name = name;

    /// <summary>
    /// Handles loaded assets, by design assets can have the same name, but no two assets can have the same type (eg, there can't be two of Plort.png anywhere).
    /// </summary>
    private readonly Dictionary<Type, UObject> Assets = [];

    /// <summary>
    /// Flag that indicates whether the handle is disposed of.
    /// </summary>
    private bool Disposed;

    /// <summary>
    /// Destructor.
    /// </summary>
    ~AssetHandle() => InternalDispose();

    /// <inheritdoc/>
    public void Dispose()
    {
        InternalDispose();
        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Shared disposal between the finaliser and the IDisposable.Dispose call.
    /// </summary>
    private void InternalDispose()
    {
        if (Disposed)
            return;

        Paths.Clear();

        foreach (var asset in Assets.Values)
        {
            if (asset)
                asset.Destroy();
        }

        Assets.Clear();
        Disposed = true;
    }

    /// <summary>
    /// Attempts to add an asset path to the handle.
    /// </summary>
    /// <param name="path">The path to add.</param>
    /// <exception cref="ArgumentException">Thrown if the path contains a file extension that's already been added.</exception>
    public void AddPath(string path)
    {
        if (Disposed)
            throw new ObjectDisposedException(Name);

        var extension = Path.GetExtension(path).Replace(".", "");

        if (Inventory.ExclusiveExtensions.TryGetValue(extension, out var other) && Paths.ContainsKey(other))
            throw new ArgumentException($"Cannot add another {Name}.{extension} asset, because {Name}.{other} is already registered! Please correct your asset typing! (path: {path}, step: TryGetValue/ContainsKey)");

        if (!Paths.TryAdd(extension, path))
            throw new ArgumentException($"Cannot add another {Name}.{extension} asset, please correct your asset naming and typing! (path: {path}, step: TryAdd)");
    }

    // /// <summary>
    // /// Adds an asset to the handle.
    // /// </summary>
    // /// <typeparam name="T">The type of the asset.</typeparam>
    // /// <param name="asset">The asset to add.</param>
    // public void AddAsset<T>(T asset) where T : UObject
    // {
    //     var tType = typeof(T);

    //     if (Assets.TryGetValue(tType, out var tAsset))
    //     {
    //         Main.Console.LogWarning($"Replacing existing asset! {tType.Name}:{tAsset.name}");
    //         tAsset.Destroy();
    //     }

    //     Assets[tType] = asset;
    // }

    /// <summary>
    /// Loads and returns an asset handled by this handle.
    /// </summary>
    /// <typeparam name="T">The type of the asset.</typeparam>
    /// <returns>The fetched <typeparamref name="T"/>.</returns>
    /// <exception cref="NotSupportedException">Thrown if an invalid asset type was requested.</exception>
    /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided type.</exception>
    /// <exception cref="InvalidOperationException">Thrown if the asset was not loaded properly for reasons unknown.</exception>
    public T Load<T>() where T : UObject
    {
        if (Disposed)
            throw new ObjectDisposedException(Name);

        var tType = typeof(T);

        if (Assets.TryGetValue(tType, out var asset)) // Try to fetch the asset if it's already loaded
            return (T)asset;

        if (!Inventory.AssetTypeExtensions.TryGetEquivalentValue(tType, out var generator)) // Check if the requested type is valid
            throw new NotSupportedException($"{tType.Name} is not a valid asset type to load");

        if (!Paths.TryGetValue(generator.Extensions, out var path)) // Check if there's an asset path that maps to the relevant file extension
            throw new FileNotFoundException($"There's no such {tType.Name} asset for {Name}");

        asset = generator.LoadAsset(path); // Create the asset

        // Save the asset if not null, otherwise throw an error
        if (!asset)
            throw new InvalidOperationException($"The load function for asset '{Name}' of type '{tType.Name}' returned null. Path: {path}");

        Assets.Add(tType, asset);

        // Set name and allow persistence
        asset.name = Name;
        return (T)asset.DontDestroy();
    }

    // Legacy code, retained for potential future use
    // /// <summary>
    // /// Unloads the asset of the requested type to free up some memory.
    // /// </summary>
    // /// <typeparam name="T">The type of the asset.</typeparam>
    // /// <param name="throwError">The flag that indicates if an error should be thrown.</param>
    // /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided type.</exception>
    // public void Unload<T>(bool throwError = true) where T : UObject
    // {
    //     if (Disposed)
    //         throw new ObjectDisposedException(Name);

    //     var tType = typeof(T);

    //     if (Assets.TryRemove(tType, out var asset))
    //         asset.Destroy();
    //     else if (throwError)
    //         throw new FileLoadException($"No such asset {Name} of type {tType.Name} was loaded!");
    // }
}