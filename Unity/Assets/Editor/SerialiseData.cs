using UnityEngine;
using UnityEditor;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System;
using System.Collections.Generic;
using UnityEngine.Rendering;
using System.Runtime.CompilerServices;
using Newtonsoft.Json;
using OceanRange.Data;
using OceanRange.Modules;

static class ExportData
{
    private static readonly string[] Translations = new[] { "de", "en", "es", "fr", "ru", "tr" };


    [MenuItem("Ocean Range/Export Meshes as .cmesh")]
    static void ExportSelectedMeshes()
    {
        Debug.Log("Exporting...");

        try
        {
            var exportDirectory = Path.Combine("Assets", "..", "..", "Source", "Resources", "Data");
            PrepDir(exportDirectory);
        }
        catch (Exception ex)
        {
            Debug.Log(ex);
        }

        Debug.Log("Export process complete.");
    }

    static void PrepDir(string path)
    {
        if (!Directory.Exists(path))
            Directory.CreateDirectory(path);
        else
            Directory.EnumerateFiles(path, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);
    }
}