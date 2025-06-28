using System.Reflection;

namespace TheOceanRange.Managers;

public static class AssetManager
{
    private static readonly Assembly Core = typeof(Main).Assembly;
    public static readonly Dictionary<string, AssetBundle> Bundles = [];
    public static readonly Dictionary<string, string> AssetToBundle = [];
    private static readonly Dictionary<string, HashSet<UObject>> LoadedAssets = [];
    private static readonly Dictionary<string, HashSet<string>> UnloadedAssets = [];
    private static readonly Dictionary<Type, (string, Func<string, UObject>)> AssetTypeExtensions = new()
    {
        [typeof(Sprite)] = ("png", LoadSprite),
        [typeof(Texture2D)] = ("png", LoadTexture),
        // [typeof(AudioClip)] = ("wav", LoadAudio),
        [typeof(JsonTextAsset)] = ("json", LoadJson),
    };

    public static void FetchAssetNames()
    {
        foreach (var path in Core.GetManifestResourceNames())
        {
            var id = path.SanitisePath();

            if (path.EndsWith($".bundle_{Platform()}"))
            {
                var bundle = AssetBundle.LoadFromMemory(Core.GetManifestResourceStream(path)!.ReadFully());
                Bundles[id] = bundle;
                bundle.GetAllAssetNames().Do(x => AssetToBundle[x.SanitisePath()] = id);
            }
            else if (!path.Contains(".bundle")) // Skip loading bundles that don't relate to the current platform
                AddPath(id, path);
        }
    }

    private static string Platform() => Environment.OSVersion.Platform is PlatformID.Unix or PlatformID.MacOSX ? "mac" : "win";

    private static string SanitisePath(this string path)
    {
        path = path.ReplaceAll("", ".png", ".wav", ".txt", ".mat", ".json", ".anim", ".shader", ".bundle", ".fbx", ".obj", "Slime.Resources.");
        path = path.TrueSplit('/').Last();
        path = path.TrueSplit('\\').Last();
        return path.TrueSplit('.').Last();
    }

    public static JsonTextAsset GetJson(string path) => Get<JsonTextAsset>(path);

    public static Texture2D GetTexture2D(string path) => Get<Texture2D>(path);

    public static AudioClip GetAudio(string path) => Get<AudioClip>(path);

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
            return null;

        var tType = typeof(T);

        if (AssetTypeExtensions.TryGetValue(tType, out var pair) && strings.TryFinding(x => x.EndsWith($".{pair.Item1}"), out var path))
            result = AddAsset(name, (T)pair.Item2(path));
        else
            throw new NotSupportedException($"{tType.Name} is not a loadable asset type for {name}");

        strings.Remove(path);

        if (strings.Count == 0)
            UnloadedAssets.Remove(name);

        if (!result)
            Main.Instance.ConsoleInstance.LogError($"Could not find {name} of type {tType.Name}");

        return result;
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

    public static T AddAsset<T>(string name, T obj) where T : UObject => AddAsset(name, (UObject)obj) as T;

    private static UObject AddAsset(string name, UObject obj)
    {
        if (!obj)
            return null;

        if (!LoadedAssets.TryGetValue(name, out var value))
            LoadedAssets[name] = value = [];

        value.Add(obj);
        return obj.DontDestroy();
    }

    public static void AddPath(string name, string path)
    {
        if (!UnloadedAssets.TryGetValue(name, out var value))
            UnloadedAssets[name] = value = [];

        value.Add(path);
    }

    private static JsonTextAsset LoadJson(string path)
    {
        using var stream = Core.GetManifestResourceStream(path);
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
        return !texture.LoadImage(data, false) ? null : texture;
    }

    private static Sprite LoadSprite(string path) => LoadSprite(LoadTexture(path), path.SanitisePath());

    public static Sprite LoadSprite(Texture2D tex, string name, float ppu = float.NaN, SpriteMeshType meshType = SpriteMeshType.Tight)
    {
        var sprite = Sprite.Create(tex, new(0, 0, tex.width, tex.height), new(0.5f, 0.5f), float.IsNaN(ppu) ? 1f : ppu, 0, meshType);
        sprite.name = name;
        return sprite;
    }

    public static Sprite CreateSprite(this Texture2D texture)
    {
        var sprite = Sprite.Create(texture, new(0f, 0f, texture.width, texture.height), new(0.5f, 0.5f), 1f);
        sprite.name = texture.name;
        return sprite;
    }

    // private static AudioClip LoadAudio(string path) => LoadAudio(path.SanitisePath(), Core.GetManifestResourceStream(path)!.ReadFully());

    // Lord help my soul, got the code from here: https://github.com/deadlyfingers/UnityWav/blob/master/WavUtility.cs

    // private static AudioClip LoadAudio(string name, byte[] fileBytes)
    // {
    //     var chunk = BitConverter.ToInt32(fileBytes, 16) + 24;
    //     var channels = BitConverter.ToUInt16(fileBytes, 22);
    //     var sampleRate = BitConverter.ToInt32(fileBytes, 24);
    //     var bitDepth = BitConverter.ToUInt16(fileBytes, 34);
    //     var wavSize = BitConverter.ToInt32(fileBytes, chunk);
    //     var data = bitDepth switch
    //     {
    //         8 => Convert8BitByteArrayToAudioClipData(fileBytes, wavSize),
    //         16 => Convert16BitByteArrayToAudioClipData(fileBytes, chunk, wavSize),
    //         24 => Convert24BitByteArrayToAudioClipData(fileBytes, chunk, wavSize),
    //         32 => Convert32BitByteArrayToAudioClipData(fileBytes, chunk, wavSize),
    //         _ => throw new(bitDepth + " bit depth is not supported."),
    //     };

    //     var audioClip = AudioClip.Create(name, data.Length, channels, sampleRate, false);
    //     return audioClip.SetData(data, 0) ? audioClip : null;
    // }

    // private static float[] Convert8BitByteArrayToAudioClipData(byte[] source, int wavSize)
    // {
    //     var data = new float[wavSize];

    //     for (var i = 0; i < wavSize; i++)
    //         data[i] = (float)source[i] / sbyte.MaxValue;

    //     return data;
    // }

    // private static float[] Convert16BitByteArrayToAudioClipData(byte[] source, int headerOffset, int wavSize)
    // {
    //     headerOffset += sizeof(int);
    //     const int x = sizeof(short);
    //     var convertedSize = wavSize / x;
    //     var data = new float[convertedSize];

    //     for (var i = 0; i < convertedSize; i++)
    //         data[i] = (float)BitConverter.ToInt16(source, (i * x) + headerOffset) / short.MaxValue;

    //     return data;
    // }

    // private static float[] Convert24BitByteArrayToAudioClipData(byte[] source, int headerOffset, int wavSize)
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

    // private static float[] Convert32BitByteArrayToAudioClipData(byte[] source, int headerOffset, int wavSize)
    // {
    //     headerOffset += sizeof(int);
    //     var convertedSize = wavSize / 4;
    //     var data = new float[convertedSize];

    //     for (var i = 0; i < convertedSize; i++)
    //         data[i] = (float)BitConverter.ToInt32(source, (i * 4) + headerOffset) / int.MaxValue;

    //     return data;
    // }

    private static byte[] ReadFully(this Stream input)
    {
        using var ms = new MemoryStream();
        input.CopyTo(ms);
        return ms.ToArray();
    }

    // This is all for mainly debugging stuff when I want to dump assets from the main game

    // public static void Dump(this Sprite sprite, string path) => File.WriteAllBytes(path, sprite.texture.Decompress().EncodeToPNG());

    // public static Texture2D Decompress(this Texture2D source)
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