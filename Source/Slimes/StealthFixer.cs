namespace OceanRange.Slimes;

// Had to copy and paste base game code because there's too many entry points to worry about otherwise
// And also because the original system was designed for one consistent material, rather than multiple unique ones
// This attempts to (and it works) add support for multiple materials
public sealed class StealthFixer : RegisteredActorBehaviour, RegistryUpdateable, SpawnListener
{
    public float CurrentOpacity = 1f;

    private Vacuumable vacuumable;
    private SlimeAudio slimeAudio;
    private float initStealthUntil;
    private float targetOpacity = 1f;
    private float lastOpacity = 1f;

    private readonly StealthFixerController stealthController = new();

    public void Awake()
    {
        vacuumable = GetComponent<Vacuumable>();
        slimeAudio = GetComponent<SlimeAudio>();

        if (!TryGetComponent<SlimeAppearanceApplicator>(out var applicator))
            return;

        UpdateMaterialStealthController(applicator.Appearance);
        applicator.OnAppearanceChanged += UpdateMaterialStealthController;
    }

    public override void OnDestroy()
    {
        base.OnDestroy();
        stealthController.DestroyMats();
    }

    public void RegistryUpdate() => UpdateStealthOpacity();

    public void DidSpawn()
    {
        CurrentOpacity = 0f;
        initStealthUntil = Time.time + 5f;
    }

    public void SetStealth(bool stealth)
    {
        targetOpacity = stealth ? 0f : 1f;
        slimeAudio.Play(stealth ? slimeAudio.slimeSounds.cloakCue : slimeAudio.slimeSounds.decloakCue);
    }

    public void SetOpacity(float opacity)
    {
        stealthController.SetOpacity(opacity);
        lastOpacity = opacity;
    }

    private void UpdateMaterialStealthController(SlimeAppearance appearance)
    {
        if (appearance)
            UpdateMaterialStealthController();
    }

    public void UpdateMaterialStealthController()
    {
        stealthController.UpdateMaterials(gameObject);
        lastOpacity = 1f;
    }

    public void UpdateStealthOpacity()
    {
        if (vacuumable == null)
            return;

        var target = vacuumable.isHeld()
            ? 1f
            : (Time.time < initStealthUntil
                ? 0f
                : targetOpacity);

        if (!Mathf.Approximately(CurrentOpacity, target))
            CurrentOpacity = Mathf.MoveTowards(CurrentOpacity, target, 2f * Time.deltaTime);

        if (Mathf.Abs(CurrentOpacity - lastOpacity) > 0.001f)
            SetOpacity(CurrentOpacity);
    }
}

public sealed class StealthFixerController
{
    private readonly struct RendererEntry(Renderer renderer, Material original, Material cloak)
    {
        public readonly Renderer Renderer = renderer;
        public readonly Material Original = original;
        public readonly Material Cloak = cloak;
    }

    private static readonly int Alpha = ShaderUtils.GetOrSet("_Alpha");
    private static readonly Material CloakMaterial = GameContext.Instance.SlimeShaders.cloakMaterial;

    private readonly List<RendererEntry> entries = [];

    public void DestroyMats()
    {
        foreach (var entry in entries)
        {
            if (entry.Cloak)
                entry.Cloak.Destroy();
        }

        entries.Clear();
    }

    public void UpdateMaterials(GameObject gameObject)
    {
        DestroyMats();

        foreach (var renderer in gameObject.GetComponentsInChildren<Renderer>())
        {
            if (!renderer)
                continue;

            var cloakMat = CloakMaterial.Clone();
            var regularMat = renderer.sharedMaterial;

            if (regularMat.HasProperty(Slimepedia.TopColor))
            {
                cloakMat.SetColor(Slimepedia.TopColor, regularMat.GetColor(Slimepedia.TopColor));
                cloakMat.SetColor(Slimepedia.MiddleColor, regularMat.GetColor(Slimepedia.MiddleColor));
                cloakMat.SetColor(Slimepedia.BottomColor, regularMat.GetColor(Slimepedia.BottomColor));
            }

            entries.Add(new RendererEntry(renderer, regularMat, cloakMat));
        }
    }

    public void SetOpacity(float opacity)
    {
        var isOpaque = opacity >= 0.99f;

        for (var i = entries.Count - 1; i >= 0; i--)
        {
            var entry = entries[i];

            if (!entry.Renderer)
            {
                if (entry.Cloak)
                    entry.Cloak.Destroy();

                entries.RemoveAt(i);
                continue;
            }

            if (isOpaque)
                entry.Renderer.sharedMaterial = entry.Original;
            else
            {
                entry.Cloak.SetFloat(Alpha, opacity);
                entry.Renderer.sharedMaterial = entry.Cloak;
            }
        }
    }
}