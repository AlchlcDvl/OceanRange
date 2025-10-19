using System.Reflection;
using SRML.Utils;
using System.IO.Compression;
using System.Text;
using Newtonsoft.Json.Serialization;

namespace OceanRange.Managers;

/// <summary>
/// The main manager class that handles assets, be it from the game or the mod itself.
/// </summary>
public static class Inventory
{
    public static AssetBundle Bundle;

    /// <summary>
    /// Assembly data for the mod's dll.
    /// </summary>
    public static readonly Assembly Core = typeof(Main).Assembly;

    /// <summary>
    /// Common json serialisation settings to avoid creating a new json settings instance for each json file.
    /// </summary>
    public static readonly JsonSerializerSettings JsonSettings = new()
    {
#if DEBUG
        // Only add indentation specification if it's in debug mode for asset dumping, because there's no need for such a thing to happen in the release build
        Formatting = Formatting.Indented,
#endif
        ContractResolver = new DefaultContractResolver()
        {
            NamingStrategy = new CamelCaseNamingStrategy(false, false)
        },
        // Adding the json converters
        Converters =
        [
            new EnumConverter(),
            new TypeConverter(),
            new ColorConverter(),
            // new Color32Converter(), // Unused at the moment, but kept around if needed
            new Vector3Converter(),
            new OrientationConverter(),
        ]
    };

    private static readonly Dictionary<RuntimePlatform, string> Platforms = new(PlatformComparer.Instance)
    {
        [RuntimePlatform.OSXPlayer] = "mac",
        [RuntimePlatform.LinuxPlayer] = "lin",
        [RuntimePlatform.WindowsPlayer] = "win",
    };

    private static readonly string BundleSuffix = "bundle_" +
    (
        Platforms.TryGetValue(Application.platform, out var suffix)
        ? suffix
        : throw new PlatformNotSupportedException(Application.platform.ToString())
    );

    /// <summary>
    /// Very basic mapping of types to relevant file extensions and how they are loaded.
    /// </summary>
    public static readonly SoftTypeDictionary<(string[] Extensions, Func<string, UObject> LoadAsset)> AssetTypeExtensions = new()
    {
        // Embedded resources
        [typeof(Json)] = (["json"], LoadJson),
        [typeof(Mesh)] = (["cmesh"], LoadMesh),
        [typeof(Sprite)] = (["png", "jpg"], LoadSprite),
        [typeof(Texture2D)] = (["png", "jpg"], LoadTexture2D),

        [typeof(AssetBundle)] = ([BundleSuffix], LoadBundle), // Simple asset bundle loading

        // Bundle resources
        [typeof(Shader)] = (["shader"], GetBundleAsset<Shader>),
        [typeof(GameObject)] = (["prefab"], GetBundleAsset<GameObject>),
        [typeof(Material)] = (["mat"], GetBundleAsset<Material>),
        [typeof(ScriptableObject)] = (["asset"], GetBundleAsset<ScriptableObject>),

        // AudioClip is not currently in use
        // [typeof(AudioClip)] = (["wav"], LoadAudioClip),
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

    private static readonly string[] Extensions = [.. AssetTypeExtensions.Values.SelectMany(x => x.Extensions).Union(Platforms.Select(x => "bundle_" + x))];

    /// <summary>
    /// Debug string path for the mod to dump assets.
    /// </summary>
    public static readonly string DumpPath = Path.Combine(Path.GetDirectoryName(Application.dataPath)!, "OceanRange");

    /// <summary>
    /// Initialises the asset handling by creating relevant handles.
    /// </summary>
#if DEBUG
    [TimeDiagnostic("Assets Initialis")]
#endif
    public static void InitialiseAssets()
    {
        Array.ForEach(Core.GetManifestResourceNames(), CreateAssetHandle); // Create handles for embedded resources

        Bundle = Get<AssetBundle>("ocean_range"); // Ensures the bundle is loaded first
        Array.ForEach(Bundle.GetAllAssetNames(), CreateAssetHandle); // Create handles for bundles resources

        if (!Directory.Exists(DumpPath))
            Directory.CreateDirectory(DumpPath);
    }

    public static void TryReleaseHandles(params string[] handles)
    {
        try
        {
            ReleaseHandles(handles);
        }
        catch { }
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
            if (Assets.TryRemove(handleName, out var handle))
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
    private static string SanitisePath(this string path) => path
        .ReplaceAll("", Extensions) // Removing the file extension first
        .TrueSplit('/', '\\', '.').Last(); // Split by directories (/ for Windows/Linux/AssetBundle/Urls, \ for Mac, . for Embedded) and get the last entry which should be the asset name
    /// <summary>
    /// Gets and serialise json data from the asset associated with the provided name.
    /// </summary>
    /// <typeparam name="T">The type to deserialise to.</typeparam>
    /// <param name="path">The name of the asset.</param>
    /// <returns>The read and converted json data.</returns>
    public static T[] GetJsonArray<T>(string path) => GetJson<T[]>(path);

    /// <summary>
    /// Gets and serialise json data from the asset associated with the provided name.
    /// </summary>
    /// <typeparam name="T">The type to deserialise to.</typeparam>
    /// <param name="path">The name of the asset.</param>
    /// <returns>The read and converted json data.</returns>
    public static T GetJson<T>(string path) => ToJson<T>(TryReadJson(path, out var contents) ? contents : Get<Json>(path).text);

    public static bool TryGetJson<T>(string name, out T json, bool writeJson)
    {
        var path = Path.Combine(DumpPath, name + ".json");

        if (File.Exists(path))
        {
            json = ToJson<T>(File.ReadAllText(path));
            return true;
        }

        if (!TryGet<Json>(name, out var jsonText))
        {
            json = default;
            return false;
        }

        var raw = jsonText.text;
        json = ToJson<T>(raw);

        if (writeJson)
            File.WriteAllText(path, raw);

        return true;
    }

    private static T ToJson<T>(string jsonText)
    {
        using var stringReader = new StringReader(jsonText);
        using var jsonTextReader = new JsonTextReader(stringReader);
        return JsonSerializer.Create(JsonSettings).Deserialize<T>(jsonTextReader);
    }

    private static bool TryReadJson(string fileName, out string contents)
    {
        var path = Path.Combine(DumpPath, fileName + ".json");

        if (!File.Exists(path))
        {
            contents = null;
            return false;
        }

        contents = File.ReadAllText(path);
        return true;
    }

    /// <summary>
    /// Gets a Texture2D from the assets associated with the provided name.
    /// </summary>
    /// <inheritdoc cref="Get{T}(string)"/>
    public static Texture2D GetTexture2D(string name) => Get<Texture2D>(name);

    /// <summary>
    /// Gets a Sprite from the assets associated with the provided name.
    /// </summary>
    /// <inheritdoc cref="Get{T}(string)"/>
    public static Sprite GetSprite(string name) => Get<Sprite>(name);

    /// <summary>
    /// Gets a collection of sprites with the provided names.
    /// </summary>
    /// <param name="names">The names of the assets.</param>
    /// <returns>A collection of sprites.</returns>
    public static IEnumerable<Sprite> GetSprites(params string[] names) => GetAll<Sprite>(names);

    /// <summary>
    /// Gets a Mesh from the assets associated with the provided name.
    /// </summary>
    /// <inheritdoc cref="Get{T}(string)"/>
    public static Mesh GetMesh(string name)
    {
        var mesh = Get<Mesh>(name);
        return mesh.bindposes.Length == 0 ? mesh : mesh.Clone();
    }

    /// <summary>
    /// Gets a Shader from the assets associated with the provided name.
    /// </summary>
    /// <inheritdoc cref="Get{T}(string)"/>
    public static Shader GetShader(string name) => Get<Shader>(name);

    /// <summary>
    /// Gets a ScriptableObject instance associated with the provided type and name.
    /// </summary>
    /// <typeparam name="T">The type of the data.</typeparam>
    /// <inheritdoc cref="Get{T}(string)"/>
    public static T GetScriptable<T>(string name) where T : ScriptableObject => Get<T>(name.ToLowerInvariant());

    public static GameObject GetPrefab(string name) => Get<GameObject>(name.ToLowerInvariant());

    private static IEnumerable<T> GetAll<T>(params string[] names) where T : UObject => names.Select(Get<T>);

    /// <summary>
    /// Attempts to fetch an asset of type <typeparamref name="T"/> associated with the provided name.
    /// </summary>
    /// <typeparam name="T">The type of the asset.</typeparam>
    /// <param name="name">The name of the asset.</param>
    /// <param name="result">The fetched asset, if any.</param>
    /// <returns>true if an asset was found with the name.</returns>
    private static bool TryGet<T>(string name, out T result) where T : UObject
    {
        try
        {
            result = Get<T>(name);
            return true;
        }
        catch
        {
            result = null;
            return false;
        }
    }

    /// <summary>
    /// Gets a(n) <typeparamref name="T"/> associated with the provided name.
    /// </summary>
    /// <param name="name">The name of the asset.</param>
    /// <inheritdoc cref="AssetHandle.Load{T}"/>
    /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided name or type.</exception>
    private static T Get<T>(string name) where T : UObject
    {
        if (!Assets.TryGetValue(name, out var handle))
            throw new FileNotFoundException($"{name}, {typeof(T).Name}");

        return handle.Load<T>();
    }

    // Legacy code, it's being kept around in case it's needed for more precise control
    // /// <summary>
    // /// Unloads an asset to free up memory.
    // /// </summary>
    // /// <param name="name">The name of the asset.</param>
    // /// <param name="throwError">Flag indicating whether errors should be thrown or not.</param>
    // /// <inheritdoc cref="AssetHandle.Unload{T}"/>
    // /// <exception cref="FileNotFoundException">Thrown if there is no such asset with the provided name or type.</exception>
    // public static void UnloadAsset<T>(string name, bool throwError = true) where T : UObject
    // {
    //     if (Assets.TryGetValue(name, out var handle))
    //         handle.Unload<T>(throwError);
    //     else if (throwError)
    //         throw new FileNotFoundException($"{name}, {typeof(T).Name}");
    // }

    /// <summary>
    /// Loads a json file from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The json asset loaded from the path.</returns>
    private static Json LoadJson(string path)
    {
        using var stream = Core.GetManifestResourceStream(path)!;
        using var reader = new StreamReader(stream, Encoding.UTF8, false);
        return new(reader.ReadToEnd());
    }

    /// <summary>
    /// Loads a json file from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The json asset loaded from the path.</returns>
    private static Mesh LoadMesh(string path)
    {
        // This method uses a specially serialised version of the models to save on disk space and to make it easier to ship the mod

        using var stream = Core.GetManifestResourceStream(path)!;
        using var decompressor = new GZipStream(stream, CompressionMode.Decompress);
        using var reader = new BinaryReader(decompressor);

        return new()
        {
            vertices = BinaryUtils.ReadArray(reader, BinaryUtils.ReadVector3),
            triangles = BinaryUtils.ReadArray(reader, ReadInt),
            uv = BinaryUtils.ReadArray(reader, BinaryUtils.ReadVector2),
            bindposes = []
        };
    }

    private static int ReadInt(BinaryReader reader) => reader.ReadInt32();

    /// <summary>
    /// Loads a texture from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <param name="forSprite">Flag indicating whether the texture is being made for a sprite, so that the texture's name is preset.</param>
    /// <returns>The texture asset loaded from the path.</returns>
    private static Texture2D LoadTexture2D(string path, bool forSprite)
    {
        var texture = new Texture2D(2, 2, TextureFormat.RGBA32, true, false);

        if (!texture.LoadImage(path.ReadBytes(), true))
            return null;

        var name = path.SanitisePath();
        texture.wrapMode = GetWrapMode(name);

        if (forSprite)
        {
            texture.name = name + "_tex";
            texture.DontDestroy();
        }

        return texture;
    }

    private static Texture2D LoadTexture2D(string path) => LoadTexture2D(path, false);

    // Texture optimisation stuff
    private static TextureWrapMode GetWrapMode(string name) => name.Contains("ramp") || name.Contains("pattern") ? TextureWrapMode.Repeat : TextureWrapMode.Clamp;

    /// <summary>
    /// Loads a sprite from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The sprite asset loaded from the path.</returns>
    private static Sprite LoadSprite(string path)
    {
        var tex = LoadTexture2D(path, true);
        return tex ? Sprite.Create(tex, new(0, 0, tex.width, tex.height), new(0.5f, 0.5f), 1f, 0, SpriteMeshType.Tight) : null;
    }

    private static T GetBundleAsset<T>(string path) where T : UObject => Bundle.LoadAsset<T>(path);

    private static AssetBundle LoadBundle(string path) => AssetBundle.LoadFromMemory(path.ReadBytes());

    /// <summary>
    /// Reads all the bytes from the provided stream.
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
    /// Reads all the bytes from the provided file path.
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
            Assets[name] = handle = new(name);

        handle.AddPath(path);
    }

    // /// <summary>
    // /// Creates an asset handle for the provided asset.
    // /// </summary>
    // /// <typeparam name="T">The type of the asset.</typeparam>
    // /// <param name="path">The path of the asset.</param>
    // /// <param name="asset">The asset to automatically add to the handle.</param>
    // private static void CreateAssetHandle<T>(string path, T asset) where T : UObject
    // {
    //     var name = path.SanitisePath();

    //     if (!Assets.TryGetValue(name, out var handle))
    //         Assets[name] = handle = new(name);

    //     handle.AddPath(path);
    //     handle.AddAsset(asset);
    // }

    // Modified code from here: https://github.com/deadlyfingers/UnityWav/blob/master/WavUtility.cs

    // /// <summary>
    // /// Loads a wav audio file from the path provided.
    // /// </summary>
    // /// <param name="path">The path to the audio asset.</param>
    // /// <returns>An AudioClip representing the audio file the path points to.</returns>
    // /// <exception cref="InvalidOperationException">Thrown if the wav file had in incorrect bit depth.</exception>
    // private static AudioClip LoadAudioClip(string path)
    // {
    //     var bytes = path.ReadBytes();
    //     var chunk = BitConverter.ToInt32(bytes, 16) + 24;
    //     var channels = BitConverter.ToUInt16(bytes, 22);
    //     var sampleRate = BitConverter.ToInt32(bytes, 24);
    //     var bitDepth = BitConverter.ToUInt16(bytes, 34);
    //     var wavSize = BitConverter.ToInt32(bytes, chunk);
    //     var data = bitDepth switch
    //     {
    //         8 => AudioData8Bits(bytes, wavSize),
    //         16 => AudioData16Bits(bytes, chunk, wavSize),
    //         24 => AudioData24Bits(bytes, chunk, wavSize),
    //         32 => AudioData32Bits(bytes, chunk, wavSize),
    //         _ => throw new InvalidOperationException(bitDepth + " bit depth is not supported."),
    //     };

    //     var audioClip = AudioClip.Create(path.SanitisePath(), data.Length, channels, sampleRate, false);
    //     return audioClip.SetData(data, 0) ? audioClip : null;
    // }

    // private static float[] AudioData8Bits(byte[] source, int wavSize)
    // {
    //     var data = new float[wavSize];

    //     for (var i = 0; i < wavSize; i++)
    //         data[i] = (float)source[i] / sbyte.MaxValue;

    //     return data;
    // }

    // private static float[] AudioData16Bits(byte[] source, int headerOffset, int wavSize)
    // {
    //     headerOffset += sizeof(int);
    //     var convertedSize = wavSize / 2;
    //     var data = new float[convertedSize];

    //     for (var i = 0; i < convertedSize; i++)
    //         data[i] = (float)BitConverter.ToInt16(source, (i * 2) + headerOffset) / short.MaxValue;

    //     return data;
    // }

    // private static float[] AudioData24Bits(byte[] source, int headerOffset, int wavSize)
    // {
    //     const int intSize = sizeof(int);
    //     headerOffset += intSize;
    //     var convertedSize = wavSize / 3;
    //     var data = new float[convertedSize];
    //     var block = new byte[intSize]; // Using a 4-byte block for copying 3 bytes, then copy bytes with 1 offset

    //     for (var i = 0; i < convertedSize; i++)
    //     {
    //         Buffer.BlockCopy(source, (i * 3) + headerOffset, block, 1, 3);
    //         data[i] = (float)BitConverter.ToInt32(block, 0) / int.MaxValue;
    //     }

    //     return data;
    // }

    // private static float[] AudioData32Bits(byte[] source, int headerOffset, int wavSize)
    // {
    //     headerOffset += sizeof(int);
    //     var convertedSize = wavSize / 4;
    //     var data = new float[convertedSize];

    //     for (var i = 0; i < convertedSize; i++)
    //         data[i] = (float)BitConverter.ToInt32(source, (i * 4) + headerOffset) / int.MaxValue;

    //     return data;
    // }

#if DEBUG
    // This is all for mainly debugging stuff when I want to dump assets from the main game, uncomment for use

    // public static void Dump(this Texture texture, string path = null, string fileName = null)
    // {
    //     if (texture)
    //         File.WriteAllBytes(Path.Combine(path ?? DumpPath, (fileName ?? texture.name) + ".png"), texture.Decompress().EncodeToPNG());
    // }

    // public static void Dump(this Sprite sprite, string path = null, string fileName = null) => sprite.texture.Dump(path, fileName);

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