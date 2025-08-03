using UnityEngine;
using UnityEditor;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System;
using System.Collections.Generic;

class ExportMeshes
{
    [MenuItem("Meshes/Export As .mesh")]
    static void ExportSelectedMeshes()
    {
        string exportDirectory = "Assets/../../Source/Resources/Models";

        if (!Directory.Exists(exportDirectory))
            Directory.CreateDirectory(exportDirectory);
        else
            Directory.EnumerateFiles(exportDirectory, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);

        foreach (string guid in AssetDatabase.FindAssets("t:Mesh"))
        {
            string assetPath = AssetDatabase.GUIDToAssetPath(guid);

            if (!assetPath.EndsWith(".obj", System.StringComparison.OrdinalIgnoreCase) && !assetPath.EndsWith(".fbx", System.StringComparison.OrdinalIgnoreCase))
                continue;

            Mesh mesh = AssetDatabase.LoadAssetAtPath<Mesh>(assetPath);

            if (mesh == null)
                continue;

            string filePath = Path.Combine(exportDirectory, Path.GetFileNameWithoutExtension(assetPath) + ".mesh");
            using Stream stream = File.OpenWrite(filePath);
            using GZipStream compressor = new GZipStream(stream, System.IO.Compression.CompressionLevel.Optimal);
            using BinaryWriter writer = new BinaryWriter(compressor);
            WriteMesh(writer, mesh);
        }

        Debug.Log("Export process complete.");
    }

    static void WriteMesh(BinaryWriter writer, Mesh mesh)
    {
        WriteArray(writer, mesh.vertices, WriteVector3);
        WriteArray(writer, mesh.triangles, WriteInt);
        WriteArray(writer, mesh.normals, WriteVector3);
        WriteArray(writer, mesh.tangents, WriteVector4);
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
