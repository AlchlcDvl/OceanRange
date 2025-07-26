using AssetsLib;

namespace OceanRange.Patches;

// Aims to reduce a bit of the overhead (comparison, array initialisation and indexing mainly) that the original code introduces + allows the meshes to recalculate bounds after their poses have been set for maximum effectiveness
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
        var zero = vertices.Aggregate(Vector3.zero, (current, vector) => current + vector) / vertices.Length;
        var num = vertices.Sum(vector => (vector - zero).magnitude) / vertices.Length;

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

        var rootMatrix = slimePrefab.Bones.First(x => x.Bone == SlimeAppearance.SlimeBone.Root).BoneObject.transform.localToWorldMatrix;

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
                    weight0 = 1f - jiggle,
                    boneIndex0 = 0
                };

                if (jiggle > 0f)
                {
                    weight.boneIndex1 = diff.x >= 0f ? 1 : 2;
                    weight.boneIndex2 = diff.y >= 0f ? 3 : 4;
                    weight.boneIndex3 = diff.z >= 0f ? 5 : 6;

                    var value = diff.Multiply(diff).Multiply(diff).Abs();
                    var normal = value.Sum();

                    if (normal > 0f)
                        value /= normal;

                    value *= jiggle;

                    weight.weight1 = value.x;
                    weight.weight2 = value.y;
                    weight.weight3 = value.z;
                }

                weight.weight0 *= scale;
                weight.weight1 *= scale;
                weight.weight2 *= scale;
                weight.weight3 *= scale;

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
}