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
    private const string JsonAssetPath = "Assets/Jsons/cookbook.json";

    public Ingredients ingredients;

    [ContextMenu("Serialize to Json")]
    public void Serialize()
    {
        var json = JsonConvert.SerializeObject(ingredients, JsonSettings.JsonSerialisationSettings);
        var asset = new TextAsset(json);
        AssetDatabase.CreateAsset(asset, JsonAssetPath);
    }

    [ContextMenu("Deserialize from Json")]
    public void Deserialize()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(JsonAssetPath).text;
        ingredients = JsonConvert.DeserializeObject<Ingredients>(text, JsonSettings.JsonSerialisationSettings);
    }
}