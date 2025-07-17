using AssetsLib;

namespace TheOceanRange.Patches;

[HarmonyPatch(typeof(MeshUtils), nameof(MeshUtils.GenerateBoneData), typeof(SlimeAppearanceApplicator), typeof(SlimeAppearanceObject), typeof(float), typeof(float), typeof(Mesh[]), typeof(SlimeAppearanceObject[]))]
public static class MeshUtilsFixPatch
{
    public static void Postfix(SlimeAppearanceApplicator slimePrefab, SlimeAppearanceObject bodyApp, float jiggleAmount, float scale, [HarmonyArgument(4)] Mesh[] additionalMesh, SlimeAppearanceObject[] appearanceObjects)
    {
        if (!slimePrefab)
            throw new ArgumentNullException(nameof(slimePrefab));

        if (!bodyApp)
            throw new ArgumentNullException(nameof(bodyApp));

        additionalMesh ??= [];
        appearanceObjects ??= [];

        var sharedMesh = bodyApp.GetComponent<SkinnedMeshRenderer>().sharedMesh;
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

        foreach (var slimeAppearanceObject in appearanceObjects)
        {
            if (!slimeAppearanceObject)
                throw new NullReferenceException("One or more of the SlimeAppearanceObjects are null");
            else
                slimeAppearanceObject.AttachedBones = bodyApp.AttachedBones;
        }

        var vertices = sharedMesh.vertices;
        var zero = Vector3.zero;

        foreach (var vector in vertices)
            zero += vector;

        var vector3 = zero / vertices.Length;
        var num = vertices.Sum(x => (x - vector3).magnitude) / vertices.Length;
        var list = new List<Mesh> { sharedMesh };

        foreach (var slimeAppearanceObject2 in appearanceObjects)
        {
            if (slimeAppearanceObject2.TryGetComponent<SkinnedMeshRenderer>(out var rend))
                list.Add(rend.sharedMesh);
            else
                Debug.LogWarning("One of the SlimeAppearanceObjects provided to AssetsLib.MeshUtils.GenerateBoneData does not use a SkinnedMeshRenderer");
        }

        list.AddRange(additionalMesh);

        foreach (var item in list)
        {
            if (!item)
            {
                Debug.LogWarning("One of the Meshes provided to AssetsLib.MeshUtils.GenerateBoneData is null");
                continue;
            }

            var vertices2 = item.vertices;
            var array4 = new BoneWeight[vertices2.Length];

            for (var n = 0; n < vertices2.Length; n++)
            {
                var diff = vertices2[n] - vector3;
                var num2 = Mathf.Clamp01((diff.magnitude - (num / 4f)) / (num / 2f) * jiggleAmount);
                var weight = default(BoneWeight);

                if (num2 == 0f)
                    weight.weight0 = 1f;
                else
                {
                    weight.weight0 = 1f - num2;
                    weight.boneIndex1 = (diff.x >= 0f) ? 1 : 2;
                    weight.boneIndex2 = (diff.y >= 0f) ? 3 : 4;
                    weight.boneIndex3 = (diff.z >= 0f) ? 5 : 6;
                    var value = diff.Multiply(diff).Multiply(diff).Abs();
                    var num3 = value.ToArray().Sum();
                    weight.weight1 = value.x / num3 * num2;
                    weight.weight2 = value.y / num3 * num2;
                    weight.weight3 = value.z / num3 * num2;
                }

                weight.weight0 *= scale;
                weight.weight1 *= scale;
                weight.weight2 *= scale;
                weight.weight3 *= scale;

                array4[n] = weight;
            }

            item.boneWeights = array4;
            item.bindposes = new Matrix4x4[bodyApp.AttachedBones.Length];

            for (var i = 0; i < bodyApp.AttachedBones.Length; i++)
            {
                item.bindposes[i]
                    = slimePrefab.Bones.First(x => x.Bone == bodyApp.AttachedBones[i]).BoneObject.transform.worldToLocalMatrix
                    * slimePrefab.Bones.First(x => x.Bone == SlimeAppearance.SlimeBone.Root).BoneObject.transform.localToWorldMatrix;
            }
        }
    }
}