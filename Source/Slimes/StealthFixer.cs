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

    private readonly Material CloakMaterial = GameContext.Instance.SlimeShaders.cloakMaterial;

    private readonly List<Renderer> Renderers = [];
    private readonly Dictionary<Renderer, Material[]> RendererCloakMaterials = [];
    private readonly Dictionary<Renderer, Material[]> RendererOriginalMaterials = [];

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

            Renderers.Add(renderer);
            RendererCloakMaterials[renderer] = [CloakMaterial.Clone()];
            RendererOriginalMaterials[renderer] = [.. renderer.sharedMaterials];
        }
    }

    public void SetOpacity(float opacity)
    {
        var isOpaque = opacity >= 0.99f;
        var anyNull = false;

        if (isOpaque)
        {
            foreach (var renderer in Renderers)
            {
                if (!renderer)
                {
                    anyNull = true;
                    continue;
                }

                renderer.sharedMaterials = RendererOriginalMaterials[renderer];
            }
        }
        else
        {
            var alpha = isOpaque ? 1f : opacity;

            foreach (var renderer in Renderers)
            {
                if (!renderer)
                {
                    anyNull = true;
                    continue;
                }

                var materials = RendererCloakMaterials[renderer];
                renderer.sharedMaterials = RendererCloakMaterials[renderer];
                materials[0].SetFloat(Alpha, alpha);
            }
        }

        if (anyNull)
            Renderers.RemoveAll(renderer => !renderer);
    }
}