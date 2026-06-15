using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using OceanRange.Unity;
using OceanRange.Data;
using UnityEditor;
using UnityEngine;
[CreateAssetMenu(menuName = "OceanRange/Data/schematics.json", fileName = "schematics.asset")]
public class Schematics : ScriptableObject
{
    private static readonly JsonSerializerSettings JsonSettings = new JsonSerializerSettings()
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
    private const string JsonAssetPath = "Assets/Jsons/schematics.json";
    
    public OceanRange.Data.Schematics schematics;

    [ContextMenu("Serialize to Json")]
    public void Serialize()
    {
        var json = JsonConvert.SerializeObject(schematics, JsonSettings);
        var asset = new TextAsset(json);
        AssetDatabase.CreateAsset(asset, JsonAssetPath);
    }
    
    [ContextMenu("Deserialize from Json")]
    public void Deserialize()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(JsonAssetPath).text;
        schematics = JsonConvert.DeserializeObject<OceanRange.Data.Schematics>(text, JsonSettings);
    }
}