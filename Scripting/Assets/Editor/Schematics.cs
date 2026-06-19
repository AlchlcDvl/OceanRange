using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using OceanRange.Unity;
using OceanRange.Data;
using UnityEditor;
using UnityEngine;

[CreateAssetMenu(menuName = "OceanRange/Data/blueprints.json", fileName = "blueprints.asset")]
public class Blueprints : ScriptableObject
{
    private const string JsonAssetPath = "Assets/Jsons/blueprints.json";

    public Schematics blueprints;

    [ContextMenu("Serialize to Json")]
    public void Serialize()
    {
        var json = JsonConvert.SerializeObject(blueprints, JsonSettings.JsonSerialisationSettings);
        var asset = new TextAsset(json);
        AssetDatabase.CreateAsset(asset, JsonAssetPath);
    }

    [ContextMenu("Deserialize from Json")]
    public void Deserialize()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(JsonAssetPath).text;
        blueprints = JsonConvert.DeserializeObject<OceanRange.Data.Schematics>(text, JsonSettings.JsonSerialisationSettings);
    }
}