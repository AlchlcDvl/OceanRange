using UnityEngine;
using UnityEditor;
using UnityEditor.AssetImporters;
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

            using Stream stream = File.OpenRead(ctx.assetPath);
            using GZipStream decompressor = new GZipStream(stream, CompressionMode.Decompress);
            using BinaryReader reader = new BinaryReader(decompressor);

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

    private void ReadMesh(BinaryReader reader, Mesh mesh)
    {
        mesh.vertices = ReadArray(reader, ReadVector3);
        mesh.triangles = ReadArray(reader, ReadInt);
        mesh.normals = ReadArray(reader, ReadVector3);
        mesh.tangents = ReadArray(reader, ReadVector4);
        mesh.uv = ReadArray(reader, ReadVector2);
        mesh.RecalculateBounds();
    }

    private int ReadInt(BinaryReader reader) => reader.ReadInt32();

    private Vector3 ReadVector3(BinaryReader reader)
    {
        float x = reader.ReadSingle();
        float y = reader.ReadSingle();
        float z = reader.ReadSingle();
        return new Vector3(x, y, z);
    }

    private Vector2 ReadVector2(BinaryReader reader)
    {
        float x = reader.ReadSingle();
        float y = reader.ReadSingle();
        return new Vector2(x, y);
    }

    private Vector4 ReadVector4(BinaryReader reader)
    {
        float x = reader.ReadSingle();
        float y = reader.ReadSingle();
        float z = reader.ReadSingle();
        float w = reader.ReadSingle();
        return new Vector4(x, y, z, w);
    }

    private T[] ReadArray<T>(BinaryReader reader, Func<BinaryReader, T> readAction)
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
    }
}