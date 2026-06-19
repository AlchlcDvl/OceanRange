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
    private const string JsonAssetPath = "Assets/Jsons/atlas.json";

    public World world;

    [ContextMenu("Serialize to Json")]
    public void Serialize()
    {
        var json = JsonConvert.SerializeObject(world, JsonSettings.JsonSerialisationSettings);
        var asset = new TextAsset(json);
        AssetDatabase.CreateAsset(asset, JsonAssetPath);
    }

    [ContextMenu("Deserialize from Json")]
    public void Deserialize()
    {
        var text = AssetDatabase.LoadAssetAtPath<TextAsset>(JsonAssetPath).text;
        world = JsonConvert.DeserializeObject<World>(text, JsonSettings.JsonSerialisationSettings);
    }
}