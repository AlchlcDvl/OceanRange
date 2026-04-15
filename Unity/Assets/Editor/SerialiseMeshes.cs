using UnityEngine;
using UnityEditor;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System;
using System.Collections.Generic;
using UnityEngine.Rendering;
using System.Runtime.CompilerServices;

static class ExportMeshes
{
    [MenuItem("Ocean Range/Export Meshes as .cmesh")]
    static void ExportSelectedMeshes()
    {
        Debug.Log("Exporting...");

        try
        {
            string exportDirectory = Path.Combine("Assets", "..", "..", "Source", "Resources", "Models");

            if (!Directory.Exists(exportDirectory))
                Directory.CreateDirectory(exportDirectory);
            else
                Directory.EnumerateFiles(exportDirectory, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);

            foreach (string guid in AssetDatabase.FindAssets("t:Mesh"))
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(guid);

                if (!assetPath.Contains("ModelAssets") || (!assetPath.EndsWith(".obj", System.StringComparison.Ordinal) && !assetPath.EndsWith(".fbx", System.StringComparison.Ordinal)))
                    continue;

                Mesh mesh = AssetDatabase.LoadAssetAtPath<Mesh>(assetPath);

                if (!mesh)
                    continue;

                string filePath = Path.Combine(exportDirectory, Path.GetFileNameWithoutExtension(assetPath) + ".cmesh");

                using (Stream stream = File.OpenWrite(filePath))
                {
                    using (DeflateStream compressor = new DeflateStream(stream, System.IO.Compression.CompressionLevel.Optimal))
                    {
                        using (BinaryWriter writer = new BinaryWriter(compressor))
                            WriteMesh(writer, mesh);
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Debug.Log(ex);
        }

        Debug.Log("Export process complete.");
    }

    static void WriteMesh(BinaryWriter writer, Mesh mesh)
    {
        writer.Write((byte)mesh.indexFormat);

        var bounds = mesh.bounds;

        WriteBounds(writer, bounds);
        WritePackedInt(writer, mesh.subMeshCount);

        var vertices = mesh.vertices;
        var vertexCount = vertices.Length;

        WritePackedInt(writer, vertexCount);

        WriteArrayContents(writer, vertices, (w, v) => WriteQuantizedPosition(w, v, bounds));

        WriteAttributeData(writer, VertexAttribute.Normal, mesh, m => m.normals, WriteQuantizedNormal);
        WriteAttributeData(writer, VertexAttribute.Tangent, mesh, m => m.tangents, WriteQuantizedTangent);

        WriteColorData(writer, mesh);

        for (var i = 0; i < mesh.subMeshCount; i++)
        {
            var descriptor = mesh.GetSubMesh(i);
            writer.Write((byte)descriptor.topology);
            WriteBounds(writer, descriptor.bounds);
            WriteIndices(writer, mesh.GetIndices(i));
        }

        var uvs2 = new List<Vector2>(vertexCount);
        var uvs3 = new List<Vector3>(vertexCount);
        var uvs4 = new List<Vector4>(vertexCount);

        for (var i = 0; i < 8; i++)
        {
            var attr = VertexAttribute.TexCoord0 + i;

            if (mesh.HasVertexAttribute(attr))
            {
                var dimension = mesh.GetVertexAttributeDimension(attr);
                writer.Write((byte)dimension);

                if (dimension == 2)
                    WriteUVs(writer, i, uvs2, WriteQuantizedUV2, mesh.GetUVs);
                else if (dimension == 3)
                    WriteUVs(writer, i, uvs3, WriteVector3, mesh.GetUVs);
                else if (dimension == 4)
                    WriteUVs(writer, i, uvs4, WriteVector4, mesh.GetUVs);
            }
            else
                writer.Write((byte)0);
        }

        writer.Flush();
    }

    static void WriteAttributeData<T>(BinaryWriter writer, VertexAttribute attribute, Mesh mesh, Func<Mesh, T[]> fetcher, Action<BinaryWriter, T> writeAction)
    {
        if (mesh.HasVertexAttribute(attribute))
        {
            writer.Write(true);
            WriteArrayContents(writer, fetcher(mesh), writeAction);
        }
        else
        {
            writer.Write(false);
        }
    }

    static void WriteColorData(BinaryWriter writer, Mesh mesh)
    {
        if (!mesh.HasVertexAttribute(VertexAttribute.Color))
        {
            writer.Write((byte)0); // State 0: None
            return;
        }

        var colors = mesh.colors32;

        if (IsUniformColor(colors, out Color32 uniformColor))
        {
            writer.Write((byte)1); // State 1: Uniform
            WriteColor32(writer, uniformColor);
        }
        else
        {
            writer.Write((byte)2); // State 2: Variable
            WriteArrayContents(writer, colors, WriteColor32);
        }
    }

    static void WriteIndices(BinaryWriter writer, int[] indices)
    {
        if (indices == null || indices.Length == 0)
        {
            WritePackedInt(writer, 0);
            return;
        }

        WritePackedInt(writer, indices.Length);

        var previousIndex = 0;

        for (var i = 0; i < indices.Length; i++)
        {
            var currentIndex = indices[i];
            var delta = currentIndex - previousIndex;
            var zigZagDelta = ZigZagEncode(delta);
            WriteVarInt(writer, zigZagDelta);
            previousIndex = currentIndex;
        }
    }

    static void WriteQuantizedPosition(BinaryWriter writer, Vector3 pos, Bounds bounds)
    {
        writer.Write(Mathf.FloatToHalf(NormalizeWithinBounds(pos.x, bounds.min.x, bounds.size.x)));
        writer.Write(Mathf.FloatToHalf(NormalizeWithinBounds(pos.y, bounds.min.y, bounds.size.y)));
        writer.Write(Mathf.FloatToHalf(NormalizeWithinBounds(pos.z, bounds.min.z, bounds.size.z)));
    }

    static void WriteQuantizedUV2(BinaryWriter writer, Vector2 uv)
    {
        writer.Write(Mathf.FloatToHalf(uv.x));
        writer.Write(Mathf.FloatToHalf(uv.y));
    }

    static void WriteQuantizedNormal(BinaryWriter writer, Vector3 normal)
    {
        var octNormal = OctEncode(normal);
        writer.Write(QuantizeMinus1To1ToSbyte(octNormal.x));
        writer.Write(QuantizeMinus1To1ToSbyte(octNormal.y));
    }

    static void WriteQuantizedTangent(BinaryWriter writer, Vector4 tangent)
    {
        var tangentDir = new Vector3(tangent.x, tangent.y, tangent.z);
        var octTangent = OctEncode(tangentDir);

        writer.Write(QuantizeMinus1To1ToSbyte(octTangent.x));
        writer.Write(QuantizeMinus1To1ToSbyte(octTangent.y));

        writer.Write(tangent.w > 0 ? (byte)1 : (byte)0);
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    static float NormalizeWithinBounds(float value, float min, float size) => size > 0f ? (value - min) / size : 0f;

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    static sbyte QuantizeMinus1To1ToSbyte(float value) => (sbyte)(Mathf.Clamp(value, -1f, 1f) * 127f);

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    static Vector2 OctEncode(Vector3 v)
    {
        var l1Norm = Mathf.Abs(v.x) + Mathf.Abs(v.y) + Mathf.Abs(v.z);

        if (l1Norm < 0.0001f)
            return Vector2.zero;

        var res = new Vector2(v.x / l1Norm, v.y / l1Norm);

        if (v.z < 0f)
        {
            var x = res.x;
            var y = res.y;
            res.x = (1f - Mathf.Abs(y)) * SignNotZero(x);
            res.y = (1f - Mathf.Abs(x)) * SignNotZero(y);
        }

        return res;
    }

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    static float SignNotZero(float v) => v >= 0f ? 1f : -1f;

    [MethodImpl(MethodImplOptions.AggressiveInlining)]
    static bool IsUniformColor(Color32[] colors, out Color32 uniformColor)
    {
        uniformColor = default;

        if (colors == null || colors.Length == 0)
            return false;

        uniformColor = colors[0];

        for (var i = 1; i < colors.Length; i++)
        {
            var color = colors[i];

            if (color.r != uniformColor.r ||
                color.g != uniformColor.g ||
                color.b != uniformColor.b ||
                color.a != uniformColor.a)
            {
                return false;
            }
        }

        return true;
    }

    static void WriteUVs<T>(BinaryWriter writer, int index, List<T> uvs, Action<BinaryWriter, T> writeAction, Action<int, List<T>> getUVs)
    {
        getUVs(index, uvs);
        WriteListContents(writer, uvs, writeAction);
        uvs.Clear();
    }

    static uint ZigZagEncode(int value) => (uint)((value << 1) ^ (value >> 31));

    static void WriteVarInt(BinaryWriter writer, ulong value)
    {
        while (value >= 0x80)
        {
            writer.Write((byte)(value | 0x80));
            value >>= 7;
        }

        writer.Write((byte)value);
    }

    static void WritePackedInt(BinaryWriter writer, int value) => WriteVarInt(writer, (ulong)value);

    static void WriteVector3(BinaryWriter writer, Vector3 vec)
    {
        writer.Write(vec.x);
        writer.Write(vec.y);
        writer.Write(vec.z);
    }

    static void WriteVector2(BinaryWriter writer, Vector2 vec)
    {
        writer.Write(vec.x);
        writer.Write(vec.y);
    }

    static void WriteArray<T>(BinaryWriter writer, T[] array, Action<BinaryWriter, T> writeAction)
    {
        if (array == null)
        {
            WritePackedInt(writer, 0);
            return;
        }

        WritePackedInt(writer, array.Length);
        WriteArrayContents(writer, array, writeAction);
    }

    static void WriteArrayContents<T>(BinaryWriter writer, T[] array, Action<BinaryWriter, T> writeAction)
    {
        for (var i = 0; i < array.Length; i++)
            writeAction(writer, array[i]);
    }

    static void WriteList<T>(BinaryWriter writer, List<T> list, Action<BinaryWriter, T> writeAction)
    {
        if (list == null)
        {
            WritePackedInt(writer, 0);
            return;
        }

        WritePackedInt(writer, list.Count);
        WriteListContents(writer, list, writeAction);
    }

    static void WriteListContents<T>(BinaryWriter writer, List<T> list, Action<BinaryWriter, T> writeAction)
    {
        for (var i = 0; i < list.Count; i++)
            writeAction(writer, list[i]);
    }

    static void WriteVector4(BinaryWriter writer, Vector4 vec)
    {
        writer.Write(vec.x);
        writer.Write(vec.y);
        writer.Write(vec.z);
        writer.Write(vec.w);
    }

    static void WriteColor32(BinaryWriter writer, Color32 col)
    {
        writer.Write(col.r);
        writer.Write(col.g);
        writer.Write(col.b);
        writer.Write(col.a);
    }

    static void WriteBounds(BinaryWriter writer, Bounds bounds)
    {
        WriteVector3(writer, bounds.center);
        WriteVector3(writer, bounds.extents);
    }
}
