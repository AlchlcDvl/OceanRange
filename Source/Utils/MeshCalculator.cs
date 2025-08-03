using Unity.Collections;

namespace OceanRange.Utils;

// This class is derived from some dev code that Aidanamite provided me with, there's some cursed native and memory magic in play here that I personally wouldn't touch after making this class
public static class MeshCalculator
{
    private static readonly Func<SlimeAppearanceApplicator.BoneMapping, bool> IsBone = IsBoneRoot;

    private static bool IsBoneRoot(SlimeAppearanceApplicator.BoneMapping appearance) => appearance.Bone == SlimeAppearance.SlimeBone.Root;

    public static void GenerateGordoBoneData(this Transform gordo, Action<int, SkinnedMeshRenderer> materialHandler, params string[] meshNames)
    {
        if (meshNames.Length == 0)
            return;

        var prefabRend = gordo.GetComponent<SkinnedMeshRenderer>();
        var sharedMesh = prefabRend.sharedMesh;
        var (zero, num) = CalculateZeroes(sharedMesh);
        var parent = gordo.parent;
        var parentObj = parent.gameObject.FindChild("bone_root");

        var bones = new[]
        {
            parentObj.FindChild("bone_slime").transform,
            parentObj.FindChild("bone_skin_rig", true).transform,
            parentObj.FindChild("bone_skin_lef", true).transform,
            parentObj.FindChild("bone_skin_top", true).transform,
            parentObj.FindChild("bone_skin_bot", true).transform,
            parentObj.FindChild("bone_skin_fro", true).transform,
            parentObj.FindChild("bone_skin_bac", true).transform,
        };

        var rootMatrix = parent.localToWorldMatrix;

        for (var i = 0; i < meshNames.Length; i++)
        {
            var meshName = meshNames[i];
            var isNull = meshName == null;
            var mesh = isNull ? sharedMesh.Clone() : AssetManager.GetMesh(meshName);

            GenerateBoneDataRaw(mesh, zero, num, 1f, 2);

            var poses = new Matrix4x4[bones.Length];

            for (var k = 0; k < bones.Length; k++)
                poses[k] = bones[k].worldToLocalMatrix * rootMatrix;

            mesh.bindposes = poses;

            var meshRend = i == 0 ? prefabRend : prefabRend.Instantiate(parent);
            meshRend.sharedMesh = mesh;
            meshRend.localBounds = mesh.bounds;
            meshRend.bones = bones;
            meshRend.rootBone = meshRend.bones[0];

            if (!isNull && i != 0)
                meshRend.name = meshName;

            materialHandler?.Invoke(i, meshRend);
        }
    }

    public static void GenerateSlimeBoneData(this SlimeAppearanceApplicator slimePrefab, SlimeAppearanceObject bodyApp, float jiggleAmount, SlimeAppearanceObject[] appearanceObjects)
    {
        var sharedMesh = bodyApp.GetComponent<SkinnedMeshRenderer>().sharedMesh;
        var (zero, num) = CalculateZeroes(sharedMesh);
        bodyApp.AttachedBones =
        [
            SlimeAppearance.SlimeBone.Slime,
            SlimeAppearance.SlimeBone.JiggleRight,
            SlimeAppearance.SlimeBone.JiggleLeft,
            SlimeAppearance.SlimeBone.JiggleTop,
            SlimeAppearance.SlimeBone.JiggleBottom,
            SlimeAppearance.SlimeBone.JiggleFront,
            SlimeAppearance.SlimeBone.JiggleBack
        ];

        var list = new List<Mesh> { sharedMesh };

        foreach (var appearanceObject in appearanceObjects)
        {
            if (!appearanceObject)
                throw new NullReferenceException("One or more of the SlimeAppearanceObjects are null");

            appearanceObject.AttachedBones = bodyApp.AttachedBones;

            if (appearanceObject.TryGetComponent<SkinnedMeshRenderer>(out var rend))
                list.Add(rend.sharedMesh);
            else
                Debug.LogWarning("One of the SlimeAppearanceObjects provided does not use a SkinnedMeshRenderer");
        }

        var rootMatrix = slimePrefab.Bones.First(IsBone).BoneObject.transform.localToWorldMatrix;

        foreach (var mesh in list)
        {
            if (!mesh)
            {
                Debug.LogWarning("One of the Meshes provided is null");
                continue;
            }

            GenerateBoneDataRaw(mesh, zero, num, jiggleAmount, 3);

            var poses = new Matrix4x4[bodyApp.AttachedBones.Length];

            for (var i = 0; i < bodyApp.AttachedBones.Length; i++)
            {
                var bone = bodyApp.AttachedBones[i];
                poses[i] = slimePrefab.Bones.First(x => x.Bone == bone).BoneObject.transform.worldToLocalMatrix * rootMatrix;
            }

            mesh.bindposes = poses;
        }
    }

    public static Vector3 Abs(this Vector3 value) => new(Mathf.Abs(value.x), Mathf.Abs(value.y), Mathf.Abs(value.z));

    private static Dictionary<int, float> HandleBoneWeight(Vector3 diff, float num, int power, float jiggleAmount)
    {
        var jiggle = Mathf.Clamp01((diff.magnitude - (num / 4f)) / (num / 2f) * jiggleAmount);
        var dict = new Dictionary<int, float>() { [0] = 1f - jiggle };
        var value = diff.ToPower(power);

        if (power % 2 == 1)
            value = value.Abs();

        var normal = value.Sum();

        if (normal > 0f)
            value = value.MultipliedBy(1f / normal);

        value = value.MultipliedBy(jiggle);

        for (var i = 0; i < 3; i++)
        {
            var component = value[i];

            if (component != 0)
                dict[(component > 0 ? 1 : 2) + (i * 2)] = component;
        }

        return dict;
    }

    public static void SetBoneWeightsPerVertex(this Mesh mesh, Dictionary<int, Dictionary<int, float>> weights)
    {
        var boneWeights = new List<BoneWeight1>();
        var perVertex = new List<byte>();
        var vertexCount = mesh.vertexCount;

        for (var i = 0; i < vertexCount; i++)
        {
            if (weights.TryGetValue(i, out var dict))
            {
                perVertex.Add((byte)dict.Count);

                foreach (var p in dict)
                    boneWeights.Add(new BoneWeight1() { m_BoneIndex = p.Key, m_Weight = p.Value });
            }
            else
                perVertex.Add(0);
        }

        using var nativePerVertex = new NativeArray<byte>(perVertex.ToArray(), Allocator.TempJob);
        using var nativeBoneWeights = new NativeArray<BoneWeight1>(boneWeights.ToArray(), Allocator.TempJob);
        mesh.SetBoneWeights(nativePerVertex, nativeBoneWeights);
    }

    public static void GenerateBoneDataRaw(Mesh mesh, Vector3 zero, float num, float jiggleAmount, int power)
    {
        var vertices = mesh.vertices;
        var weightIndices = new Dictionary<int, Dictionary<int, float>>();

        for (var n = 0; n < vertices.Length; n++)
            weightIndices[n] = HandleBoneWeight(vertices[n] - zero, num, power, jiggleAmount);

        mesh.SetBoneWeightsPerVertex(weightIndices);
    }

    private static (Vector3, float) CalculateZeroes(Mesh mesh)
    {
        var vertices = mesh.vertices;
        var min = Vector3.one * float.PositiveInfinity;
        var max = Vector3.one * float.NegativeInfinity;

        foreach (var vector in vertices)
        {
            if (vector.x > max.x)
                max.x = vector.x;

            if (vector.x < min.x)
                min.x = vector.x;

            if (vector.y > max.y)
                max.y = vector.y;

            if (vector.y < min.y)
                min.y = vector.y;

            if (vector.z > max.z)
                max.z = vector.z;

            if (vector.z < min.z)
                min.z = vector.z;
        }

        var num = 0f;
        var zero = (max + min) / 2;

        foreach (var vector in vertices)
            num += (vector - zero).magnitude;

        num /= vertices.Length;
        return (zero, num);
    }
}