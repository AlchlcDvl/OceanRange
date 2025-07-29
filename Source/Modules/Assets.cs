namespace OceanRange.Modules;

// These classes exist because Sprite and Texture2D are sealed, warrantying the need for these wrapper classes
public abstract class OceanAsset : IDisposable
{
    public abstract UObject BoxedAsset { get; }

    public void Dispose()
    {
        if (BoxedAsset)
            BoxedAsset.Destroy();

        GC.SuppressFinalize(this);
    }
}

public abstract class OceanAsset<T>(T asset) : OceanAsset
    where T : UObject // The actual asset
{
    public T Asset = asset;

    public sealed override UObject BoxedAsset => Asset;
}

public abstract class SpriteAsset(Sprite sprite) : OceanAsset<Sprite>(sprite);

public sealed class JpgSprite(Sprite sprite) : SpriteAsset(sprite);

public sealed class PngSprite(Sprite sprite) : SpriteAsset(sprite);

public abstract class Texture2DAsset(Texture2D texture) : OceanAsset<Texture2D>(texture);

public sealed class JpgTexture2D(Texture2D texture) : Texture2DAsset(texture);

public sealed class PngTexture2D(Texture2D texture) : Texture2DAsset(texture);

public sealed class JsonAsset(string text) : OceanAsset<TextAsset>(new(text));

public sealed class MeshAsset(Mesh mesh) : OceanAsset<Mesh>(mesh);