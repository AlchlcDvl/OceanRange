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

    static readonly JsonSerializerSettings JsonSettings = new JsonSerializerSettings()
    {
        Formatting = Formatting.Indented,
        ContractResolver = new DefaultContractResolver()
        {
            NamingStrategy = new CamelCaseNamingStrategy(false, false)
        },
        Converters = new List<JsonConverter>()
        {
            new Vector3Converter(),
            new OrientationConverter(),
        }
    };

    [MenuItem("Ocean Range/Export Jsons as .cjson")]
    static void ExportSelectedData()
    {
        Debug.Log("Exporting Data...");

        var jsonDirectory = Path.Combine("Assets", "Jsons");
        var translations = Path.Combine(jsonDirectory, "Translations");

        try
        {
            var exportDirectory = Path.Combine("Assets", "..", "..", "Source", "Resources", "Data");
            PrepDir(exportDirectory);

            var exportTranslationsDirectory = Path.Combine(exportDirectory, "Translations");
            PrepDir(exportTranslationsDirectory);

            // Export arrays
            WriteArrayData<SlimeData>(jsonDirectory, exportDirectory, "slimepedia");
            WriteArrayData<LargoData>(jsonDirectory, exportDirectory, "largopedia");
            WriteArrayData<RancherData>(jsonDirectory, exportDirectory, "contacts");
            WriteArrayData<MailData>(jsonDirectory, exportDirectory, "mailbox");

            // Export single instances
            // WriteData<World>(jsonDirectory, exportDirectory, "atlas");
            WriteData<Ingredients>(jsonDirectory, exportDirectory, "cookbook");

            // Export translations
            foreach (var lang in Translations)
                WriteData<Translations>(translations, exportTranslationsDirectory, lang);
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

    static void WriteData<T>(string sourcePath, string destPath, string fileName) where T : JsonData
    {
        var source = Path.Combine(sourcePath, fileName + ".json");
        var dest = Path.Combine(destPath, fileName + ".cjson");

        if (!File.Exists(source))
        {
            Debug.LogWarning($"Skipped {fileName}: JSON file not found at {source}");
            return;
        }

        var jsonStr = File.ReadAllText(source);
        var data = JsonConvert.DeserializeObject<T>(jsonStr, JsonSettings);

        if (data == null)
        {
            Debug.LogError($"Failed to deserialize {fileName}.json");
            return;
        }

        using (var stream = File.OpenWrite(dest))
        using (var compressor = new DeflateStream(stream, System.IO.Compression.CompressionLevel.Optimal))
        using (var binary = new BinaryWriter(compressor))
        using (var writer = new DataWriter(binary))
        {
            data.FindStrings(writer);
            writer.PushPooledStrings();
            data.WriteTo(writer);
        }

        Debug.Log($"Successfully exported {fileName}.cjson");
    }

    static void WriteArrayData<T>(string sourcePath, string destPath, string fileName) where T : JsonData
    {
        var source = Path.Combine(sourcePath, fileName + ".json");
        var dest = Path.Combine(destPath, fileName + ".cjson");

        if (!File.Exists(source))
        {
            Debug.LogWarning($"Skipped {fileName}: JSON file not found at {source}");
            return;
        }

        var jsonStr = File.ReadAllText(source);
        var data = JsonConvert.DeserializeObject<T[]>(jsonStr, JsonSettings);

        if (data == null)
        {
            Debug.LogError($"Failed to deserialize {fileName}.json");
            return;
        }

        using (var stream = File.OpenWrite(dest))
        using (var compressor = new DeflateStream(stream, System.IO.Compression.CompressionLevel.Optimal))
        using (var binary = new BinaryWriter(compressor))
        using (var writer = new DataWriter(binary))
        {
            // Find strings for pooling
            foreach (var item in data)
            {
                item?.FindStrings(writer);
            }

            writer.PushPooledStrings();

            // Write array length using your optimized VarInt writer
            writer.WritePackedUInt((uint)data.Length);

            // Write each item's data
            foreach (var item in data)
            {
                item?.WriteTo(writer);
            }
        }

        Debug.Log($"Successfully exported {fileName}.cjson ({data.Length} items)");
    }
}