using UnityEngine;
using UnityEditor;
using System.IO;
using System.Linq;
using System;

public class ExportMeshes
{
    [MenuItem("Meshes/Export As .bin")]
    static void ExportSelectedMeshes()
    {
        string exportDirectory = "Assets/StreamingAssets/MeshExports";

        if (!Directory.Exists(exportDirectory))
            Directory.CreateDirectory(exportDirectory);
        else
            Directory.EnumerateFiles(exportDirectory, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);

        int exportedCount = 0;
        int skippedCount = 0;

        foreach (UnityEngine.Object obj in Selection.objects)
        {
            if (obj is not Mesh mesh)
            {
                skippedCount++;
                continue;
            }

            string filePath = Path.Combine(exportDirectory, mesh.name + ".bin");
            using BinaryWriter writer = new BinaryWriter(File.OpenWrite(filePath));
            WriteMesh(writer, mesh);
            exportedCount++;
        }

        Debug.Log($"Export process complete. Exported {exportedCount} mesh(es). Skipped {skippedCount} non-mesh object(s).");
    }

    static void WriteMesh(BinaryWriter writer, Mesh mesh)
    {
        WriteArray(writer, mesh.vertices, WriteVector3);
        WriteArray(writer, mesh.triangles, (x, y) => x.Write(y));
        WriteArray(writer, mesh.normals, WriteVector3);
        WriteArray(writer, mesh.colors, WriteColor);
        WriteArray(writer, mesh.uv, WriteVector2);
        WriteArray(writer, mesh.tangents, WriteVector4);
        WriteArray(writer, mesh.bindposes, WriteMatrix4);
        WriteArray(writer, mesh.boneWeights, WriteBoneWeight);
    }

    static void WriteBoneWeight(BinaryWriter writer, BoneWeight weight)
    {
        writer.Write(weight.boneIndex0);
        writer.Write(weight.boneIndex1);
        writer.Write(weight.boneIndex2);
        writer.Write(weight.boneIndex3);
        writer.Write(weight.weight0);
        writer.Write(weight.weight1);
        writer.Write(weight.weight2);
        writer.Write(weight.weight3);
    }

    static void WriteColor(BinaryWriter writer, Color color)
    {
        writer.Write(color.r);
        writer.Write(color.g);
        writer.Write(color.b);
        writer.Write(color.a);
    }

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

    static void WriteVector4(BinaryWriter writer, Vector4 vec)
    {
        writer.Write(vec.x);
        writer.Write(vec.y);
        writer.Write(vec.z);
        writer.Write(vec.w);
    }

    static void WriteMatrix4(BinaryWriter writer, Matrix4x4 matrix)
    {
        for (var i = 0; i < 4; i++)
            WriteVector4(writer, matrix.GetColumn(i));
    }

    static void WriteArray<T>(BinaryWriter writer, T[] array, Action<BinaryWriter, T> writeAction)
    {
        writer.Write(array.Length);

        for (var i = 0; i < array.Length; i++)
            writeAction(writer, array[i]);
    }
}
