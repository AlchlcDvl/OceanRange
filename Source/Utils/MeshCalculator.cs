using AssetsLib;
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

            var isFirst = i == 0;
            var meshRend = isFirst ? prefabRend : prefabRend.Instantiate(parent);
            meshRend.sharedMesh = mesh;
            meshRend.localBounds = mesh.bounds;
            meshRend.bones = bones;
            meshRend.rootBone = meshRend.bones[0];

            if (!isNull && !isFirst)
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

    private static BoneWeight HandleBoneWeight(Vector3 diff, float num, float jiggleAmount, int power)
    {
        var jiggle = Mathf.Clamp01((diff.magnitude - (num / 4f)) / (num / 2f) * jiggleAmount);
        var weight = new BoneWeight
        {
            m_Weight0 = 1f - jiggle,
            m_BoneIndex0 = 0
        };

        if (jiggle == 0f)
            return weight;

        weight.m_BoneIndex1 = diff.x >= 0f ? 1 : 2;
        weight.m_BoneIndex2 = diff.y >= 0f ? 3 : 4;
        weight.m_BoneIndex3 = diff.z >= 0f ? 5 : 6;

        var value = diff.ToPower(power).Abs();
        var normal = value.Sum();

        if (normal > 0f)
            value /= normal;

        value *= jiggle;

        weight.m_Weight1 = value.x;
        weight.m_Weight2 = value.y;
        weight.m_Weight3 = value.z;

        return weight;
    }

    public static void GenerateBoneDataRaw(Mesh mesh, Vector3 zero, float num, float jiggleAmount, int power)
    {
        var vertices = mesh.vertices;
        var weights = new BoneWeight[vertices.Length];

        for (var i = 0; i < vertices.Length; i++)
            weights[i] = HandleBoneWeight(vertices[i] - zero, num, jiggleAmount, power);

        mesh.boneWeights = weights;
    }

    private static (Vector3, float) CalculateZeroes(Mesh mesh)
    {
        var vertices = mesh.vertices;
        var zero = Vector3.zero;

        foreach (var vector in vertices)
            zero += vector;

        zero /= vertices.Length;
        var num = 0f;

        foreach (var vector in vertices)
            num += (vector - zero).magnitude;

        num /= vertices.Length;
        return (zero, num);
    }
}