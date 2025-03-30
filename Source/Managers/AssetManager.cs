using System.Reflection;

namespace TheOceanRange.Managers;

public static class AssetManager
{
    private static Assembly Core { get; } = typeof(Main).Assembly;
    private static Dictionary<string, string> UnloadedAssets { get; } = [];
    private static Dictionary<string, Texture2D> LoadedTextures { get; } = [];
    private static Dictionary<string, Sprite> LoadedSprites { get; } = [];

    public static void FetchAssetNames()
    {
        foreach (var resourceName in Core.GetManifestResourceNames())
            UnloadedAssets[resourceName.Replace("Slime.Resources.", "")] = resourceName;
    }

    public static Sprite GetSprite(string fileName, FilterMode mode = FilterMode.Bilinear, TextureWrapMode wrapMode = TextureWrapMode.Repeat)
    {
        if (LoadedSprites.TryGetValue(fileName, out var sprite))
            return sprite;

        return LoadedSprites[fileName] = LoadImage(fileName, mode, wrapMode).CreateSprite();
    }

    public static Texture2D LoadImage(string fileName, FilterMode mode = FilterMode.Bilinear, TextureWrapMode wrapMode = TextureWrapMode.Repeat)
    {
        if (LoadedTextures.TryGetValue(fileName, out var texture))
            return texture;

        if (!UnloadedAssets.TryGetValue(fileName, out var path))
            throw new MissingResourceException(fileName);

        using var manifestResourceStream = Core.GetManifestResourceStream(path) ?? throw new MissingResourceException(fileName);
        var array = new byte[manifestResourceStream.Length];
        _ = manifestResourceStream.Read(array, 0, array.Length);
        var texture2D = new Texture2D(1, 1);
        texture2D.LoadImage(array);
        texture2D.filterMode = mode;
        texture2D.wrapMode = wrapMode;
        texture2D.name = Path.GetFileNameWithoutExtension(fileName);
        UnloadedAssets.Remove(fileName);
        return LoadedTextures[fileName] = texture2D;
    }

    public static Sprite CreateSprite(this Texture2D texture)
    {
        var sprite = Sprite.Create(texture, new(0f, 0f, texture.width, texture.height), new(0.5f, 0.5f), 1f);
        sprite.name = texture.name;
        return sprite;
    }

    public static T CreatePrefab<T>(this T obj) where T : UObject => UObject.Instantiate(obj, Main.Prefab, false);

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