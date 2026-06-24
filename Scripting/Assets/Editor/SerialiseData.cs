using UnityEngine;
using UnityEditor;
using System.IO;
using System.IO.Compression;
using System.Linq;
using System;
using Newtonsoft.Json;
using OceanRange.Data;
using OceanRange.Unity;
using Newtonsoft.Json.Serialization;
using System.Collections.Generic;

static class ExportData
{
    static readonly string[] Translations = { "de", "en", "es", "fr", "ru", "tr" };

    struct SingleExport
    {
        public string DestPath;
        public JsonData Data;
    }

    struct ArrayExport
    {
        public string DestPath;
        public JsonData[] Data;
    }

    [MenuItem("Ocean Range/Export Jsons as .cjson")]
    static void ExportSelectedData()
    {
        Debug.Log("Exporting Data...");

        var jsonDirectory = Path.Combine("Assets", "Jsons");
        var translations = Path.Combine(jsonDirectory, "Translations");
        var exportDirectory = Path.Combine("Assets", "..", "..", "Source", "Resources", "Data");
        var exportTranslationsDirectory = Path.Combine(exportDirectory, "Translations");

        try
        {
            PrepDir(exportDirectory);
            PrepDir(exportTranslationsDirectory);

            var singleInstances = new List<SingleExport>();
            var arrayInstances = new List<ArrayExport>();

            // Load arrays
            LoadArrayData<SlimeData>(jsonDirectory, exportDirectory, "slimepedia", arrayInstances);
            LoadArrayData<LargoData>(jsonDirectory, exportDirectory, "largopedia", arrayInstances);
            LoadArrayData<RancherData>(jsonDirectory, exportDirectory, "contacts", arrayInstances);
            LoadArrayData<MailData>(jsonDirectory, exportDirectory, "mailbox", arrayInstances);

            // Load single instances
            LoadSingleData<World>(jsonDirectory, exportDirectory, "atlas", singleInstances);
            LoadSingleData<Ingredients>(jsonDirectory, exportDirectory, "cookbook", singleInstances);
            // LoadSingleData<Refinery>(jsonDirectory, exportDirectory, "refinery", singleInstances);
            // LoadSingleData<Schematics>(jsonDirectory, exportDirectory, "blueprints", singleInstances);

            // Load translations
            foreach (var lang in Translations)
                LoadSingleData<Translations>(translations, exportTranslationsDirectory, lang, singleInstances);

            // Pool strings
            var globalStrings = new HashSet<string>(StringComparer.Ordinal);
            var pooler = new StringPooler(globalStrings);

            foreach (var export in singleInstances)
                export.Data.FindStrings(pooler);

            foreach (var export in arrayInstances)
            {
                foreach (var item in export.Data)
                    item.FindStrings(pooler);
            }

            // Convert HashSet to an ordered Dictionary
            var stringDict = new Dictionary<string, uint>(StringComparer.Ordinal);
            var poolIndex = 1u;
            var sortedStrings = globalStrings.OrderBy(x => x.Length).ThenBy(x => x, StringComparer.Ordinal).ToArray();

            foreach (var str in sortedStrings)
                stringDict[str] = poolIndex++;

            // Export the global string.pool file
            var poolPath = Path.Combine(exportDirectory, "string.pool");

            using (var stream = File.OpenWrite(poolPath))
            using (var compressor = new DeflateStream(stream, System.IO.Compression.CompressionLevel.Optimal))
            using (var binary = new BinaryWriter(compressor))
            using (var writer = new DataWriter(binary))
            {
                writer.WritePackedUInt((uint)sortedStrings.Length);

                foreach (var str in sortedStrings)
                    writer.WriteString(str);
            }

            // Export instances
            foreach (var export in singleInstances)
            {
                using (var stream = File.OpenWrite(export.DestPath))
                using (var compressor = new DeflateStream(stream, System.IO.Compression.CompressionLevel.Optimal))
                using (var binary = new BinaryWriter(compressor))
                using (var writer = new DataWriter(binary, stringDict))
                {
                    export.Data.WriteTo(writer);
                    writer.Flush();
                }
            }

            // Export arrays
            foreach (var export in arrayInstances)
            {
                using (var stream = File.OpenWrite(export.DestPath))
                using (var compressor = new DeflateStream(stream, System.IO.Compression.CompressionLevel.Optimal))
                using (var binary = new BinaryWriter(compressor))
                using (var writer = new DataWriter(binary, stringDict))
                {
                    writer.WritePackedUInt((uint)export.Data.Length);

                    foreach (var item in export.Data)
                        item.WriteTo(writer);

                    writer.Flush();
                }
            }
        }
        catch (Exception ex)
        {
            Debug.LogError($"Export failed: {ex}");
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

    static void LoadSingleData<T>(string sourcePath, string destPath, string fileName, List<SingleExport> list) where T : JsonData
    {
        var source = Path.Combine(sourcePath, fileName + ".json");

        if (!File.Exists(source))
        {
            Debug.LogWarning($"Skipped {fileName}: JSON file not found at {source}");
            return;
        }

        var data = JsonConvert.DeserializeObject<T>(File.ReadAllText(source), JsonSettings.JsonSerialisationSettings);

        if (data != null)
            list.Add(new SingleExport { DestPath = Path.Combine(destPath, fileName + ".cjson"), Data = data });
    }

    static void LoadArrayData<T>(string sourcePath, string destPath, string fileName, List<ArrayExport> list) where T : JsonData
    {
        var source = Path.Combine(sourcePath, fileName + ".json");

        if (!File.Exists(source))
        {
            Debug.LogWarning($"Skipped {fileName}: JSON file not found at {source}");
            return;
        }

        var data = JsonConvert.DeserializeObject<T[]>(File.ReadAllText(source), JsonSettings.JsonSerialisationSettings);

        if (data != null)
            list.Add(new ArrayExport { DestPath = Path.Combine(destPath, fileName + ".cjson"), Data = data });
    }
}