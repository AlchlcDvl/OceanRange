using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using UnityEditor;
using UnityEngine;
using OceanRange.Data;
using OceanRange.Unity;

[CreateAssetMenu(menuName = "OceanRange/Data/atlas.json", fileName = "atlas.asset")]
public class Atlas : ScriptableObject
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
    private const string JsonAssetPath = "Assets/Jsons/atlas.json";
    
    public World world;

    [ContextMenu("Serialize to Json")]
    public void Serialize()
    {
        
    }
    [ContextMenu("Deserialize from Json")]
    public void Deserialize()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(JsonAssetPath).text;
        world = JsonConvert.DeserializeObject<World>(text, JsonSettings);
    }
}