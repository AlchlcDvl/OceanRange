using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using OceanRange.Unity;
using OceanRange.Data;
using UnityEditor;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Data/slimepedia.json", fileName = "slimepedia.asset")]
public class Slimepedia : ScriptableObject
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
    private const string JsonAssetPath = "Assets/Jsons/slimepedia.json";
    
    public SlimeData[] slimes;

    [ContextMenu("Serialize to Json")]
    public void Serialize()
    {
        
    }
    [ContextMenu("Deserialize from Json")]
    public void Deserialize()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(JsonAssetPath).text;
        slimes = JsonConvert.DeserializeObject<SlimeData[]>(text, JsonSettings);
    }
}