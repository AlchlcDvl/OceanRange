namespace TheOceanRange.Modules;

public sealed class JsonTextAsset(string text) : TextAsset(text)
{
    public static implicit operator string(JsonTextAsset value) => value.text;
}