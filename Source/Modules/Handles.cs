namespace OceanRange.Modules;

/// <summary>
/// The handle class specialised to handle mod assets.
/// </summary>
/// <inheritdoc cref="Handle"/>
public sealed class AssetHandle(string name) : Handle(name)
{
    /// <summary>
    /// Contains the manifest paths of the assets.
    /// </summary>
    private readonly List<string> Paths = [];

    /// <summary>
    /// Attempts to add an asset path to the handle.
    /// </summary>
    /// <param name="path">The path to add.</param>
    /// <exception cref="ArgumentException">Thrown if the path contains a file extension that's already been added.</exception>
    public void AddPath(string path)
    {
        var extension = path.TrueSplit('.').Last();

        if (Paths.Any(x => x.EndsWith(extension)))
            throw new ArgumentException($"Cannot add another {Name}.{extension} asset, please correct your asset naming and typing!");

        Paths.Add(path);
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
    public T Load<T>(bool throwError = true) where T : UObject
    {
        var tType = typeof(T);

        if (Assets.TryGetValue(tType, out var asset)) // Try to fetch the asset if it's already loaded
            return asset as T;

        if (!AssetManager.AssetTypeExtensions.TryGetValue(tType, out var generator)) // Check if the requested type is valid
            return throwError ? throw new NotSupportedException($"{tType.Name} is not a valid asset type to load") : null;

        if (!Paths.TryFinding(x => x.EndsWith(generator.Extension), out var path)) // Check if there's an asset path that maps to the relevant file extension
            return throwError ? throw new FileNotFoundException($"There's no such {tType.Name} asset for {Name}") : null;

        asset = generator.LoadAsset(path); // Create the asset

        // Save the asset if not null, otherwise throw an error
        if (!asset)
            return throwError ? throw new InvalidOperationException($"Something happened while trying to load {Name} of type {tType.Name}!") : null;

        Assets.Add(tType, asset);
        asset.name = Name; // Set name
        return (T)asset.DontDestroy(); // Allow the asset to persist across scene loads and return
    }

    /// <summary>
    /// Unloads the asset of the requested type to free up some memory.
    /// </summary>
    /// <typeparam name="T">The type of the asset.</typeparam>
    /// <param name="throwError">The flag that indicates if an error should be thrown.</param>
    /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided type.</exception>
    public void Unload<T>(bool throwError = true) where T : UObject
    {
        var tType = typeof(T);

        if (Assets.Remove(tType, out var asset))
            asset.Destroy();
        else if (throwError)
            throw new FileLoadException($"Not such asset {Name} of type {tType.Name} was loaded!");
    }

    /// <inheritdoc/>
    protected override void OnDisposal()
    {
        Paths.Clear();
        Assets.Values.Do(x => x.Destroy());
    }
}

/// <summary>
/// The handle class specialised to handle game assets.
/// </summary>
/// <inheritdoc cref="Handle"/>
public sealed class ResourceHandle(string name) : Handle(name)
{
    /// <summary>
    /// Loads and returns an asset handled by this handle.
    /// </summary>
    /// <typeparam name="T">The type of the asset.</typeparam>
    /// <param name="throwError">The flag that indicates if an error should be thrown.</param>
    /// <returns>The fetched asset.</returns>
    /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided name.</exception>
    public T Load<T>(bool throwError = true) where T : UObject
    {
        var tType = typeof(T);

        if (Assets.TryGetValue(tType, out var asset)) // Try to fetch the asset if it's already loaded
            return asset as T;

        asset = Array.Find(AssetManager.GetAllResources<T>(), x => x.name == Name); // Find the asset with the provided name among the game resources

        if (!asset) // Throw an error if null
            return throwError ? throw new FileNotFoundException($"{Name}, {tType.Name}") : null;

        // Save and return the asset
        Assets.Add(tType, asset);
        return (T)asset;
    }

    // /// <summary>
    // /// Unloads the asset of the requested type to free up some memory.
    // /// </summary>
    // /// <typeparam name="T">The type of the asset.</typeparam>
    // public void Unload<T>() where T : UObject => Assets.Remove(typeof(T));
}

/// <summary>
/// Base handle class for better encapsulation between the two handle types.
/// </summary>
/// <param name="name">The collective name of the assets contained by this handle.</param>
public abstract class Handle(string name) : IDisposable
{
    /// <summary>
    /// The collective name of the assets contained by this handle.
    /// </summary>
    protected readonly string Name = name;

    /// <summary>
    /// Handles loaded assets, by design assets can have the same name, but no two assets can have the same type (eg, there can't be two of Plort.png anywhere).
    /// </summary>
    protected readonly Dictionary<Type, UObject> Assets = [];

    /// <summary>
    /// An event that's invoked when the handle is being released. Use to free up any additional memory before the disposal is finalised.
    /// </summary>
    protected virtual void OnDisposal() { }

    /// <inheritdoc cref="IDisposable.Dispose"/>
    public void Dispose()
    {
        OnDisposal();
        Assets.Clear();
        GC.SuppressFinalize(this);
    }
}