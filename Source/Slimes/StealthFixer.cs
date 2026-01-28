namespace OceanRange.Slimes;

// Had to copy and paste base game code because there's too many entry points to worry about otherwise
public sealed class StealthFixer : RegisteredActorBehaviour, RegistryUpdateable, SpawnListener
{
    private Vacuumable vacuumable;
    private SlimeAudio slimeAudio;
    private float initStealthUntil;
    private float currentOpacity = 1f;
    private float targetOpacity = 1f;
    private float lastOpacity = 1f;

    private readonly StealthFixerController StealthController = new();

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
        StealthController.DestroyMats();
    }

    public void RegistryUpdate() => UpdateStealthOpacity();

    public void DidSpawn()
    {
        currentOpacity = 0f;
        initStealthUntil = Time.time + 5f;
    }

    public void SetStealth(bool stealth)
    {
        targetOpacity = stealth ? 0f : 1f;
        slimeAudio.Play(stealth ? slimeAudio.slimeSounds.cloakCue : slimeAudio.slimeSounds.decloakCue);
    }

    public void SetOpacity(float opacity)
    {
        StealthController.SetOpacity(opacity);
        lastOpacity = opacity;
    }

    private void UpdateMaterialStealthController(SlimeAppearance appearance)
    {
        if (appearance)
            UpdateMaterialStealthController();
    }

    public void UpdateMaterialStealthController()
    {
        StealthController.UpdateMaterials(gameObject);
        lastOpacity = 1f;
    }

    public void UpdateStealthOpacity()
    {
        if (vacuumable == null)
            return;

        var target = (Time.time < initStealthUntil) ? 0f : targetOpacity;

        if (vacuumable.isHeld())
            target = 1f;

        if (!Mathf.Approximately(currentOpacity, target))
            currentOpacity = Mathf.MoveTowards(currentOpacity, target, 2f * Time.deltaTime);

        if (Mathf.Abs(currentOpacity - lastOpacity) > 0.001f)
            SetOpacity(currentOpacity);
    }
}

public sealed class StealthFixerController
{
    private struct RendererEntry
    {
        public Renderer Renderer;
        public Material Original;
        public Material Cloak;
    }

    private static readonly int Alpha = ShaderUtils.GetOrSet("_Alpha");
    private static readonly Material CloakMaterial = GameContext.Instance.SlimeShaders.cloakMaterial;

    private readonly List<RendererEntry> Entries = [];

    public void DestroyMats()
    {
        foreach (var entry in Entries)
        {
            if (entry.Cloak)
                entry.Cloak.Destroy();
        }

        Entries.Clear();
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

            Entries.Add(new RendererEntry
            {
                Renderer = renderer,
                Original = regularMat,
                Cloak = cloakMat
            });
        }
    }

    public void SetOpacity(float opacity)
    {
        var isOpaque = opacity >= 0.99f;

        for (var i = Entries.Count - 1; i >= 0; i--)
        {
            var entry = Entries[i];

            if (!entry.Renderer)
            {
                if (entry.Cloak)
                    entry.Cloak.Destroy();

                Entries.RemoveAt(i);
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