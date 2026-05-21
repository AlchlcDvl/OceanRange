using UnityEngine;
using UnityEditor;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System;
using System.Collections.Generic;
using UnityEngine.Rendering;
using System.Runtime.CompilerServices;
using OceanRange.Data;

static class ExportMeshes
{
    [MenuItem("Ocean Range/Export Meshes as .cmesh")]
    static void ExportSelectedMeshes()
    {
        Debug.Log("Exporting Meshes...");

        try
        {
            var exportDirectory = Path.Combine("Assets", "..", "..", "Source", "Resources", "Models");

            if (!Directory.Exists(exportDirectory))
                Directory.CreateDirectory(exportDirectory);
            else
                Directory.EnumerateFiles(exportDirectory, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);

            foreach (var guid in AssetDatabase.FindAssets("t:Mesh"))
            {
                var assetPath = AssetDatabase.GUIDToAssetPath(guid);

                if (!assetPath.Contains("ModelAssets") || (!assetPath.EndsWith(".obj", System.StringComparison.Ordinal) && !assetPath.EndsWith(".fbx", System.StringComparison.Ordinal)))
                    continue;

                Mesh mesh = AssetDatabase.LoadAssetAtPath<Mesh>(assetPath);

                if (!mesh)
                    continue;

                var filePath = Path.Combine(exportDirectory, Path.GetFileNameWithoutExtension(assetPath) + ".cmesh");

                using (var stream = File.OpenWrite(filePath))
                using (var compressor = new DeflateStream(stream, System.IO.Compression.CompressionLevel.Optimal))
                using (var binary = new BinaryWriter(compressor))
                using (var writer = new DataWriter(binary))
                {
                    writer.PushPooledStrings();
                    WriteMesh(writer, mesh);
                }
            }
        }
        catch (Exception ex)
        {
            Debug.Log(ex);
        }

        Debug.Log("Export process complete.");
    }

    static void WriteMesh(DataWriter writer, Mesh mesh)
    {
        writer.WriteByte((byte)mesh.indexFormat);

        var bounds = mesh.bounds;

        writer.WriteBounds(bounds);
        writer.WritePackedInt(mesh.subMeshCount);

        var vertices = mesh.vertices;
        var vertexCount = vertices.Length;

        writer.WritePackedInt(vertexCount);

        writer.WriteArrayContents(vertices, (w, v) => w.WriteQuantizedPosition(v, bounds));

        WriteAttributeData(writer, VertexAttribute.Normal, mesh, m => m.normals, (w, v) => w.WriteQuantizedNormal(v));
        WriteAttributeData(writer, VertexAttribute.Tangent, mesh, m => m.tangents, (w, v) => w.WriteQuantizedTangent(v));

        WriteColorData(writer, mesh);

        for (var i = 0; i < mesh.subMeshCount; i++)
        {
            var descriptor = mesh.GetSubMesh(i);
            writer.WriteByte((byte)descriptor.topology);
            writer.WriteBounds(descriptor.bounds);
            writer.WriteDeltaEncodedIndices(mesh.GetIndices(i));
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
                writer.WriteByte((byte)dimension);

                if (dimension == 2)
                    WriteUVs(writer, i, uvs2, (w, v) => w.WriteQuantizedUV2(v), mesh.GetUVs);
                else if (dimension == 3)
                    WriteUVs(writer, i, uvs3, (w, v) => w.WriteVector3(v), mesh.GetUVs);
                else if (dimension == 4)
                    WriteUVs(writer, i, uvs4, (w, v) => w.WriteVector4(v), mesh.GetUVs);
            }
            else
                writer.WriteByte((byte)0);
        }

        writer.Flush();
    }

    static void WriteAttributeData<T>(DataWriter writer, VertexAttribute attribute, Mesh mesh, Func<Mesh, T[]> fetcher, Action<DataWriter, T> writeAction)
    {
        if (mesh.HasVertexAttribute(attribute))
        {
            writer.WriteBool(true);
            writer.WriteArrayContents(fetcher(mesh), writeAction);
        }
        else
        {
            writer.WriteBool(false);
        }
    }

    static void WriteColorData(DataWriter writer, Mesh mesh)
    {
        if (!mesh.HasVertexAttribute(VertexAttribute.Color))
        {
            writer.WriteByte((byte)0); // State 0: None
            return;
        }

        var colors = mesh.colors32;

        if (IsUniformColor(colors, out Color32 uniformColor))
        {
            writer.WriteByte((byte)1); // State 1: Uniform
            writer.WriteColor32(uniformColor);
        }
        else
        {
            writer.WriteByte((byte)2); // State 2: Variable
            writer.WriteArrayContents(colors, (w, v) => w.WriteColor32(v));
        }
    }

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

    static void WriteUVs<T>(DataWriter writer, int index, List<T> uvs, Action<DataWriter, T> writeAction, Action<int, List<T>> getUVs)
    {
        getUVs(index, uvs);
        writer.WriteListContents(uvs, writeAction);
        uvs.Clear();
    }
}