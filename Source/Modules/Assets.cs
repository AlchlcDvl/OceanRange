namespace OceanRange.Modules;

// These classes exist because Sprite and Texture2D are sealed, warrantying the need for these wrapper classes
public abstract class OceanAsset(UObject asset) : IDisposable
{
    public readonly UObject BoxedAsset = asset;

    public void Dispose()
    {
        if (BoxedAsset)
            BoxedAsset.Destroy();

        GC.SuppressFinalize(this);
    }
}

public abstract class OceanAsset<T>(T asset) : OceanAsset(asset)
    where T : UObject // The actual asset
{
    public readonly T Asset = asset;
}

public abstract class SpriteAsset(Sprite sprite) : OceanAsset<Sprite>(sprite);

public sealed class JpgSprite(Sprite sprite) : SpriteAsset(sprite);

public sealed class PngSprite(Sprite sprite) : SpriteAsset(sprite);

public abstract class Texture2DAsset(Texture2D texture) : OceanAsset<Texture2D>(texture);

public sealed class JpgTexture2D(Texture2D texture) : Texture2DAsset(texture);

public sealed class PngTexture2D(Texture2D texture) : Texture2DAsset(texture);

public sealed class JsonAsset(string text) : OceanAsset<TextAsset>(new(text));

public sealed class MeshAsset(Mesh mesh) : OceanAsset<Mesh>(mesh);