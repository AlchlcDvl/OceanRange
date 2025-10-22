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

    private readonly StealthFixerController StealthController = new();

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
    private readonly Dictionary<Renderer, Material[]> RendererCloakMaterials = [];
    private readonly Dictionary<Renderer, Material[]> RendererOriginalMaterials = [];

    static StealthFixerController()
    {
        var slimeShaders = GameContext.Instance.SlimeShaders;
        CloakMaterial = slimeShaders.cloakMaterial;
        CloakableShaders = slimeShaders.cloakableShaders;
    }

    public void UpdateMaterials(GameObject gameObject)
    {
        RendererCloakMaterials.Values.Do(x => x.Do(y => y.Destroy()));

        Renderers.Clear();
        RendererCloakMaterials.Clear();
        RendererOriginalMaterials.Clear();

        foreach (var renderer in gameObject.GetComponentsInChildren<Renderer>())
        {
            if (!renderer)
                continue;

            var cloaks = new List<Material>();

            foreach (var material in renderer.sharedMaterials)
            {
                if (!material)
                {
                    cloaks.Add(null);
                    continue;
                }

                if (!CloakableShaders.Contains(material.shader))
                {
                    cloaks.Add(material);
                    continue;
                }

                var cloak = CloakMaterial.Clone();
                cloaks.Add(cloak);

                if (!material.HasProperty(Slimepedia.TopColor))
                    continue;

                cloak.SetColor(Slimepedia.TopColor, material.GetColor(Slimepedia.TopColor));
                cloak.SetColor(Slimepedia.MiddleColor, material.GetColor(Slimepedia.MiddleColor));
                cloak.SetColor(Slimepedia.BottomColor, material.GetColor(Slimepedia.BottomColor));
            }

            Renderers.Add(renderer);
            RendererCloakMaterials[renderer] = [.. cloaks];
            RendererOriginalMaterials[renderer] = [.. renderer.sharedMaterials];
        }
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

            var materials = (isOpaque ? RendererOriginalMaterials : RendererCloakMaterials)[renderer];

            foreach (var material in materials)
            {
                if (material && material.HasProperty(Alpha))
                    material.SetFloat(Alpha, isOpaque ? 1f : opacity);
            }

            renderer.sharedMaterials = materials;
        }

        if (anyNull)
            Renderers.RemoveAll(renderer => !renderer);
    }
}