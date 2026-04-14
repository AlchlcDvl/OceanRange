using UnityEngine;
using UnityEditor;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System;
using System.Collections.Generic;
using UnityEngine.Rendering;

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
                    using (GZipStream compressor = new GZipStream(stream, System.IO.Compression.CompressionLevel.Optimal))
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
        WriteAttributeData(writer, VertexAttribute.Color, mesh, m => m.colors32, WriteColor32);

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
        var min = bounds.min;
        var size = bounds.size;

        var nx = size.x > 0 ? (pos.x - min.x) / size.x : 0f;
        var ny = size.y > 0 ? (pos.y - min.y) / size.y : 0f;
        var nz = size.z > 0 ? (pos.z - min.z) / size.z : 0f;

        writer.Write((ushort)(Mathf.Clamp01(nx) * 65535f));
        writer.Write((ushort)(Mathf.Clamp01(ny) * 65535f));
        writer.Write((ushort)(Mathf.Clamp01(nz) * 65535f));
    }

    static void WriteQuantizedUV2(BinaryWriter writer, Vector2 uv)
    {
        writer.Write((ushort)(Mathf.Clamp01(uv.x) * 65535f));
        writer.Write((ushort)(Mathf.Clamp01(uv.y) * 65535f));
    }

    static void WriteQuantizedNormal(BinaryWriter writer, Vector3 normal)
    {
        writer.Write((sbyte)(Mathf.Clamp(normal.x, -1f, 1f) * 127f));
        writer.Write((sbyte)(Mathf.Clamp(normal.y, -1f, 1f) * 127f));
        writer.Write((sbyte)(Mathf.Clamp(normal.z, -1f, 1f) * 127f));
    }

    static void WriteQuantizedTangent(BinaryWriter writer, Vector4 tangent)
    {
        writer.Write((sbyte)(Mathf.Clamp(tangent.x, -1f, 1f) * 127f));
        writer.Write((sbyte)(Mathf.Clamp(tangent.y, -1f, 1f) * 127f));
        writer.Write((sbyte)(Mathf.Clamp(tangent.z, -1f, 1f) * 127f));
        writer.Write((sbyte)(Mathf.Clamp(tangent.w, -1f, 1f) * 127f));
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
