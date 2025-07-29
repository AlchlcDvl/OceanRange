namespace OceanRange.Modules;

/// <summary>
/// The handle class specialised to handle mod assets.
/// </summary>
/// <inheritdoc cref="Handle"/>
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
    private readonly Dictionary<Type, OceanAsset> Assets = [];

    /// <inheritdoc cref="IDisposable.Dispose"/>
    public void Dispose()
    {
        Paths.Clear();

        foreach (var asset in Assets.Values)
            asset.BoxedAsset.Destroy();

        Assets.Clear();
        GC.SuppressFinalize(this);
    }

    /// <summary>
    /// Attempts to add an asset path to the handle.
    /// </summary>
    /// <param name="path">The path to add.</param>
    /// <exception cref="ArgumentException">Thrown if the path contains a file extension that's already been added.</exception>
    public void AddPath(string path, string extension)
    {
        if ((AssetManager.ExclusiveExtensions.TryGetValue(extension, out var other) && Paths.ContainsKey(other)) || !Paths.TryAdd(extension, path))
            throw new ArgumentException($"Cannot add another {Name}.{extension} asset, please correct your asset naming and typing!");
    }

    /// <summary>
    /// Loads and returns an asset handled by this handle.
    /// </summary>
    /// <typeparam name="T">The type of the asset.</typeparam>
    /// <param name="throwError">The flag that indicates if an error should be thrown.</param>
    /// <returns>The fetched asset.</returns>
    /// <exception cref="NotSupportedException">Thrown if an invalid asset type was requested.</exception>
    /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided type.</exception>
    /// <exception cref="InvalidOperationException">Thrown if the asset was not loaded properly for reasons unknown.</exception>
    public T Load<T>(bool throwError = true) where T : OceanAsset
    {
        var tType = typeof(T);

        if (Assets.TryGetValue(tType, out var asset)) // Try to fetch the asset if it's already loaded
            return (T)asset;

        if (!AssetManager.AssetTypeExtensions.TryGetValue(tType, out var generator)) // Check if the requested type is valid
            return throwError ? throw new NotSupportedException($"{tType.Name} is not a valid asset type to load") : default;

        if (!Paths.TryGetValue(generator.Extension, out var path)) // Check if there's an asset path that maps to the relevant file extension
            return throwError ? throw new FileNotFoundException($"There's no such {tType.Name} asset for {Name}") : default;

        asset = generator.LoadAsset(path); // Create the asset

        // Save the asset if not null, otherwise throw an error
        if (asset == null)
            return throwError ? throw new InvalidOperationException($"Something happened while trying to load {Name} of type {tType.Name}!") : default;

        Assets.Add(tType, asset);

        // Set name and allow persistence
        asset.BoxedAsset.name = Name;
        asset.BoxedAsset.DontDestroy();
        return (T)asset;
    }

    /// <summary>
    /// Unloads the asset of the requested type to free up some memory.
    /// </summary>
    /// <typeparam name="T">The type of the asset.</typeparam>
    /// <param name="throwError">The flag that indicates if an error should be thrown.</param>
    /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided type.</exception>
    public void Unload<T>(bool throwError = true) where T : OceanAsset
    {
        var tType = typeof(T);

        if (Assets.Remove(tType, out var asset))
            asset.BoxedAsset.Destroy();
        else if (throwError)
            throw new FileLoadException($"Not such asset {Name} of type {tType.Name} was loaded!");
    }
}