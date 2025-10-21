namespace OceanRange.Slimes;

// Had to copy paste base game code because there's too many entry points to worry about otherwise
public sealed class StealthFixer : RegisteredActorBehaviour, RegistryUpdateable, SpawnListener
{
    private Vacuumable Vacuumable;
    private SlimeAudio SlimeAudio;

    private float InitStealthUntil;
    private float CurrentOpacity = 1f;
    private float TargetOpacity = 1f;
    private float LastOpacity = 1f;

    private StealthFixerController StealthController => field ?? new(gameObject);

    public void Awake()
    {
        Vacuumable = GetComponent<Vacuumable>();
        SlimeAudio = GetComponent<SlimeAudio>();

        if (TryGetComponent<SlimeAppearanceApplicator>(out var slimeAppearanceApplicator) && slimeAppearanceApplicator.Appearance)
            UpdateMaterialStealthController();
    }

    public void RegistryUpdate() => UpdateStealthOpacity();

    public void DidSpawn()
    {
        CurrentOpacity = 0f;
        InitStealthUntil = Time.time + 5f;
    }

    public void SetStealth(bool stealth)
    {
        TargetOpacity = stealth ? 0f : 1f;
        SlimeAudio.Play(stealth ? SlimeAudio.slimeSounds.cloakCue : SlimeAudio.slimeSounds.decloakCue);
    }

    public void SetOpacity(float opacity)
    {
        StealthController.SetOpacity(opacity);
        LastOpacity = opacity;
    }

    public void UpdateMaterialStealthController()
    {
        StealthController.UpdateMaterials(gameObject);
        LastOpacity = 1f;
    }

    public void UpdateStealthOpacity()
    {
        var num = Time.time < InitStealthUntil ? 0f : TargetOpacity;

        if (num > CurrentOpacity)
            CurrentOpacity = Mathf.Min(num, CurrentOpacity + (2f * Time.deltaTime));
        else if (TargetOpacity < CurrentOpacity)
            CurrentOpacity = Mathf.Max(num, CurrentOpacity - (2f * Time.deltaTime));

        var num2 = Vacuumable.isHeld() ? 1f : CurrentOpacity;

        if (Math.Abs(num2 - LastOpacity) > 0.001f)
            SetOpacity(num2);
    }
}

public sealed class StealthFixerController
{
    private static readonly int Alpha = ShaderUtils.GetOrSet("_Alpha");

    private static readonly Material CloakMaterial;
    private static readonly HashSet<Shader> CloakableShaders;

    private readonly List<Renderer> Renderers = [];
    private readonly HashSet<Material> CloakingMats = [];
    private readonly Dictionary<Renderer, (Material[], MaterialPropertyBlock[])> RendererOriginalMaterials = [];

    static StealthFixerController()
    {
        var slimeShaders = GameContext.Instance.SlimeShaders;
        CloakMaterial = slimeShaders.cloakMaterial;
        CloakableShaders = slimeShaders.cloakableShaders;
    }

    public StealthFixerController(GameObject gameObject) => UpdateMaterials(gameObject);

    public void UpdateMaterials(GameObject gameObject)
    {
        CloakingMats.Clear();
        Renderers.Clear();
        RendererOriginalMaterials.Clear();

        foreach (var renderer in gameObject.GetComponentsInChildren<Renderer>())
        {
            if (!renderer)
                continue;

            var blocks = new List<MaterialPropertyBlock>();

            foreach (var material in renderer.sharedMaterials)
            {
                if (!material || !CloakableShaders.Contains(material.shader))
                {
                    blocks.Add(null);
                    continue;
                }

                CloakingMats.Add(material);

                if (!material.HasProperty(Slimepedia.TopColor))
                {
                    blocks.Add(null);
                    continue;
                }

                var colorsPropertyBlock = new MaterialPropertyBlock();
                colorsPropertyBlock.SetColor(Slimepedia.TopColor, material.GetColor(Slimepedia.TopColor));
                colorsPropertyBlock.SetColor(Slimepedia.MiddleColor, material.GetColor(Slimepedia.MiddleColor));
                colorsPropertyBlock.SetColor(Slimepedia.BottomColor, material.GetColor(Slimepedia.BottomColor));
                blocks.Add(colorsPropertyBlock);
            }

            Renderers.Add(renderer);
            RendererOriginalMaterials[renderer] = ([.. renderer.sharedMaterials], [.. blocks]);
        }

        CloakingMats.Add(CloakMaterial);
    }

    public void SetOpacity(float opacity)
    {
        var isOpaque = opacity >= 0.99f;
        var anyNull = false;

        foreach (var renderer in Renderers)
        {
            if (!renderer)
            {
                anyNull = true;
                continue;
            }

            var sharedMaterials = renderer.sharedMaterials;
            var (originalNats, colorsPropertyBlocks) = RendererOriginalMaterials[renderer];

            for (var j = 0; j < sharedMaterials.Length; j++)
            {
                var material = sharedMaterials[j];

                if (!CloakingMats.Contains(material))
                    continue;

                if (!isOpaque && material != CloakMaterial)
                    sharedMaterials[j] = CloakMaterial.Clone();
                else if (isOpaque)
                    sharedMaterials[j] = originalNats[j];

                var materialPropertyBlock = new MaterialPropertyBlock();
                renderer.GetPropertyBlock(materialPropertyBlock, j);
                materialPropertyBlock.SetFloat(Alpha, isOpaque ? 1f : opacity);
                var colorsPropertyBlock = colorsPropertyBlocks[j];

                if (colorsPropertyBlock != null)
                {
                    materialPropertyBlock.SetColor(Slimepedia.TopColor, colorsPropertyBlock.GetColor(Slimepedia.TopColor));
                    materialPropertyBlock.SetColor(Slimepedia.MiddleColor, colorsPropertyBlock.GetColor(Slimepedia.MiddleColor));
                    materialPropertyBlock.SetColor(Slimepedia.BottomColor, colorsPropertyBlock.GetColor(Slimepedia.BottomColor));
                }

                renderer.SetPropertyBlock(materialPropertyBlock, j);
            }

            renderer.sharedMaterials = sharedMaterials;
        }

        if (anyNull)
            Renderers.RemoveAll(renderer => !renderer);
    }
}