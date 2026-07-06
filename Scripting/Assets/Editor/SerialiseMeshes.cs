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
                Directory.EnumerateFiles(exportDirectory, "*.cmesh", SearchOption.AllDirectories).ToList().ForEach(File.Delete);

            foreach (var guid in AssetDatabase.FindAssets("t:Mesh"))
            {
                var assetPath = AssetDatabase.GUIDToAssetPath(guid);

                if (!assetPath.Contains("ModelAssets") || !assetPath.EndsWith(".obj", System.StringComparison.Ordinal))
                    continue;

                var mesh = AssetDatabase.LoadAssetAtPath<Mesh>(assetPath);

                if (!mesh)
                    continue;

                var optimizedMesh = UnityEngine.Object.Instantiate(mesh);

                UnityEditor.MeshUtility.Optimize(optimizedMesh);

                var filePath = Path.Combine(exportDirectory, Path.GetFileNameWithoutExtension(assetPath) + ".cmesh");

                using (var stream = File.OpenWrite(filePath))
                using (var compressor = new DeflateStream(stream, System.IO.Compression.CompressionLevel.Optimal))
                using (var binary = new BinaryWriter(compressor))
                using (var writer = new DataWriter(binary))
                    WriteMesh(writer, optimizedMesh);

                UnityEngine.Object.DestroyImmediate(optimizedMesh);
                Resources.UnloadAsset(mesh);
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
        var bounds = mesh.bounds;

        writer.WriteBounds(bounds);

        var vertices = mesh.vertices;
        var vertexCount = vertices.Length;

        writer.WritePackedInt(vertexCount);

        writer.WriteArrayContents(vertices, (w, v) => w.WriteQuantizedPosition(v, bounds));

        writer.WriteDeltaEncodedInts(mesh.GetIndices(0));

        var exists = mesh.HasVertexAttribute(VertexAttribute.TexCoord0) && mesh.GetVertexAttributeDimension(VertexAttribute.TexCoord0) == 2;
        writer.WriteBool(exists);

        if (exists)
        {
            var uvs = new List<Vector2>(vertexCount);
            mesh.GetUVs(0, uvs);

            for (var i = 0; i < vertexCount; i++)
                writer.WritePackedFloat(uvs[i].x);

            for (var i = 0; i < vertexCount; i++)
                writer.WritePackedFloat(uvs[i].y);
        }

        writer.Flush();
    }
}