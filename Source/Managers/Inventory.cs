using System.IO.Compression;
using System.Reflection;
using UnityEngine.Rendering;

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

    private static readonly Func<string, AssetHandle> Create = name => new(name);

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
    public static readonly Dictionary<Type, (string[] Extensions, Func<string, UObject?> LoadAsset)> AssetTypeExtensions = new()
    {
        // Embedded resources
        [typeof(Json)] = (["cjson"], LoadJson),
        [typeof(Mesh)] = (["cmesh"], LoadMesh),
        [typeof(Sprite)] = (["png", "jpg"], LoadSprite),
        [typeof(Texture2D)] = (["png", "jpg"], LoadTexture2D),

        [typeof(AssetBundle)] = ([BundleSuffix], LoadBundle), // Simple asset bundle loading

        // Bundle resources
        [typeof(Shader)] = (["shader"], GetBundleAsset<Shader>),
        [typeof(Material)] = (["mat"], GetBundleAsset<Material>),
        [typeof(GameObject)] = (["prefab"], GetBundleAsset<GameObject>),
        [typeof(ScriptableObject)] = (["asset"], null!), // Has its own internal handling

        // AudioClip is not currently in use
        // [typeof(AudioClip)] = (["wav"], LoadAudioClip),
    };

    /// <summary>
    /// Handles the mapping of extensions that essentially mean the same thing.
    /// </summary>
    public static readonly Dictionary<string, string> ExclusiveExtensions = new(StringComparer.Ordinal)
    {
        ["png"] = "jpg",
        ["jpg"] = "png"
    };

    /// <summary>
    /// Dictionary to hold handles for mod assets.
    /// </summary>
    private static readonly Dictionary<string, AssetHandle> Assets = new(StringComparer.Ordinal);

    private static readonly string[] Extensions = [.. new HashSet<string>(AssetTypeExtensions.Values.SelectMany(x => x.Extensions).Concat(Platforms.Select(x => "bundle_" + x.Value)), StringComparer.Ordinal)];

    private static string[] StringPool;

#if DEBUG
    /// <summary>
    /// Debug string path for the mod to dump assets.
    /// </summary>
    public static readonly string DumpPath = Path.Combine(Path.GetDirectoryName(Application.dataPath)!, "OceanRange");

    /// <summary>
    /// Initialises the asset handling by creating relevant handles.
    /// </summary>
    [TimeDiagnostic("Assets Initialis")]
#endif
    public static void InitialiseAssets()
    {
        Array.ForEach(Core.GetManifestResourceNames(), CreateAssetHandle); // Create handles for embedded resources

        using var stream = Core.GetManifestResourceStream("OceanRange.Resources.Data.string.pool")!;
        using var decompressor = new DeflateStream(stream, CompressionMode.Decompress);
        using var binary = new BinaryReader(decompressor);
        using var reader = new DataReader(binary, null);

        var count = reader.ReadPackedUInt();
        StringPool = new string[(int)count];
        StringPool[0] = string.Empty;

        for (var i = 1; i < count; i++)
            StringPool[i] = reader.ReadString()!;

        Bundle = Get<AssetBundle>("ocean_range"); // Ensures the bundle is loaded first
        Array.ForEach(Bundle.GetAllAssetNames(), CreateAssetHandle); // Create handles for bundles resources
    }

    public static void TryReleaseHandles(params string[] handles)
    {
        try
        {
            ReleaseHandles(handles);
        }
        catch
        {
            // ignored
        }
    }

    /// <summary>
    /// Frees up memory by releasing handles of certain assets.
    /// </summary>
    /// <param name="handles">The names of the assets to be released.</param>
    /// <exception cref="FileNotFoundException">Thrown if an asset name is not an asset shipped with the mod.</exception>
    public static void ReleaseHandles(params string[] handles)
    {
        if (handles.IsNullOrEmpty())
            handles = [.. Assets.Keys];

        foreach (var handleName in handles)
        {
            if (Assets.TryRemove(handleName, out var handle))
                handle!.Dispose(); // Releasing the handles
            else
                throw new FileNotFoundException(handleName);
        }
    }

    public static void ReleaseUnusedHandles() => ReleaseHandles([.. Assets.Where(x => !x.Value.HasLoaded).Select(x => x.Key)]);

    /// <summary>
    /// Gets and serialise JSON data from the asset associated with the provided name.
    /// </summary>
    /// <typeparam name="T">The type to deserialise to.</typeparam>
    /// <param name="path">The name of the asset.</param>
    /// <returns>The read and converted JSON data.</returns>
    public static T[] GetJsonArray<T>(string path) where T : JsonData, new() => ToJsonArray<T>(Get<Json>(path));

    /// <summary>
    /// Gets and serialise JSON data from the asset associated with the provided name.
    /// </summary>
    /// <typeparam name="T">The type to deserialise to.</typeparam>
    /// <param name="path">The name of the asset.</param>
    /// <returns>The read and converted JSON data.</returns>
    public static T? GetJson<T>(string path) where T : JsonData, new() => ToJson<T>(Get<Json>(path));

    public static bool TryGetTranslation(string name, out Translations? json)
    {
        if (!TryGet<Json>(name, out var jsonData))
        {
            json = null;
            return false;
        }

        json = ToJson<Translations>(jsonData);
        return true;
    }

    private static T? ToJson<T>(Json? json) where T : JsonData, new()
    {
        if (json == null)
            return null;

        using var stream = new MemoryStream(json.Data);
        using var decompressor = new DeflateStream(stream, CompressionMode.Decompress);
        using var binary = new BinaryReader(decompressor);
        using var reader = new DataReader(binary, StringPool);

        var data = new T();
        data.ReadFrom(reader);
        data.OnDeserialise();

        return data;
    }

    private static T[] ToJsonArray<T>(Json json) where T : JsonData, new()
    {
        using var stream = new MemoryStream(json.Data);
        using var decompressor = new DeflateStream(stream, CompressionMode.Decompress);
        using var binary = new BinaryReader(decompressor);
        using var reader = new DataReader(binary, StringPool);

        var count = reader.ReadPackedUInt();
        var array = new T[count];

        for (var i = 0; i < count; i++)
        {
            var data = new T();
            data.ReadFrom(reader);
            array[i] = data;
        }

        for (var i = 0; i < count; i++)
            array[i].OnDeserialise();

        return array;
    }

    /// <summary>
    /// Gets a Texture2D from the assets associated with the provided name.
    /// </summary>
    /// <inheritdoc cref="Get{T}(string)"/>
    public static Texture2D GetTexture2D(string name) => Get<Texture2D>(name);

    public static bool TryGetTexture2D(string name, out Texture2D? asset) => TryGet(name, out asset);

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
    public static Mesh GetMesh(string name) => Get<Mesh>(name);

    public static bool TryGetMesh(string name, out Mesh? mesh) => TryGet(name, out mesh);

    public static IEnumerable<Mesh> GetAllMeshes() => GetAll<Mesh>();

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

    private static IEnumerable<T> GetAll<T>(string[] names) where T : UObject => names.Select(Get<T>);

    private static IEnumerable<T> GetAll<T>() where T : UObject
    {
        foreach (var handle in Assets.Values)
        {
            if (handle.TryLoad<T>(out var asset))
                yield return asset!;
        }
    }

    /// <summary>
    /// Attempts to fetch an asset of type <typeparamref name="T"/> associated with the provided name.
    /// </summary>
    /// <typeparam name="T">The type of the asset.</typeparam>
    /// <param name="name">The name of the asset.</param>
    /// <param name="result">The fetched asset, if any.</param>
    /// <returns>true if an asset was found with the name.</returns>
    private static bool TryGet<T>(string name, out T? result) where T : UObject
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
    private static T Get<T>(string name) where T : UObject => Assets.TryGetValue(name, out var handle) ? handle.Load<T>() : throw new FileNotFoundException($"{name}, {typeof(T).Name}");

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
    /// Loads a JSON file from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The JSON asset loaded from the path.</returns>
    private static Json LoadJson(string path)
    {
        var json = ScriptableObject.CreateInstance<Json>();
        json.Initialise(path.ReadBytes());
        return json;
    }

    /// <summary>
    /// Loads a mesh file from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The mesh asset loaded from the path.</returns>
    private static Mesh LoadMesh(string path)
    {
        // This method uses a specially serialised version of the models to save on disk space and to make it easier to ship the mod

        using var stream = Core.GetManifestResourceStream(path)!;
        using var decompressor = new DeflateStream(stream, CompressionMode.Decompress);
        using var binaryReader = new BinaryReader(decompressor);
        using var reader = new DataReader(binaryReader, null);

        var mesh = new Mesh { indexFormat = (IndexFormat)reader.ReadByte() };

        var bounds = reader.ReadBounds();

        mesh.bounds = bounds;
        mesh.subMeshCount = reader.ReadPackedInt();

        var vertexCount = reader.ReadPackedInt();
        mesh.vertices = reader.ReadArrayContents(vertexCount, r => r.ReadQuantizedPosition(bounds));

        for (var i = 0; i < mesh.subMeshCount; i++)
        {
            var topology = (MeshTopology)reader.ReadByte();
            var subMeshBounds = reader.ReadBounds();
            var indices = reader.ReadDeltaEncodedIndices();

            mesh.SetIndices(indices, topology, i, false);

            var descriptor = mesh.GetSubMesh(i);
            descriptor.bounds = subMeshBounds;
            mesh.SetSubMesh(i, descriptor);
        }

        var uvs2 = new List<Vector2>(vertexCount);
        var uvs3 = new List<Vector3>(vertexCount);
        var uvs4 = new List<Vector4>(vertexCount);

        for (var i = 0; i < 8; i++)
        {
            var dimension = reader.ReadByte();

            if (dimension == 2)
                ReadUVs(reader, i, vertexCount, uvs2, r => r.ReadQuantizedUV2(), mesh.SetUVs);
            else if (dimension == 3)
                ReadUVs(reader, i, vertexCount, uvs3, r => r.ReadVector3(), mesh.SetUVs);
            else if (dimension == 4)
                ReadUVs(reader, i, vertexCount, uvs4, r => r.ReadVector4(), mesh.SetUVs);
        }

        mesh.RecalculateNormals();
        mesh.RecalculateTangents();

        return mesh;
    }

    private static void ReadUVs<T>(DataReader reader, int index, int count, List<T> uvs, Func<DataReader, T> readFunc, Action<int, List<T>> setUVs)
    {
        reader.ReadListContents(uvs, count, readFunc);
        setUVs(index, uvs);
        uvs.Clear();
    }

    /// <summary>
    /// Loads a texture from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <param name="forSprite">Flag indicating whether the texture is being made for a sprite, so that the texture's name is preset.</param>
    /// <returns>The texture asset loaded from the path.</returns>
    private static Texture2D? LoadTexture2D(string path, bool forSprite)
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

    private static Texture2D? LoadTexture2D(string path) => LoadTexture2D(path, false);

    // Texture optimisation stuff
    private static TextureWrapMode GetWrapMode(string name) => name.Contains("ramp") || name.Contains("pattern") ? TextureWrapMode.Repeat : TextureWrapMode.Clamp;

    /// <summary>
    /// Loads a sprite from the provided path.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    /// <returns>The sprite asset loaded from the path.</returns>
    private static Sprite? LoadSprite(string path)
    {
        var tex = LoadTexture2D(path, true);
        return tex ? Sprite.Create(tex, new(0, 0, tex!.width, tex.height), new(0.5f, 0.5f), 1f, 0, SpriteMeshType.Tight) : null;
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

    extension(string path)
    {
        /// <summary>
        /// Reads all the bytes from the provided file path.
        /// </summary>
        /// <returns>A byte array representing the file.</returns>
        private byte[] ReadBytes() => Core.GetManifestResourceStream(path)!.ReadFully();

        /// <summary>
        /// Helper method to converge all asset paths and names to a shorter string representations, aka their file names.
        /// </summary>
        /// <returns>The lowercase name of the asset after all parts have been filtered out.</returns>
        private string SanitisePath() => path
            .ReplaceAll(string.Empty, Extensions) // Removing the file extension first
            .TrueSplit('/', '\\', '.').Last(); // Split by directories (/ for Windows/Linux/AssetBundle/Urls, \ for Mac, . for Embedded/Memory) and get the last entry which should be the asset name
    }

    /// <summary>
    /// Creates an asset handle for the provided asset.
    /// </summary>
    /// <param name="path">The path of the asset.</param>
    private static void CreateAssetHandle(string path)
    {
        if (path.EndsWith("string.pool", StringComparison.Ordinal) || path.EndsWith("modinfo.json", StringComparison.Ordinal) || (path.Contains("bundle_") && !path.EndsWith(BundleSuffix)))
            return;

        var fileName = path.SanitisePath();
#if DEBUG
        Main.Console.Log($"Creating asset handle for {fileName} at {path}");
#endif
        Assets.GetOrAdd(fileName, Create).AddPath(path);
    }

    // /// <summary>
    // /// Creates an asset handle for the provided asset.
    // /// </summary>
    // /// <typeparam name="T">The type of the asset.</typeparam>
    // /// <param name="path">The path of the asset.</param>
    // /// <param name="asset">The asset to automatically add to the handle.</param>
    // public static void CreateAssetHandle<T>(string path, T asset) where T : UObject
    // {
    //     var handle = Assets.GetOrAdd(path.SanitisePath(), Create);
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

    // public static void Dump(this Sprite sprite, string fileName = null, string path = null) => sprite.texture.Dump(fileName, path);

    // extension(Texture texture)
    // {
    //     public void Dump(string fileName = null, string path = null, bool png = true)
    //     {
    //         if (!texture)
    //             return;

    //         var decompress = texture.Decompress();
    //         File.WriteAllBytes(Path.Combine(path ?? DumpPath, (fileName ?? texture.name) + (png ? ".png" : ".jpg")), png ? decompress.EncodeToPNG() : decompress.EncodeToJPG());
    //     }

    //     private Texture2D Decompress()
    //     {
    //         var renderTex = RenderTexture.GetTemporary(texture.width, texture.height, 0, RenderTextureFormat.Default, RenderTextureReadWrite.Linear);
    //         Graphics.Blit(texture, renderTex);
    //         var previous = RenderTexture.active;
    //         RenderTexture.active = renderTex;
    //         var readableText = new Texture2D(texture.width, texture.height);
    //         readableText.ReadPixels(new(0, 0, renderTex.width, renderTex.height), 0, 0);
    //         readableText.Apply();
    //         RenderTexture.active = previous;
    //         RenderTexture.ReleaseTemporary(renderTex);
    //         readableText.name = texture.name;
    //         return readableText;
    //     }
    // }
#endif
}