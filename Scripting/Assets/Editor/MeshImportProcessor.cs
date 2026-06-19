using UnityEngine;
using UnityEditor;
using UnityEditor.Experimental.AssetImporters;

sealed class MeshImportProcessor : AssetPostprocessor
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