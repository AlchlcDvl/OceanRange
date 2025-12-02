using UnityEngine;
using UnityEditor;
using UnityEditor.Experimental.AssetImporters;
using System.IO;
using System.IO.Compression;
using System;
using System.Collections.Generic;

[ScriptedImporter(1, "cmesh")]
sealed class MeshImporter : ScriptedImporter
{
    public override void OnImportAsset(AssetImportContext ctx)
    {
        try
        {
            Mesh importedMesh = new Mesh();
            importedMesh.name = Path.GetFileNameWithoutExtension(ctx.assetPath);

            Stream stream = File.OpenRead(ctx.assetPath);
            GZipStream decompressor = new GZipStream(stream, CompressionMode.Decompress);
            BinaryReader reader = new BinaryReader(decompressor);

            ReadMesh(reader, importedMesh);

            ctx.AddObjectToAsset("mesh", importedMesh);
            ctx.SetMainObject(importedMesh);

            var gameObject = new GameObject(importedMesh.name);
            var meshFilter = gameObject.AddComponent<MeshFilter>();
            meshFilter.sharedMesh = importedMesh;
            ctx.AddObjectToAsset("GameObject", gameObject);
        }
        catch (Exception e)
        {
            Debug.LogError($"Failed to import mesh from {ctx.assetPath}. Error: {e.Message}");
        }
    }

    static void ReadMesh(BinaryReader reader, Mesh mesh)
    {
        mesh.indexFormat = (IndexFormat)reader.ReadByte();
        mesh.vertices = BinaryUtils.ReadArray(reader, BinaryUtils.ReadVector3);
        mesh.normals = BinaryUtils.ReadArray(reader, BinaryUtils.ReadVector3);
        mesh.tangents = BinaryUtils.ReadArray(reader, BinaryUtils.ReadVector4);
        mesh.bounds = new()
        {
            center = BinaryUtils.ReadVector3(reader),
            extents = BinaryUtils.ReadVector3(reader)
        };
        mesh.subMeshCount = reader.ReadInt32();

        for (var i = 0; i < mesh.subMeshCount; i++)
            mesh.SetTriangles(BinaryUtils.ReadArray(reader, ReadInt), i);

        for (var i = 0; i < 8; i++)
        {
            var uvs = BinaryUtils.ReadArray(reader, BinaryUtils.ReadVector2);

            if (uvs.Length > 0)
                mesh.SetUVs(i, uvs);
        }
    }

    static int ReadInt(BinaryReader reader) => reader.ReadInt32();

    static Vector3 ReadVector3(BinaryReader reader)
    {
        float x = reader.ReadSingle();
        float y = reader.ReadSingle();
        float z = reader.ReadSingle();
        return new Vector3(x, y, z);
    }

    static Vector2 ReadVector2(BinaryReader reader)
    {
        float x = reader.ReadSingle();
        float y = reader.ReadSingle();
        return new Vector2(x, y);
    }

    static T[] ReadArray<T>(BinaryReader reader, Func<BinaryReader, T> readAction)
    {
        int length = reader.ReadInt32();

        if (length == 0)
            return Array.Empty<T>();

        T[] array = new T[length];

        for (int i = 0; i < length; i++)
            array[i] = readAction(reader);

        return array;
    }
}

[CustomEditor(typeof(MeshImporter))]
sealed class MeshImporterEditor : ScriptedImporterEditor
{
    public override void OnInspectorGUI()
    {
        base.OnInspectorGUI();

        EditorGUILayout.Space();
        EditorGUILayout.HelpBox("This file is a custom .cmesh asset.", MessageType.Info);

        if (GUILayout.Button("Force Re-import"))
        {
            var importer = target as MeshImporter;
            importer.SaveAndReimport();
        }
    }
}

sealed class MeshImportPostprocessor : AssetPostprocessor
{
    void OnPostprocessModel(GameObject _)
    {
        var importer = assetImporter as ModelImporter;

        if (importer == null)
            return;

        importer.isReadable = true;
        importer.importBlendShapes = false;
        importer.importCameras = false;
        importer.importLights = false;
        importer.importVisibility = false;
        importer.animationType = ModelImporterAnimationType.None;
        importer.importAnimation = false;
        importer.materialImportMode = 0;
        importer.importNormals = ModelImporterNormals.Calculate;
    }
}