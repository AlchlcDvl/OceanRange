using AssetsLib;

namespace OceanRange.Patches;

// Aims to reduce a bit of the overhead (comparison, array initialisation and indexing mainly) that the original code introduces + allows the meshes to recalculate bounds after their poses have been set for maximum effectiveness
[HarmonyPatch(typeof(MeshUtils), nameof(MeshUtils.GenerateBoneData), typeof(SlimeAppearanceApplicator), typeof(SlimeAppearanceObject), typeof(float), typeof(float), typeof(Mesh[]), typeof(SlimeAppearanceObject[]))]
public static class MeshUtilsImprovement
{
    public static bool Prefix(SlimeAppearanceApplicator slimePrefab, SlimeAppearanceObject bodyApp, float jiggleAmount, float scale, Mesh[] AdditionalMesh, SlimeAppearanceObject[] appearanceObjects)
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
        var list = new List<Mesh> { sharedMesh };

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

        if (AdditionalMesh != null)
            list.AddRange(AdditionalMesh);

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
                var vector5 = vertices2[n] - zero;
                var num2 = Mathf.Clamp01((vector5.magnitude - (num / 4f)) / (num / 2f) * jiggleAmount);
                var weight = new BoneWeight
                {
                    weight0 = 1f - num2,
                    boneIndex0 = 0
                };

                if (num2 > 0f)
                {
                    weight.boneIndex1 = vector5.x >= 0f ? 1 : 2;
                    weight.boneIndex2 = vector5.y >= 0f ? 3 : 4;
                    weight.boneIndex3 = vector5.z >= 0f ? 5 : 6;

                    var value = vector5.Multiply(vector5).Multiply(vector5).Abs();
                    var num3 = value.ToArray().Sum();

                    weight.weight1 = value.x / num3 * num2;
                    weight.weight2 = value.y / num3 * num2;
                    weight.weight3 = value.z / num3 * num2;
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

            if (!item.name.EndsWith("_Clone"))
                item.RecalculateBounds();
        }

        return false;
    }
}