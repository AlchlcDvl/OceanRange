using System.Collections.Generic;
using System.IO;
using System.Reflection;

namespace TheOceanRange.Managers;

public static class AssetManager
{
    private static Assembly Core { get; } = typeof(Main).Assembly;
    private static Dictionary<string, string> UnloadedAssets { get; } = [];
    private static Dictionary<string, Texture2D> LoadedTextures { get; } = [];
    private static Dictionary<string, Sprite> LoadedSprites { get; } = [];

    public static void FetchAssetNames()
    {
        foreach (var resourceName in Core.GetManifestResourceNames())
            UnloadedAssets[resourceName.Replace("Slime.Resources.", "")] = resourceName;
    }

    public static Sprite GetSprite(string fileName, FilterMode mode = FilterMode.Bilinear, TextureWrapMode wrapMode = TextureWrapMode.Repeat)
    {
        if (LoadedSprites.TryGetValue(fileName, out var sprite))
            return sprite;

        return LoadedSprites[fileName] = LoadImage(fileName, mode, wrapMode).CreateSprite();
    }

    public static Texture2D LoadImage(string fileName, FilterMode mode = FilterMode.Bilinear, TextureWrapMode wrapMode = TextureWrapMode.Repeat)
    {
        if (LoadedTextures.TryGetValue(fileName, out var texture))
            return texture;

        if (!UnloadedAssets.TryGetValue(fileName, out var path))
            throw new MissingResourceException(fileName);

        using var manifestResourceStream = Core.GetManifestResourceStream(path) ?? throw new MissingResourceException(fileName);
        var array = new byte[manifestResourceStream.Length];
        manifestResourceStream.Read(array, 0, array.Length);
        var texture2D = new Texture2D(1, 1);
        texture2D.LoadImage(array);
        texture2D.filterMode = mode;
        texture2D.wrapMode = wrapMode;
        texture2D.name = Path.GetFileNameWithoutExtension(fileName);
        UnloadedAssets.Remove(fileName);
        return LoadedTextures[fileName] = texture2D;
    }

    public static Sprite CreateSprite(this Texture2D texture)
    {
        var sprite = Sprite.Create(texture, new Rect(0f, 0f, texture.width, texture.height), new(0.5f, 0.5f), 1f);
        sprite.name = texture.name;
        return sprite;
    }

    public static T CreatePrefab<T>(this T obj) where T : UObject => UObject.Instantiate(obj, Main.Prefab, false);
}