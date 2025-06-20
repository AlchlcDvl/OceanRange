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
        [typeof(AudioClip)] = ("wav", LoadAudio),
        [typeof(JsonTextAsset)] = ("json", LoadJson),
    };

    public static void FetchAssetNames()
    {
        foreach (var path in Core.GetManifestResourceNames())
        {
            var id = path.SanitisePath();

            if (path.EndsWith(".bundle"))
            {
                var bundle = AssetBundle.LoadFromMemory(Core.GetManifestResourceStream(path)!.ReadFully());
                Bundles[id] = bundle;
                bundle.GetAllAssetNames().Do(x => AssetToBundle[x.SanitisePath()] = id);
            }
            else
                AddPath(id, path);
        }
    }

    private static string SanitisePath(this string path)
    {
        path = path.ReplaceAll("", ".png", ".wav", ".txt", ".mat", ".json", ".anim", ".shader", ".bundle", "Slime.Resources.");
        path = path.TrueSplit('/').Last();
        path = path.TrueSplit('\\').Last();
        return path.TrueSplit('.').Last();
    }

    public static JsonTextAsset GetJson(string path) => Get<JsonTextAsset>(path);

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
            throw new NotSupportedException($"{tType.Name} is not a loadable asset type");

        strings.Remove(path);

        if (strings.Count == 0)
            UnloadedAssets.Remove(name);

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

    private static TextAsset LoadJson(string path)
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

    private static Texture2D LoadResourceTexture(string path) => LoadTexture(Core.GetManifestResourceStream(path)!.ReadFully(), path.SanitisePath());

    private static Texture2D LoadTexture(byte[] data, string name)
    {
        var texture = EmptyTexture();
        texture.name = name;
        return !texture.LoadImage(data, false) ? null : texture;
    }

    private static Sprite LoadSprite(string path) => LoadSprite(LoadResourceTexture(path), path.SanitisePath());

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

    private static AudioClip LoadAudio(string path) => LoadAudio(path.SanitisePath(), Core.GetManifestResourceStream(path)!.ReadFully());

    // Lord help my soul, got the code from here: https://github.com/deadlyfingers/UnityWav/blob/master/WavUtility.cs

    private static AudioClip LoadAudio(string name, byte[] fileBytes)
    {
        var chunk = BitConverter.ToInt32(fileBytes, 16) + 24;
        var channels = BitConverter.ToUInt16(fileBytes, 22);
        var sampleRate = BitConverter.ToInt32(fileBytes, 24);
        var bitDepth = BitConverter.ToUInt16(fileBytes, 34);
        var wavSize = BitConverter.ToInt32(fileBytes, chunk);
        var data = bitDepth switch
        {
            8 => Convert8BitByteArrayToAudioClipData(fileBytes, wavSize),
            16 => Convert16BitByteArrayToAudioClipData(fileBytes, chunk, wavSize),
            24 => Convert24BitByteArrayToAudioClipData(fileBytes, chunk, wavSize),
            32 => Convert32BitByteArrayToAudioClipData(fileBytes, chunk, wavSize),
            _ => throw new(bitDepth + " bit depth is not supported."),
        };

        var audioClip = AudioClip.Create(name, data.Length, channels, sampleRate, false);
        return audioClip.SetData(data, 0) ? audioClip : null;
    }

    private static float[] Convert8BitByteArrayToAudioClipData(byte[] source, int wavSize)
    {
        var data = new float[wavSize];

        for (var i = 0; i < wavSize; i++)
            data[i] = (float)source[i] / sbyte.MaxValue;

        return data;
    }

    private static float[] Convert16BitByteArrayToAudioClipData(byte[] source, int headerOffset, int wavSize)
    {
        headerOffset += sizeof(int);
        const int x = sizeof(short);
        var convertedSize = wavSize / x;
        var data = new float[convertedSize];

        for (var i = 0; i < convertedSize; i++)
            data[i] = (float)BitConverter.ToInt16(source, (i * x) + headerOffset) / short.MaxValue;

        return data;
    }

    private static float[] Convert24BitByteArrayToAudioClipData(byte[] source, int headerOffset, int wavSize)
    {
        const int intSize = sizeof(int);
        headerOffset += intSize;
        var convertedSize = wavSize / 3;
        var data = new float[convertedSize];
        var block = new byte[intSize]; // Using a 4-byte block for copying 3 bytes, then copy bytes with 1 offset

        for (var i = 0; i < convertedSize; i++)
        {
            Buffer.BlockCopy(source, (i * 3) + headerOffset, block, 1, 3);
            data[i] = (float)BitConverter.ToInt32(block, 0) / int.MaxValue;
        }

        return data;
    }

    private static float[] Convert32BitByteArrayToAudioClipData(byte[] source, int headerOffset, int wavSize)
    {
        headerOffset += sizeof(int);
        var convertedSize = wavSize / 4;
        var data = new float[convertedSize];

        for (var i = 0; i < convertedSize; i++)
            data[i] = (float)BitConverter.ToInt32(source, (i * 4) + headerOffset) / int.MaxValue;

        return data;
    }

    public static T CreatePrefab<T>(this T obj) where T : UObject => UObject.Instantiate(obj, Main.Prefab, false);

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

    // public static void GenerateBoneData(SlimeAppearanceApplicator slimePrefab, SlimeAppearance appearance, float jiggleAmount = 1f, float scale = 1f, Mesh[]
    //     additionalMesh = null, SlimeAppearanceObject[] appearanceObjects = null)
    // {
    //     additionalMesh ??= [];
    //     appearanceObjects ??= [];
    //     var bodyApp = appearanceObjects[0];
    //     var sharedMesh = bodyApp.GetComponent<SkinnedMeshRenderer>().sharedMesh;
    //     bodyApp.AttachedBones =
    //     [
    //         SlimeAppearance.SlimeBone.Slime,
    //         SlimeAppearance.SlimeBone.JiggleRight,
    //         SlimeAppearance.SlimeBone.JiggleLeft,
    //         SlimeAppearance.SlimeBone.JiggleTop,
    //         SlimeAppearance.SlimeBone.JiggleBottom,
    //         SlimeAppearance.SlimeBone.JiggleFront,
    //         SlimeAppearance.SlimeBone.JiggleBack
    //     ];

    //     foreach (var appearanceObject in appearanceObjects)
    //     {
    //         if (!appearanceObject)
    //             throw new NullReferenceException("One or more of the SlimeAppearanceObjects are null");

    //         appearanceObject.AttachedBones = bodyApp.AttachedBones;
    //     }

    //     var vertices1 = sharedMesh.vertices;
    //     var vector3_1 = new Vector3(float.NegativeInfinity, float.NegativeInfinity, float.NegativeInfinity);
    //     var vector3_2 = new Vector3(float.PositiveInfinity, float.PositiveInfinity, float.PositiveInfinity);
    //     var zero = Vector3.zero;

    //     for (var index = 0; index < vertices1.Length; ++index)
    //     {
    //         zero += vertices1[index];

    //         if (vertices1[index].x > vector3_1.x)
    //             vector3_1.x = vertices1[index].x;

    //         if (vertices1[index].x < vector3_2.x)
    //             vector3_2.x = vertices1[index].x;

    //         if (vertices1[index].y > vector3_1.y)
    //             vector3_1.y = vertices1[index].y;

    //         if (vertices1[index].y < vector3_2.y)
    //             vector3_2.y = vertices1[index].y;

    //         if (vertices1[index].z > vector3_1.z)
    //             vector3_1.z = vertices1[index].z;

    //         if (vertices1[index].z < vector3_2.z)
    //             vector3_2.z = vertices1[index].z;
    //     }

    //     var vector3_3 = zero / vertices1.Length;
    //     var num1 = 0.0f;

    //     foreach (var vector3_4 in vertices1)
    //         num1 += (vector3_4 - vector3_3).magnitude;

    //     var num2 = num1 / vertices1.Length;
    //     var meshList = new List<Mesh>() { sharedMesh };

    //     foreach (var appearanceObject in appearanceObjects)
    //     {
    //         if (appearanceObject.TryGetComponent<SkinnedMeshRenderer>(out var comp))
    //             meshList.Add(comp.sharedMesh);
    //         else
    //             Debug.LogWarning("One of the SlimeAppearanceObjects provided to AssetsLib.MeshUtils.GenerateBoneData does not use a SkinnedMeshRenderer");
    //     }

    //     meshList.AddRange(additionalMesh);

    //     foreach (var mesh in meshList)
    //     {
    //         if (!mesh)
    //             Debug.LogWarning("One of the Meshes provided to AssetsLib.MeshUtils.GenerateBoneData is null");
    //         else
    //         {
    //             var vertices2 = mesh.vertices;
    //             var boneWeightArray = new BoneWeight[vertices2.Length];

    //             for (var index = 0; index < vertices2.Length; ++index)
    //             {
    //                 var scale1 = vertices2[index] - vector3_3;
    //                 var num3 = Mathf.Clamp01((scale1.magnitude - (num2 / 4.0f)) / (num2 / 2.0f) * jiggleAmount);
    //                 boneWeightArray[index] = new();

    //                 if (num3 == 0.0)
    //                     boneWeightArray[index].weight0 = 1f;
    //                 else
    //                 {
    //                     boneWeightArray[index].weight0 = 1f - num3;
    //                     boneWeightArray[index].boneIndex1 = scale1.x >= 0.0 ? 1 : 2;
    //                     boneWeightArray[index].boneIndex2 = scale1.y >= 0.0 ? 3 : 4;
    //                     boneWeightArray[index].boneIndex3 = scale1.z >= 0.0 ? 5 : 6;
    //                     var vector3_5 = scale1.Multiply(scale1).Multiply(scale1).Abs();
    //                     var num4 = vector3_5.Sum();
    //                     boneWeightArray[index].weight1 = vector3_5.x / num4 * num3;
    //                     boneWeightArray[index].weight2 = vector3_5.y / num4 * num3;
    //                     boneWeightArray[index].weight3 = vector3_5.z / num4 * num3;
    //                 }

    //                 boneWeightArray[index].weight0 *= scale;
    //                 boneWeightArray[index].weight1 *= scale;
    //                 boneWeightArray[index].weight2 *= scale;
    //                 boneWeightArray[index].weight3 *= scale;
    //             }

    //             mesh.boneWeights = boneWeightArray;
    //             var matrix4x4Array = new Matrix4x4[bodyApp.AttachedBones.Length];

    //             for (var i = 0; i < bodyApp.AttachedBones.Length; i++)
    //             {
    //                 matrix4x4Array[i] =
    //                     slimePrefab.Bones.First(x => x.Bone == bodyApp.AttachedBones[i]).BoneObject.transform.worldToLocalMatrix *
    //                         slimePrefab.Bones.First(x => x.Bone == SlimeAppearance.SlimeBone.Root).BoneObject.transform.localToWorldMatrix;
    //             }

    //             mesh.bindposes = matrix4x4Array;
    //         }
    //     }
    // }
}