using System.Reflection;
using Newtonsoft.Json;

namespace TheOceanRange.Managers;

public static class AssetManager
{
    public static readonly List<JsonData> JsonData = [];

    private static readonly Assembly Core = typeof(Main).Assembly;
    private static readonly Dictionary<string, AssetBundle> Bundles = [];
    private static readonly Dictionary<string, string> AssetToBundle = [];
    private static readonly Dictionary<string, HashSet<UObject>> LoadedAssets = [];
    private static readonly Dictionary<string, HashSet<string>> UnloadedAssets = [];
    private static readonly Dictionary<Type, (string Extension, Func<string, UObject> LoadAsset)> AssetTypeExtensions = new()
    {
        [typeof(Sprite)] = ("png", LoadSprite),
        [typeof(TextAsset)] = ("json", LoadText),
        [typeof(Texture2D)] = ("png", LoadTexture),
        // AudioClip is not currently in use, so implementation for it comes later
    };

    public static void FetchAssetNames()
    {
        var bundlePath = $".bundle_{Platform()}";

        foreach (var path in Core.GetManifestResourceNames())
        {
            var id = path.SanitisePath(bundlePath);

            if (path.EndsWith(bundlePath))
            {
                var bundle = AssetBundle.LoadFromMemory(Core.GetManifestResourceStream(path)!.ReadFully());
                Bundles[id] = bundle;
                bundle.GetAllAssetNames().Do(x => AssetToBundle[x.SanitisePath()] = id);
            }
            else if (!path.Contains(".bundle")) // Skip loading bundles that don't relate to the current platform
                AddPath(id, path);
        }
    }

    private static string Platform() => Environment.OSVersion.Platform switch
    {
        PlatformID.Unix => "lin",
        PlatformID.MacOSX => "mac",
        _ => "win"
    };

    private static string SanitisePath(this string path, string bundlePath = null)
    {
        path = path.ReplaceAll("", ".png", ".json", ".obj");

        if (bundlePath != null)
            path = path.Replace(bundlePath, "");

        path = path.TrueSplit('/').Last();
        path = path.TrueSplit('\\').Last();
        return path.TrueSplit('.').Last();
    }

    public static T GetJson<T>(string path) => JsonConvert.DeserializeObject<T>(Get<TextAsset>(path).text);

    public static Texture2D GetTexture2D(string path) => Get<Texture2D>(path);

    // public static GameObject GetPrefab(string path) => Get<GameObject>(path);

    // public static AudioClip GetAudio(string path) => Get<AudioClip>(path);

    public static Sprite GetSprite(string path) => Get<Sprite>(path);

    public static Mesh GetMesh(string path) => Get<Mesh>(path);

    private static T Get<T>(string name) where T : UObject
    {
        if (LoadedAssets.TryGetValue(name, out var objList) && objList.TryFinding<UObject, T>(out var result) && result)
            return result;

        if (AssetToBundle.TryGetValue(name.ToLower(), out var bundle))
        {
            result = LoadAsset<T>(Bundles[bundle], name);

            if (result)
                return result;
        }

        if (!UnloadedAssets.TryGetValue(name, out var strings))
            throw new FileNotFoundException(name);

        var tType = typeof(T);

        if (AssetTypeExtensions.TryGetValue(tType, out var pair) && strings.TryFinding(x => x.EndsWith($".{pair.Extension}"), out var path))
            result = (T)AddAsset(name, pair.LoadAsset(path));
        else
            throw new FileNotFoundException($"{name}, {tType.Name}");

        strings.Remove(path);

        if (strings.Count == 0)
            UnloadedAssets.Remove(name);

        if (!result)
            throw new InvalidOperationException($"Initialising {name} of type {tType.Name} failed");

        return result;
    }

    public static bool AssetExists(string path)
    {
        var lower = path.ToLower();
        return LoadedAssets.Keys.Any(x => x == path) || UnloadedAssets.Keys.Any(x => x == path) || AssetToBundle.Keys.Any(x => x == lower);
    }

    private static T LoadAsset<T>(AssetBundle assetBundle, string name) where T : UObject
    {
        var asset = assetBundle.LoadAsset<T>(name);
        AddAsset(name, asset);
        AssetToBundle.Remove(name);

        if (Bundles.Keys.Any(AssetToBundle.Values.Contains))
            return asset;

        Bundles.Remove(assetBundle.name);
        assetBundle.Unload(false);
        return asset;
    }

    private static void AddAsset<T>(string name, T obj) where T : UObject => AddAsset(name, (UObject)obj);

    private static UObject AddAsset(string name, UObject obj)
    {
        if (!obj)
            return null;

        if (!LoadedAssets.TryGetValue(name, out var value))
            LoadedAssets[name] = value = [];

        value.Add(obj);
        return obj.DontDestroy();
    }

    private static void AddPath(string name, string path)
    {
        if (!UnloadedAssets.TryGetValue(name, out var value))
            UnloadedAssets[name] = value = [];

        value.Add(path);
    }

    private static TextAsset LoadText(string path)
    {
        using var stream = Core.GetManifestResourceStream(path)!;
        using var reader = new StreamReader(stream);
        return new(reader.ReadToEnd());
    }

    private static Texture2D EmptyTexture() => new(2, 2, TextureFormat.ARGB32, true)
    {
        filterMode = FilterMode.Bilinear,
        wrapMode = TextureWrapMode.Repeat
    };

    private static Texture2D LoadTexture(string path) => LoadTexture(Core.GetManifestResourceStream(path)!.ReadFully(), path.SanitisePath());

    private static Texture2D LoadTexture(byte[] data, string name)
    {
        var texture = EmptyTexture();
        texture.name = name;
        return !texture.LoadImage(data, true) ? null : texture;
    }

    private static Sprite LoadSprite(string path) => LoadSprite(LoadTexture(path), path.SanitisePath());

    private static Sprite LoadSprite(Texture2D tex, string name, float ppu = float.NaN, SpriteMeshType meshType = SpriteMeshType.Tight)
    {
        var sprite = Sprite.Create(tex, new(0, 0, tex.width, tex.height), new(0.5f, 0.5f), float.IsNaN(ppu) ? 1f : ppu, 0, meshType);
        sprite.name = name;
        return sprite;
    }

    private static byte[] ReadFully(this Stream input)
    {
        using var ms = new MemoryStream();
        input.CopyTo(ms);
        return ms.ToArray();
    }

    // This is all for mainly debugging stuff when I want to dump assets from the main game

    // public static void Dump(this Texture texture, string path) => File.WriteAllBytes(path, texture.Decompress().EncodeToPNG());

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