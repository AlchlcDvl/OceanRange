using System.Reflection;
using SRML.Utils;

namespace OceanRange.Managers;

public static class AssetManager
{
    private static readonly Assembly Core = typeof(Main).Assembly;
    private static readonly Dictionary<string, AssetHandle> Assets = [];
    // private static readonly string DumpPath = Path.Combine(Path.GetDirectoryName(Application.dataPath), "SRML");

    public static readonly JsonSerializerSettings JsonSettings = new();
    public static readonly Dictionary<Type, (string Extension, Func<string, UObject> LoadAsset)> AssetTypeExtensions = new()
    {
        [typeof(Mesh)] = ("bin", LoadMesh),
        [typeof(Sprite)] = ("png", LoadSprite),
        [typeof(JsonAsset)] = ("json", LoadJson),
        [typeof(Texture2D)] = ("png", LoadTexture),
        // AudioClip is not currently in use, so implementation for it comes later
    };

    public static void InitialiseAssets()
    {
        var bundlePath = $".bundle_{Platform()}";

        foreach (var path in Core.GetManifestResourceNames())
        {
            var id = path.SanitisePath(bundlePath);

            // if (path.EndsWith(".dll")) // Used to have a library dll in use, but later it was no longer needed, keeping this code in case another dll is needed in resources
            //     Assembly.Load(path.ReadBytes());
            // else
                CreateAssetHandle(id, path);
        }

        JsonSettings.Formatting = Formatting.Indented;
        JsonSettings.Converters.Add(new ZoneConverter());
        JsonSettings.Converters.Add(new PediaIdConverter());
        JsonSettings.Converters.Add(new Vector3Converter());
        JsonSettings.Converters.Add(new FoodGroupConverter());
        JsonSettings.Converters.Add(new ProgressTypeConverter());
        JsonSettings.Converters.Add(new IdentifiableIdConverter());
    }

    private static string Platform() => Application.platform switch
    {
        RuntimePlatform.LinuxPlayer => "lin",
        RuntimePlatform.OSXPlayer => "mac",
        RuntimePlatform.WindowsPlayer => "win",
        _ => throw new PlatformNotSupportedException(Application.platform.ToString())
    };

    private static string SanitisePath(this string path, string bundlePath = null)
    {
        path = path.ReplaceAll("", ".png", ".json", ".bin");

        if (bundlePath != null)
            path = path.Replace(bundlePath, "");

        return path.TrueSplit('/', '\\', '.').Last().ToLower();
    }

    public static T GetJson<T>(string path) => JsonConvert.DeserializeObject<T>(Get<JsonAsset>(path).text, JsonSettings);

    public static Texture2D GetTexture2D(string path) => Get<Texture2D>(path);

    public static Sprite GetSprite(string path) => Get<Sprite>(path);

    public static Mesh GetMesh(string path) => Get<Mesh>(path);

    public static T GetResource<T>(string name) where T : UObject => Array.Find(GetAllResources<T>(), x => x.name == name);

    public static T[] GetAllResources<T>() where T : UObject => Resources.FindObjectsOfTypeAll<T>();

    // public static IEnumerable<T> GetAll<T>() where T : UObject => Assets.Values.Select(x => x.Load<T>(false));

    private static T Get<T>(string name, bool throwError = true) where T : UObject
    {
        if (!Assets.TryGetValue(name, out var handle))
            return throwError ? throw new FileNotFoundException($"{name}, {typeof(T).Name}") : null;

        return handle.Load<T>(throwError);
    }

    public static bool AssetExists(string path) => Assets.ContainsKey(path);

    public static void UnloadAsset<T>(string name, bool throwError = true) where T : UObject
    {
        if (Assets.TryGetValue(name, out var handle))
            handle.Unload<T>();
        else if (throwError)
            throw new FileNotFoundException($"{name}, {typeof(T).Name}");
    }

    private static JsonAsset LoadJson(string path)
    {
        using var stream = Core.GetManifestResourceStream(path)!;
        using var reader = new StreamReader(stream);
        return new(reader.ReadToEnd());
    }

    private static Mesh LoadMesh(string path)
    {
        using var stream = Core.GetManifestResourceStream(path)!;
        using var reader = new BinaryReader(stream);
        var mesh = new Mesh();
        BinaryUtils.ReadMesh(reader, mesh);
        return mesh;
    }

    private static Texture2D EmptyTexture(TextureFormat format, bool mipChain) => new(2, 2, format, mipChain) { filterMode = FilterMode.Bilinear };

    private static Texture2D LoadTexture(string path)
    {
        var name = path.SanitisePath();
        var texture = EmptyTexture(GetFormat(name), GenerateMipChains(name));
        texture.LoadImage(path.ReadBytes(), true);
        texture.wrapMode = GetWrapMode(name);
        texture.name = name;
        return texture;
    }

    private static bool GenerateMipChains(string name) => name == "sleepingeyes" || name.Contains("ramp") || name.Contains("pattern");

    private static TextureFormat GetFormat(string name) => name.Contains("ramp") || name.Contains("pattern") ? TextureFormat.DXT1 : TextureFormat.DXT5;

    private static TextureWrapMode GetWrapMode(string name) => name.Contains("ramp") || name.Contains("pattern") ? TextureWrapMode.Repeat : TextureWrapMode.Clamp;

    private static Sprite LoadSprite(string path)
    {
        var tex = LoadTexture(path);
        return Sprite.Create(tex, new(0, 0, tex.width, tex.height), new(0.5f, 0.5f), 1f, 0, GetMeshType(tex.name));
    }

    private static SpriteMeshType GetMeshType(string name) => name is "sleepingeyes" || name.Contains("pattern") || name.Contains("ramp") ? SpriteMeshType.FullRect : SpriteMeshType.Tight;

    private static byte[] ReadFully(this Stream input)
    {
        using var ms = new MemoryStream();
        input.CopyTo(ms);
        return ms.ToArray();
    }

    private static byte[] ReadBytes(this string path) => Core.GetManifestResourceStream(path)!.ReadFully();

    private static void CreateAssetHandle(string name, string path)
    {
        if (!Assets.TryGetValue(name, out var handle))
            handle = Assets[name] = new(name);

        handle.AddPath(path);
    }

    // This is all for mainly debugging stuff when I want to dump assets from the main game, uncomment for use but keep commented for releases

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
}