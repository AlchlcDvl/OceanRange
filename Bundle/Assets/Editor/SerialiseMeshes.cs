using UnityEngine;
using UnityEditor;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System;
using System.Collections.Generic;

static class ExportMeshes
{
    [MenuItem("Ocean Range/Export Meshes as .cmesh")]
    static void ExportSelectedMeshes()
    {
        Debug.Log("Exporting...");

        AssetDatabase.StartAssetEditing();

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
                        {
                            WriteMesh(writer, mesh);
                        }
                    }
                }
            }
        }
        catch (Exception ex)
        {
            Debug.LogError(ex);
        }

        AssetDatabase.StopAssetEditing();
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        Debug.Log("Export process complete.");
    }

    static void WriteMesh(BinaryWriter writer, Mesh mesh)
    {
        WriteArray(writer, mesh.vertices, WriteVector3);
        WriteArray(writer, mesh.triangles, WriteInt);
        WriteArray(writer, mesh.uv, WriteVector2);
        writer.Flush();
    }

    static void WriteInt(BinaryWriter writer, int value) => writer.Write(value);

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
            writer.Write(0);
            return;
        }

        writer.Write(array.Length);

        for (var i = 0; i < array.Length; i++)
            writeAction(writer, array[i]);
    }

    static void WriteVector4(BinaryWriter writer, Vector4 vec)
    {
        writer.Write(vec.x);
        writer.Write(vec.y);
        writer.Write(vec.z);
        writer.Write(vec.w);
    }
}
