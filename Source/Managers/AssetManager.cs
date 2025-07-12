using System.Reflection;
using Newtonsoft.Json;

namespace TheOceanRange.Managers;

public static class AssetManager
{
    private static readonly Assembly Core = typeof(Main).Assembly;
    private static AssetBundle Bundle;
    private static readonly Dictionary<string, AssetHandle> Assets = [];
    private static readonly Dictionary<Type, (string Extension, Func<string, UObject> LoadAsset)> AssetTypeExtensions = new()
    {
        [typeof(Mesh)] = ("obj", null), // Null because meshes are loaded from a bundle, which have their own internal loading method
        [typeof(Sprite)] = ("png", LoadSprite),
        [typeof(JsonAsset)] = ("json", LoadJson),
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
                LoadBundle(path, id).GetAllAssetNames().Do(x => CreateAssetHandle(x.SanitisePath(), x, true));
            else if (!path.Contains(".bundle")) // Skip loading bundles that don't relate to the current platform
                CreateAssetHandle(id, path, false);
        }
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
        path = path.ReplaceAll("", ".png", ".json", ".obj");

        if (bundlePath != null)
            path = path.Replace(bundlePath, "");

        return path.TrueSplit('/', '\\', '.').Last().ToLower();
    }

    public static T GetJson<T>(string path) => JsonConvert.DeserializeObject<T>(Get<JsonAsset>(path).text);

    public static Texture2D GetTexture2D(string path) => Get<Texture2D>(path);

    // public static GameObject GetPrefab(string path) => Get<GameObject>(path);

    // public static AudioClip GetAudio(string path) => Get<AudioClip>(path);

    public static Sprite GetSprite(string path) => Get<Sprite>(path);

    public static Mesh GetMesh(string path) => Get<Mesh>(path);

    private static T Get<T>(string name) where T : UObject
    {
        if (!Assets.TryGetValue(name, out var handle))
            throw new FileNotFoundException(name);

        return handle.Load<T>();
    }

    public static bool AssetExists(string path) => Assets.ContainsKey(path);

    public static void UnloadAsset<T>(string name) where T : UObject
    {
        if (Assets.TryGetValue(name, out var handle))
            handle.Unload<T>();
    }

    private static JsonAsset LoadJson(string path)
    {
        using var stream = Core.GetManifestResourceStream(path)!;
        using var reader = new StreamReader(stream);
        return new(reader.ReadToEnd());
    }

    private static Texture2D EmptyTexture(TextureFormat format, bool mipChain) => new(2, 2, format, mipChain) { filterMode = FilterMode.Bilinear };

    private static Texture2D LoadTexture(string path) => LoadTexture(ReadBytes(path), path.SanitisePath());

    private static Texture2D LoadTexture(byte[] data, string name)
    {
        var texture = EmptyTexture(GetFormat(name), GenerateMipChains(name));
        texture.LoadImage(data, true);
        texture.wrapMode = GetWrapMode(name);
        texture.name = name;
        return texture;
    }

    private static bool GenerateMipChains(string name) => name is "minepattern" or "lanternpattern" or "sleepingeyes" or "sandyskinramp" or "sandyskinrampdark";

    private static TextureFormat GetFormat(string name) => name is "sandyskinramp" or "sandyskinrampdark" ? TextureFormat.DXT1 : TextureFormat.DXT5;

    private static TextureWrapMode GetWrapMode(string name) => name is "sandyskinramp" or "sandyskinrampdark" ? TextureWrapMode.Repeat : TextureWrapMode.Clamp;

    private static Sprite LoadSprite(string path) => LoadSprite(LoadTexture(path)?.DontDestroy());

    private static Sprite LoadSprite(Texture2D tex)
    {
        var sprite = Sprite.Create(tex, new(0, 0, tex.width, tex.height), new(0.5f, 0.5f), 1f, 0, GetMeshType(tex.name));
        sprite.name = tex.name;
        return sprite;
    }

    private static SpriteMeshType GetMeshType(string name) => name is "minepattern" or "sandyskinramp" or "sandyskinrampdark" or "sleepingeyes" or "lanternpattern" ? SpriteMeshType.FullRect : SpriteMeshType.Tight;

    private static byte[] ReadFully(this Stream input)
    {
        using var ms = new MemoryStream();
        input.CopyTo(ms);
        return ms.ToArray();
    }

    private static byte[] ReadBytes(this string path) => Core.GetManifestResourceStream(path)!.ReadFully();

    private static AssetBundle LoadBundle(string path, string name)
    {
        var bundle = AssetBundle.LoadFromMemory(ReadBytes(path));
        bundle.name = name;
        return Bundle = bundle;
    }

    private static void CreateAssetHandle(string name, string path, bool fromBundle)
    {
        if (!Assets.TryGetValue(name, out var handle))
            handle = Assets[name] = new(name);

        var extension = path.TrueSplit('.').Last();

        if (handle.Paths.Keys.Any(x => x.EndsWith(extension)))
            throw new InvalidOperationException($"Cannot add another {name}.{extension} asset, please correct your asset naming and typing!");

        handle.Paths.Add(path, fromBundle);
    }

    public static void UnloadBundle()
    {
        Bundle.Unload(false);
        Bundle?.Destroy();
        Bundle = null;
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

    private sealed class AssetHandle(string name)
    {
        public readonly string Name = name;
        public readonly Dictionary<string, bool> Paths = []; // Handles asset paths, the bool flag indicates if it's from the bundle or not
        public readonly Dictionary<UObject, string> LoadedFrom = []; // Handles if assets have been loaded
        public readonly Dictionary<Type, UObject> Assets = []; // Handles loaded assets, by design assets can have the same name, but no two assets can have the same type (eg, there' can't be two of Plort.png anywhere)

        public T Load<T>() where T : UObject
        {
            var tType = typeof(T);

            if (Assets.TryGetValue(tType, out var asset))
                return asset as T;

            if (!AssetTypeExtensions.TryGetValue(tType, out var generator))
                throw new NotSupportedException($"{tType.Name} is not a valid asset type to load");

            if (!Paths.TryFinding(x => x.Key.EndsWith(generator.Extension), out var tuple))
                throw new FileNotFoundException($"There's no such {tType.Name} asset for {Name}");

            asset = tuple.Value ? Bundle.LoadAsset<T>(tuple.Key) : generator.LoadAsset(tuple.Key);

            if (asset)
            {
                LoadedFrom.Add(asset, tuple.Key);
                Assets.Add(tType, asset);
            }
            else
                throw new InvalidOperationException($"Something happened while trying to load {Name} of type {tType.Name}!");

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
}

public sealed class JsonAsset(string text) : TextAsset(text);