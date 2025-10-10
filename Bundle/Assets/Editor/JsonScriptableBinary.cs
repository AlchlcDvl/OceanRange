using System;
using System.IO;
using Newtonsoft.Json;
using UnityEditor;
using UnityEngine;
using OceanRange.Unity.Json;
using System.Collections.Generic;
using System.Linq;
using System.IO.Compression;
using OceanRange.Common;

class JsonScriptableBinary
{
    private static readonly JsonSerializerSettings JsonSettings = new JsonSerializerSettings()
    {
        Formatting = Formatting.Indented,
        Converters = new List<JsonConverter>()
        {
            new ColorConverter(),
            // new Color32Converter(),
            new Vector3Converter(),
            new OrientationConverter(),
            new StringStringPairListConverter(),
            new StringStringArrayPairListConverter(),
            new StringColorPairListConverter(),
            new StringVector3ArrayPairListConverter(),
            new StringZoneRequirementPairListConverter(),
            new StringToStringPairListConverter(),
            new StringToStringPairListPairListConverter(),
            new StringToStringVector3ArrayPairListConverter(),
        }
    };

    private static readonly Type[] ScriptableTypes = new[] { typeof(Contacts), typeof(IngredientsUnity), typeof(LangHolderUnity), typeof(Largopedia), typeof(Mailbox), typeof(Slimepedia), typeof(WorldUnity) };

    [MenuItem("Ocean Range/Convert JSON To Scriptable")]
    static void JsonToScriptable()
    {
        Debug.Log("Starting conversion...");

        AssetDatabase.StartAssetEditing();

        JsonToScriptableInternal();

        AssetDatabase.StopAssetEditing();
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        Debug.Log("Conversion finished!");
    }

    static void JsonToScriptableInternal()
    {
        string assetDirectory = Path.Combine("Assets", "Data");

        if (!Directory.Exists(assetDirectory))
            Directory.CreateDirectory(assetDirectory);

        string jsonDirectory = Path.Combine("Assets", "Json");

        if (!Directory.Exists(jsonDirectory))
            Directory.CreateDirectory(jsonDirectory);

        foreach (var type in ScriptableTypes)
        {
            string assetGuid = AssetDatabase.FindAssets("t:" + type.Name)?.FirstOrDefault();
            Holder asset;

            if (assetGuid == null)
            {
                asset = ScriptableObject.CreateInstance(type) as Holder;
                var name = asset.name = asset.GetFileName();
                AssetDatabase.CreateAsset(asset, Path.Combine(assetDirectory, name + ".asset"));
            }
            else
            {
                string assetPath = AssetDatabase.GUIDToAssetPath(assetGuid);
                asset = AssetDatabase.LoadAssetAtPath(assetPath, type) as Holder;
            }

            string jsonPath = Path.Combine(jsonDirectory, asset.name + ".json");

            try
            {
                if (File.Exists(jsonPath))
                    asset.ReadJson(LoadJson(jsonPath, asset.DataType));
            }
            catch (Exception ex)
            {
                Debug.LogError(type.Name + ":\n" + ex);
            }

            EditorUtility.SetDirty(asset);
        }
    }

    public static object LoadJson(string path, Type type) => JsonConvert.DeserializeObject(File.ReadAllText(path), type, JsonSettings);

    [MenuItem("Ocean Range/Convert Scriptable To Binary")]
    static void ScriptableToBinary()
    {
        Debug.Log("Starting conversion...");

        AssetDatabase.StartAssetEditing();

        ScriptableToBinaryInternal();

        AssetDatabase.StopAssetEditing();
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        Debug.Log("Conversion finished!");
    }

    static void ScriptableToBinaryInternal()
    {
        string assetDirectory = Path.Combine("Assets", "Data");

        if (!Directory.Exists(assetDirectory))
            Directory.CreateDirectory(assetDirectory);

        string exportDirectory = Path.Combine("Assets", "..", "..", "Source", "Resources", "Data");

        if (!Directory.Exists(exportDirectory))
            Directory.CreateDirectory(exportDirectory);
        else
            Directory.EnumerateFiles(exportDirectory, "*.*", SearchOption.AllDirectories).ToList().ForEach(File.Delete);

        foreach (var type in ScriptableTypes)
        {
            string assetGuid = AssetDatabase.FindAssets("t:" + type.Name)?.FirstOrDefault();

            if (assetGuid == null)
                continue;

            string assetPath = AssetDatabase.GUIDToAssetPath(assetGuid);
            Holder asset = AssetDatabase.LoadAssetAtPath(assetPath, type) as Holder;

            string filePath = Path.Combine(exportDirectory, asset.name + ".data");

            using (Stream stream = File.OpenWrite(filePath))
            {
                using (GZipStream compressor = new GZipStream(stream, System.IO.Compression.CompressionLevel.Optimal))
                {
                    using (BinaryWriter writer = new BinaryWriter(compressor))
                    {
                        try
                        {
                            asset.SerialiseTo(writer);
                        }
                        catch (Exception ex)
                        {
                            Debug.LogError(type.Name + ":\n" + ex);
                        }

                        writer.Flush();
                    }
                }
            }

            EditorUtility.SetDirty(asset);
        }
    }

    [MenuItem("Ocean Range/Convert Scriptable To JSON")]
    static void ScriptableToJson()
    {
        Debug.Log("Starting conversion...");

        AssetDatabase.StartAssetEditing();

        ScriptableToJsonInternal();

        AssetDatabase.StopAssetEditing();
        AssetDatabase.SaveAssets();
        AssetDatabase.Refresh();

        Debug.Log("Conversion finished!");
    }

    static void ScriptableToJsonInternal()
    {
        string assetDirectory = Path.Combine("Assets", "Data");

        if (!Directory.Exists(assetDirectory))
            Directory.CreateDirectory(assetDirectory);

        string jsonDirectory = Path.Combine("Assets", "Json");

        if (!Directory.Exists(jsonDirectory))
            Directory.CreateDirectory(jsonDirectory);

        foreach (var type in ScriptableTypes)
        {
            string assetGuid = AssetDatabase.FindAssets("t:" + type.Name)?.FirstOrDefault();

            if (assetGuid == null)
                continue;

            string assetPath = AssetDatabase.GUIDToAssetPath(assetGuid);
            Holder asset = AssetDatabase.LoadAssetAtPath(assetPath, type) as Holder;

            string jsonPath = Path.Combine(jsonDirectory, asset.name + ".json");

            try
            {
                File.WriteAllText(jsonPath, JsonConvert.SerializeObject(asset.BoxedValue, JsonSettings));
            }
            catch (Exception ex)
            {
                Debug.LogError(type.Name + ":\n" + ex);
            }

            EditorUtility.SetDirty(asset);
        }
    }
}