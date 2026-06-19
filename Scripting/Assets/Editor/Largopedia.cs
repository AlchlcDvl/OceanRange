using System.Collections.Generic;
using Newtonsoft.Json;
using Newtonsoft.Json.Serialization;
using UnityEditor;
using UnityEngine;
using OceanRange.Data;
using OceanRange.Unity;

[CreateAssetMenu(menuName = "OceanRange/Data/largopedia.json", fileName = "largopedia.asset")]
public class Largopedia : ScriptableObject
{
    private const string JsonAssetPath = "Assets/Jsons/largopedia.json";

    public LargoData[] largos;

    [ContextMenu("Serialize to Json")]
    public void Serialize()
    {
        var json = JsonConvert.SerializeObject(largos, JsonSettings.JsonSerialisationSettings);
        var asset = new TextAsset(json);
        AssetDatabase.CreateAsset(asset, JsonAssetPath);
    }

    [ContextMenu("Deserialize from Json")]
    public void Deserialize()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(JsonAssetPath).text;
        largos = JsonConvert.DeserializeObject<LargoData[]>(text, JsonSettings.JsonSerialisationSettings);
    }
}