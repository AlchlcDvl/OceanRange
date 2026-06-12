using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using UnityEditor;
using UnityEngine;
using OceanRange.Data;
using OceanRange.Unity;

[CreateAssetMenu(menuName = "OceanRange/Data/cookbook.json", fileName = "cookbook.asset")]
public class Cookbook : ScriptableObject
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
    private const string JsonAssetPath = "Assets/Jsons/cookbook.json";
    
    public Ingredients ingredients;

    [ContextMenu("Serialize to Json")]
    public void Serialize()
    {
        
    }
    [ContextMenu("Deserialize from Json")]
    public void Deserialize()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(JsonAssetPath).text;
        ingredients = JsonConvert.DeserializeObject<Ingredients>(text, JsonSettings);
    }
}