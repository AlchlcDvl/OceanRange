namespace OceanRange.Slimes;

// Had to copy paste base game code because there's too many entry points to worry about otherwise
public sealed class StealthFixer : RegisteredActorBehaviour, RegistryUpdateable, SpawnListener
{
    public Vacuumable vacuumable;
    public SlimeAudio slimeAudio;
    public StealthFixerController stealthController;

    public float initStealthUntil;
    public float currentOpacity = 1f;
    public float targetOpacity = 1f;
    public float lastOpacity = 1f;

    public bool IsStealthed => currentOpacity < 1f;

    public void Awake()
    {
        stealthController = new StealthFixerController(gameObject);
        vacuumable = GetComponent<Vacuumable>();
        slimeAudio = GetComponent<SlimeAudio>();

        if (TryGetComponent<SlimeAppearanceApplicator>(out var slimeAppearanceApplicator) && slimeAppearanceApplicator.Appearance)
            UpdateMaterialStealthController();
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
        stealthController.SetOpacity(opacity);
        lastOpacity = opacity;
    }

    public void UpdateMaterialStealthController()
    {
        stealthController.UpdateMaterials(gameObject);
        lastOpacity = 1f;
    }

    public void UpdateStealthOpacity()
    {
        var num = Time.time < initStealthUntil ? 0f : targetOpacity;

        if (num > currentOpacity)
            currentOpacity = Mathf.Min(num, currentOpacity + (2f * Time.deltaTime));
        else if (targetOpacity < currentOpacity)
            currentOpacity = Mathf.Max(num, currentOpacity - (2f * Time.deltaTime));

        var num2 = vacuumable.isHeld() ? 1f : currentOpacity;

        if (Math.Abs(num2 - lastOpacity) > 0.001f)
            SetOpacity(num2);
    }
}

public sealed class StealthFixerController
{
    private static readonly int Alpha = ShaderUtils.GetOrSet("_Alpha");

    public readonly Material CloakMaterial;
    private readonly HashSet<Shader> CloakableShaders;
    public readonly HashSet<Material> CloakingMats = [];
    public readonly List<Renderer> Renderers = [];
    public readonly Dictionary<Renderer, (Material[], List<MaterialPropertyBlock>)> RendererOriginalMaterials = [];

    public StealthFixerController(GameObject gameObject)
    {
        var slimeShaders = SRSingleton<GameContext>.Instance.SlimeShaders;
        CloakMaterial = slimeShaders.cloakMaterial;
        CloakableShaders = slimeShaders.cloakableShaders;
        UpdateMaterials(gameObject);
    }

    public void UpdateMaterials(GameObject gameObject)
    {
        CloakingMats.Clear();
        Renderers.Clear();
        RendererOriginalMaterials.Clear();

        foreach (var renderer in gameObject.GetComponentsInChildren<Renderer>())
        {
            var blocks = new List<MaterialPropertyBlock>();

            foreach (var material in renderer.sharedMaterials)
            {
                if (!material || !CloakableShaders.Contains(material.shader))
                    continue;

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
            RendererOriginalMaterials[renderer] = ([.. renderer.sharedMaterials], blocks);
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
                    sharedMaterials[j] = CloakMaterial;
                else if (isOpaque && material == CloakMaterial)
                    sharedMaterials[j] = originalNats[j];

                var materialPropertyBlock = new MaterialPropertyBlock();
                var colorsPropertyBlock = colorsPropertyBlocks[j];
                renderer.GetPropertyBlock(materialPropertyBlock, j);
                materialPropertyBlock.SetFloat(Alpha, isOpaque ? 1f : opacity);
                materialPropertyBlock.SetColor(Slimepedia.TopColor, colorsPropertyBlock.GetColor(Slimepedia.TopColor));
                materialPropertyBlock.SetColor(Slimepedia.MiddleColor, colorsPropertyBlock.GetColor(Slimepedia.MiddleColor));
                materialPropertyBlock.SetColor(Slimepedia.BottomColor, colorsPropertyBlock.GetColor(Slimepedia.BottomColor));
                renderer.SetPropertyBlock(materialPropertyBlock, j);
            }

            renderer.sharedMaterials = sharedMaterials;
        }

        if (anyNull)
            Renderers.RemoveAll(renderer => !renderer);
    }
}

public sealed class DeactivateWhileStealthedOR : MonoBehaviour
{
    public ParticleSystem particleSys;
    public StealthFixer stealth;

    public void Start()
    {
        particleSys = GetComponent<ParticleSystem>();
        stealth = GetComponentInParent<StealthFixer>();
    }

    public void Update()
    {
        if (stealth != null)
#pragma warning disable CS0618 // Type or member is obsolete
            particleSys.enableEmission = !stealth.IsStealthed;
#pragma warning restore CS0618 // Type or member is obsolete
    }
}