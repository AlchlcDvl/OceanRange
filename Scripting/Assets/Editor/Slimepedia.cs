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
    private const string JsonAssetPath = "Assets/Jsons/slimepedia.json";

    public SlimeData[] slimes;

    [ContextMenu("Serialize to Json")]
    public void Serialize()
    {
        var json = JsonConvert.SerializeObject(slimes, JsonSettings.JsonSerialisationSettings);
        var asset = new TextAsset(json);
        AssetDatabase.CreateAsset(asset, JsonAssetPath);
    }

    [ContextMenu("Deserialize from Json")]
    public void Deserialize()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(JsonAssetPath).text;
        slimes = JsonConvert.DeserializeObject<SlimeData[]>(text, JsonSettings.JsonSerialisationSettings);
    }
}