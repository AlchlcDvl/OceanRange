using AssetsLib;

namespace OceanRange.Patches;

// Aims to reduce a bit of the overhead (comparison, array initialisation and indexing mainly) that the original code introduces + allows the meshes to recalculate bounds after their poses have been set for maximum effectiveness
// TODO: Refactor when AssetsLib 1.2.7 comes out
[HarmonyPatch(typeof(MeshUtils), nameof(MeshUtils.GenerateBoneData), typeof(SlimeAppearanceApplicator), typeof(SlimeAppearanceObject), typeof(float), typeof(float), typeof(Mesh[]), typeof(SlimeAppearanceObject[]))]
public static class MeshUtilsImprovement
{
    public static bool Prefix(SlimeAppearanceApplicator slimePrefab, SlimeAppearanceObject bodyApp, float jiggleAmount, float scale, [HarmonyArgument(4)] Mesh[] additionalMesh, SlimeAppearanceObject[] appearanceObjects)
    {
        if (!slimePrefab)
            throw new ArgumentNullException(nameof(slimePrefab));

        if (!bodyApp)
            throw new ArgumentNullException(nameof(bodyApp));

        var sharedMesh = bodyApp.GetComponent<SkinnedMeshRenderer>().sharedMesh;
        var vertices = sharedMesh.vertices;
        var zero = Vector3.zero;

        foreach (var vector in vertices)
            zero += vector;

        zero /= vertices.Length;
        var num = 0f;

        foreach (var vector in vertices)
            num += (vector - zero).magnitude;

        num /= vertices.Length;
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

        if (appearanceObjects != null)
        {
            foreach (var appearanceObject in appearanceObjects)
            {
                if (!appearanceObject)
                    throw new NullReferenceException("One or more of the SlimeAppearanceObjects are null");

                appearanceObject.AttachedBones = bodyApp.AttachedBones;

                if (appearanceObject.TryGetComponent<SkinnedMeshRenderer>(out var rend))
                    list.Add(rend.sharedMesh);
                else
                    Debug.LogWarning("One of the SlimeAppearanceObjects provided to AssetsLib.MeshUtils.GenerateBoneData does not use a SkinnedMeshRenderer");
            }
        }

        if (additionalMesh != null)
            list.AddRange(additionalMesh);

        var rootMatrix = slimePrefab.Bones.First(IsRoot).BoneObject.transform.localToWorldMatrix;

        foreach (var item in list)
        {
            if (!item)
            {
                Debug.LogWarning("One of the Meshes provided to AssetsLib.MeshUtils.GenerateBoneData is null");
                continue;
            }

            var vertices2 = item.vertices;
            var weights = new BoneWeight[vertices2.Length];

            for (var n = 0; n < vertices2.Length; n++)
            {
                var diff = vertices2[n] - zero;
                var jiggle = Mathf.Clamp01((diff.magnitude - (num / 4f)) / (num / 2f) * jiggleAmount);
                var weight = new BoneWeight
                {
                    m_Weight0 = 1f - jiggle,
                    m_BoneIndex0 = 0
                };

                if (jiggle > 0f)
                {
                    weight.m_BoneIndex1 = diff.x >= 0f ? 1 : 2;
                    weight.m_BoneIndex2 = diff.y >= 0f ? 3 : 4;
                    weight.m_BoneIndex3 = diff.z >= 0f ? 5 : 6;

                    var value = diff.ToPower(3).Abs();
                    var normal = value.Sum();

                    if (normal > 0f)
                        value /= normal;

                    value *= jiggle;

                    weight.m_Weight1 = value.x;
                    weight.m_Weight2 = value.y;
                    weight.m_Weight3 = value.z;
                }

                weight.m_Weight0 *= scale;
                weight.m_Weight1 *= scale;
                weight.m_Weight2 *= scale;
                weight.m_Weight3 *= scale;

                weights[n] = weight;
            }

            item.boneWeights = weights;
            var poses = new Matrix4x4[bodyApp.AttachedBones.Length];

            for (var i = 0; i < bodyApp.AttachedBones.Length; i++)
            {
                var bone = bodyApp.AttachedBones[i];
                poses[i] = slimePrefab.Bones.First(x => x.Bone == bone).BoneObject.transform.worldToLocalMatrix * rootMatrix;
            }

            item.bindposes = poses;
            item.RecalculateBounds();
        }

        return false;
    }

    private static readonly Func<SlimeAppearanceApplicator.BoneMapping, bool> IsRoot = IsBoneRoot;

    private static bool IsBoneRoot(SlimeAppearanceApplicator.BoneMapping appearance) => appearance.Bone == SlimeAppearance.SlimeBone.Root;
}