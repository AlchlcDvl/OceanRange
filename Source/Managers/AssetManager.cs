using System.Reflection;
using SRML.Utils;
using System.IO.Compression;

namespace OceanRange.Managers;

/// <summary>
/// The main manager class that handles assets, be it from the game or the mod itself.
/// </summary>
public static class AssetManager
{
    /// <summary>
    /// Assembly data for the mod's dll.
    /// </summary>
    public static readonly Assembly Core = typeof(Main).Assembly;

    /// <summary>
    /// Common json serialisation settings to avoid creating a new json settings instance for each json file.
    /// </summary>
    public static readonly JsonSerializerSettings JsonSettings = new();

    private static readonly Func<string, OceanAsset> LoadJsonDel = LoadJson;
    private static readonly Func<string, OceanAsset> LoadMeshDel = LoadMesh;
    private static readonly Func<string, OceanAsset> LoadPngSpriteDel = LoadPngSprite;
    private static readonly Func<string, OceanAsset> LoadJpgSpriteDel = LoadJpgSprite;
    private static readonly Func<string, OceanAsset> LoadPngTexture2DDel = LoadPngTexture2D;
    private static readonly Func<string, OceanAsset> LoadJpgTexture2DDel = LoadJpgTexture2D;

    /// <summary>
    /// Very basic mapping of types to relevant file extensions and how they are loaded.
    /// </summary>
    public static readonly Dictionary<Type, (string Extension, Func<string, OceanAsset> LoadAsset)> AssetTypeExtensions = new()
    {
        [typeof(JsonAsset)] = ("json", LoadJsonDel),
        [typeof(MeshAsset)] = ("mesh", LoadMeshDel),
        [typeof(PngSprite)] = ("png", LoadPngSpriteDel),
        [typeof(JpgSprite)] = ("jpg", LoadJpgSpriteDel),
        [typeof(PngTexture2D)] = ("png", LoadPngTexture2DDel),
        [typeof(JpgTexture2D)] = ("jpg", LoadJpgTexture2DDel),
        // AudioClip is not currently in use, so implementation for it comes later
    };

    /// <summary>
    /// Handles the mapping of extensions that essentially mean the same thing.
    /// </summary>
    public static readonly Dictionary<string, string> ExclusiveExtensions = new()
    {
        ["png"] = "jpg",
        ["jpg"] = "png"
    };

    /// <summary>
    /// Dictionary to hold handles for mod assets.
    /// </summary>
    private static readonly Dictionary<string, AssetHandle> Assets = [];

    /// <summary>
    /// Handles mapping file names to their respective extensions
    /// </summary>
    private static readonly Dictionary<string, HashSet<string>> NamesToExtensions = [];

#if DEBUG
    /// <summary>
    /// Debug string path for the mod to dump assets.
    /// </summary>
    public static readonly string DumpPath = Path.Combine(Path.GetDirectoryName(Application.dataPath)!, "SRML");

    [TimeDiagnostic("Assets Initialis")]
#endif
    /// <summary>
    /// Initialises the asset handling by creating relevant handles and creating the proper json settings.
    /// </summary>
    public static void InitialiseAssets()
    {
        // Create handles
        foreach (var path in Core.GetManifestResourceNames())
            CreateAssetHandle(path);

#if DEBUG // Only add indentation specification if it's in debug mode for asset dumping, because there's no need for such a thing to happen in the release build
        JsonSettings.Formatting = Formatting.Indented;
#endif
        // Adding the json converters
        // JsonSettings.Converters.Add(new ZoneConverter());
        JsonSettings.Converters.Add(new PediaIdConverter());
        JsonSettings.Converters.Add(new Vector3Converter());
        JsonSettings.Converters.Add(new FoodGroupConverter());
        JsonSettings.Converters.Add(new OrientationConverter());
        JsonSettings.Converters.Add(new ProgressTypeConverter());
        JsonSettings.Converters.Add(new IdentifiableIdConverter());
    }

    /// <summary>
    /// Frees up memory by releasing handles of certain assets.
    /// </summary>
    /// <param name="handles">The names of the assets to be released.</param>
    /// <exception cref="FileNotFoundException">Thrown if an asset name is not an asset shipped with the mod.</exception>
    public static void ReleaseHandles(params string[] handles)
    {
        if (handles.Length == 0)
            handles = [.. Assets.Keys];

        foreach (var handleName in handles)
        {
            if (Assets.Remove(handleName, out var handle))
                handle.Dispose(); // Releasing the handles
            else
                throw new FileNotFoundException(handleName);
        }
    }

    /// <summary>
    /// Helper method to converge all asset paths and names to a shorter string representation, aka their file names.
    /// </summary>
    /// <param name="path">The original path of the asset.</param>
    /// <returns>The lowercase name of the asset after all parts have been filtered out.</returns>
    /// <remarks>If you add in a new asset type (with its own extension), make sure to add the extension in the ReplaceAll!</remarks>
    private static string SanitisePath(this string path) => path
        .ReplaceAll("", ".png", ".json", ".mesh", ".jpg") // Removing all of the file extensions if any
        .TrueSplit('/', '\\', '.').Last() // Split by directories (/ for Windows, \ for Mac/Linux/AssetBundle, . for Embedded) and get the last entry which should be the asset name
        .ToLowerInvariant(); // Lowercase for make asset fetching case insensitive

    /// <summary>
    /// Gets and serialise json data from the assets associated with the provided name.
    /// </summary>
    /// <typeparam name="T">The type to deserialise to.</typeparam>
    /// <param name="path">The name of the asset.</param>
    /// <returns>The read and converted json data.</returns>
    public static T GetJson<T>(string path) => JsonConvert.DeserializeObject<T>(Get<JsonAsset>(path).Asset.text, JsonSettings);

    /// <summary>
    /// Gets a Texture2D from the assets associated with the provided name.
    /// </summary>
    /// <inheritdoc cref="Get"/>
    public static Texture2D GetTexture2D(string name) => ((Texture2DAsset)(NamesToExtensions["jpg"].Contains(name) ? Get<JpgTexture2D>(name) : Get<PngTexture2D>(name))).Asset;

    /// <summary>
    /// Gets a Sprite from the assets associated with the provided name.
    /// </summary>
    /// <inheritdoc cref="Get"/>
    public static Sprite GetSprite(string name) => ((SpriteAsset)(NamesToExtensions["jpg"].Contains(name) ? Get<JpgSprite>(name) : Get<PngSprite>(name))).Asset;

    public static IEnumerable<Sprite> GetSprites(params string[] names)
    {
        foreach (var name in names)
            yield return GetSprite(name);
    }

    /// <summary>
    /// Gets a Mesh from the assets associated with the provided name.
    /// </summary>
    /// <inheritdoc cref="Get"/>
    public static Mesh GetMesh(string name) => Get<MeshAsset>(name).Asset;

    /// <summary>
    /// Gets an asset associated with the provided name.
    /// </summary>
    /// <param name="name">The name of the asset.</param>
    /// <inheritdoc cref="AssetHandle.Load"/>
    /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided name or type.</exception>
    private static T Get<T>(string name, bool throwError = true) where T : OceanAsset
    {
        if (!Assets.TryGetValue(name, out var handle))
            return throwError ? throw new FileNotFoundException($"{name}, {typeof(T).Name}") : null;

        return handle.Load<T>(throwError);
    }

    /// <summary>
    /// Unloads an asset to free up memory.
    /// </summary>
    /// <param name="name">The name of the asset.</param>
    /// <inheritdoc cref="AssetHandle.Unload"/>
    /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided name or type.</exception>
    public static void UnloadAsset<T>(string name, bool throwError = true) where T : OceanAsset
    {
        if (Assets.TryGetValue(name, out var handle))
            handle.Unload<T>(throwError);
        else if (throwError)
            throw new FileNotFoundException($"{name}, {typeof(T).Name}");
    }

    /// <summary>
    /// Loads a json file from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The json asset loaded from the path.</returns>
    private static JsonAsset LoadJson(string path)
    {
        using var stream = Core.GetManifestResourceStream(path)!;
        using var reader = new StreamReader(stream);
        return new(reader.ReadToEnd());
    }

    /// <summary>
    /// Loads a json file from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The json asset loaded from the path.</returns>
    private static MeshAsset LoadMesh(string path)
    {
        // This method uses a specially serialised version of the models to save on disk space and to make it easier to ship the mod
        // TODO: Add a reverse importer for the unity project so that .mesh files can be used to import models

        using var stream = Core.GetManifestResourceStream(path)!;
        using var decompressor = new GZipStream(stream, CompressionMode.Decompress);
        using var reader = new BinaryReader(decompressor);

        var mesh = new Mesh
        {
            vertices = BinaryUtils.ReadArray(reader, ReadVector3),
            triangles = BinaryUtils.ReadArray(reader, ReadInt),
            normals = BinaryUtils.ReadArray(reader, ReadVector3),
            tangents = BinaryUtils.ReadArray(reader, ReadVector4)
        };

        for (var i = 0; i < 8; i++)
            mesh.SetUVs(i, BinaryUtils.ReadArray(reader, ReadVector2));

        return new(mesh);
    }

    // Helper fields to reduce compiler generated code and delegate overhead
    private static readonly Func<BinaryReader, int> ReadInt = ReadIntMethod;
    private static readonly Func<BinaryReader, Vector2> ReadVector2 = BinaryUtils.ReadVector2;
    private static readonly Func<BinaryReader, Vector3> ReadVector3 = BinaryUtils.ReadVector3;
    private static readonly Func<BinaryReader, Vector4> ReadVector4 = BinaryUtils.ReadVector4;

    private static int ReadIntMethod(BinaryReader reader) => reader.ReadInt32();

    // Helper to create an empty texture
    private static Texture2D EmptyTexture(TextureFormat format, bool mipChain) => new(2, 2, format, mipChain) { filterMode = FilterMode.Bilinear };

    /// <summary>
    /// Loads a texture from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The texture asset loaded from the path.</returns>
    private static Texture2D LoadTexture(string path)
    {
        var name = path.SanitisePath();
        var texture = EmptyTexture(GetFormat(name), GenerateMipChains(name));
        texture.LoadImage(path.ReadBytes(), true);
        texture.wrapMode = GetWrapMode(name);
        return texture;
    }

    private static PngTexture2D LoadPngTexture2D(string path) => new(LoadTexture(path));

    private static JpgTexture2D LoadJpgTexture2D(string path) => new(LoadTexture(path));

    // Texture optimisation stuff
    private static bool GenerateMipChains(string name) => name == "sleepingeyes" || name.Contains("ramp") || name.Contains("pattern");

    private static TextureFormat GetFormat(string name) => NamesToExtensions["jpg"].Contains(name) ? TextureFormat.DXT1 : TextureFormat.DXT5;

    private static TextureWrapMode GetWrapMode(string name) => NamesToExtensions["jpg"].Contains(name) ? TextureWrapMode.Repeat : TextureWrapMode.Clamp;

    /// <summary>
    /// Loads a sprite from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The sprite asset loaded from the path.</returns>
    private static Sprite LoadSprite(string path)
    {
        var tex = LoadTexture(path);
        return Sprite.Create(tex, new(0, 0, tex.width, tex.height), new(0.5f, 0.5f), 1f, 0, SpriteMeshType.Tight);
    }

    private static PngSprite LoadPngSprite(string path) => new(LoadSprite(path));

    private static JpgSprite LoadJpgSprite(string path) => new(LoadSprite(path));

    /// <summary>
    /// Reads all of the bytes from the provided stream.
    /// </summary>
    /// <param name="input">The stream data to serialise to bytes.</param>
    /// <returns>A byte array representing the stream.</returns>
    private static byte[] ReadFully(this Stream input)
    {
        using var ms = new MemoryStream();
        input.CopyTo(ms);
        return ms.ToArray();
    }

    /// <summary>
    /// Reads all of the bytes from the provided file path.
    /// </summary>
    /// <param name="path">The file path to serialise to bytes.</param>
    /// <returns>A byte array representing the file.</returns>
    private static byte[] ReadBytes(this string path) => Core.GetManifestResourceStream(path)!.ReadFully();

    /// <summary>
    /// Creates an asset handle for the provided asset.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    private static void CreateAssetHandle(string path)
    {
        var name = path.SanitisePath();

        if (!Assets.TryGetValue(name, out var handle))
            handle = Assets[name] = new(name);

        var extension = path.TrueSplit('.').Last();

        if (!NamesToExtensions.TryGetValue(extension, out var set))
            set = NamesToExtensions[extension] = [];

        set.Add(name);
        handle.AddPath(path, extension);
    }

#if DEBUG
    // This is all for mainly debugging stuff when I want to dump assets from the main game, uncomment for use

    // public static void Dump(this Texture texture, string path)
    // {
    //     if (texture)
    //         File.WriteAllBytes(path, texture.Decompress().EncodeToPNG());
    // }

    // public static void Dump(this Sprite sprite, string path) => sprite.texture.Dump(path);

    // public static Texture2D Decompress(this Texture source)
    // {
    //     var renderTex = RenderTexture.GetTemporary(source.width, source.height, 0, RenderTextureFormat.Default, RenderTextureReadWrite.Linear);
    //     Graphics.Blit(source, renderTex);
    //     var previous = RenderTexture.active;
    //     RenderTexture.active = renderTex;
    //     var readableText = new Texture2D(source.width, source.height);
    //     readableText.ReadPixels(new(0, 0, renderTex.width, renderTex.height), 0, 0);
    //     readableText.Apply();
    //     RenderTexture.active = previous;
    //     RenderTexture.ReleaseTemporary(renderTex);
    //     readableText.name = source.name;
    //     return readableText;
    // }
#endif
}