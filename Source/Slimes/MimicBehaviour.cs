using System.Collections;

namespace OceanRange.Slimes;

public sealed class MimicBehaviour : SRBehaviour, LiquidConsumer
{
    private SlimeAppearanceApplicator applicator;
    private StealthFixer fixer;

    private bool transformed;
    private bool transforming;

    private float minNormalTime = 15f;
    private float maxNormalTime = 30f;
    private float minDisguiseTime = 5f;
    private float maxDisguiseTime = 10f;

    private float scanRadius = 20f;

    private float nextStateChangeTime;

    private SlimeAppearance originalAppearance;

    private static readonly Dictionary<IdentifiableId, SlimeAppearance> CachedAppearances = new(Identifiable.idComparer);

    public static void Initialise()
    {
        var baseMimicTail = Ids.MIMIC_SLIME.GetSlimeDefinition().AppearancesDefault[0].Structures[1];

        foreach (var slimeId in Identifiable.SLIME_CLASS)
        {
            if (slimeId == Ids.MIMIC_SLIME || slimeId == IdentifiableId.TARR_SLIME)
                continue;

            var targetAppearance = slimeId.GetSlimeDefinition().AppearancesDefault[0];

            var clonedAppearance = targetAppearance.Instantiate();
            clonedAppearance.name = "Mimic_" + slimeId.ToString() + "_Appearance";

            var clonedTail = new SlimeAppearanceStructure(baseMimicTail);

            var tailMat = baseMimicTail.DefaultMaterials[0].Clone();
            tailMat.SetColor(Slimepedia.TopColor, targetAppearance.ColorPalette.Top);
            tailMat.SetColor(Slimepedia.MiddleColor, targetAppearance.ColorPalette.Middle);
            tailMat.SetColor(Slimepedia.BottomColor, targetAppearance.ColorPalette.Bottom);

            clonedTail.DefaultMaterials[0] = tailMat;

            var oldStructures = clonedAppearance.Structures;
            var newStructures = new SlimeAppearanceStructure[oldStructures.Length + 1];
            oldStructures.CopyTo(newStructures, 0);
            newStructures[oldStructures.Length] = clonedTail;

            clonedAppearance.Structures = newStructures;

            CachedAppearances[slimeId] = clonedAppearance;
        }
    }

    public void Awake()
    {
        applicator = GetComponent<SlimeAppearanceApplicator>();
        fixer = this.EnsureComponent<StealthFixer>();

        GetComponent<SlimeHealth>().onDamage = _ => Revert();
    }

    public void Start()
    {
        originalAppearance = applicator.Appearance;
        SetNextStateTime();
    }

    public void Update()
    {
        if (transforming || Time.time < nextStateChangeTime)
            return;

        if (transformed)
            Revert();
        else
            Transform();
    }

    private void SetNextStateTime()
    {
        var waitDuration = transformed
            ? UnityEngine.Random.Range(minDisguiseTime, maxDisguiseTime)
            : UnityEngine.Random.Range(minNormalTime, maxNormalTime);

        nextStateChangeTime = Time.time + waitDuration;
    }

    public void AddLiquid(IdentifiableId liquidId, float units)
    {
        if (liquidId is IdentifiableId.WATER_LIQUID or IdentifiableId.MAGIC_WATER_LIQUID && transformed)
            Revert();
    }

    public void Transform()
    {
        var targetId = IdentifiableId.NONE;
        var closestDistanceSqr = float.MaxValue;
        var myPosition = transform.position;

        foreach (var col in Physics.OverlapSphere(myPosition, scanRadius))
        {
            var identifiable = col.GetComponentInParent<Identifiable>() ?? col.GetComponentInChildren<Identifiable>();

            if (identifiable == null)
                continue;

            var id = identifiable.id;

            if (!Identifiable.IsSlime(id) || id == Ids.MIMIC_SLIME || id == IdentifiableId.TARR_SLIME || !CachedAppearances.ContainsKey(id))
                continue;

            var distanceSqr = (col.transform.position - myPosition).sqrMagnitude;

            if (distanceSqr >= closestDistanceSqr)
                continue;

            closestDistanceSqr = distanceSqr;
            targetId = id;
        }

        if (targetId != IdentifiableId.NONE)
            StartCoroutine(CoTransform(true, targetId));
        else
            SetNextStateTime();
    }

    public void Revert() => StartCoroutine(CoTransform(false, IdentifiableId.NONE));

    private IEnumerator CoTransform(bool transformResult, IdentifiableId targetId)
    {
        if (transformResult == transformed || transforming)
            yield break;

        transformed = !transformResult;
        transforming = true;

        fixer.SetStealth(true);
        yield return new WaitUntil(() => fixer.CurrentOpacity <= 0f);

        applicator.Appearance = (targetId == IdentifiableId.NONE) ? originalAppearance : CachedAppearances[targetId];
        applicator.ApplyAppearance();

        fixer.SetStealth(false);
        yield return new WaitUntil(() => fixer.CurrentOpacity >= 1f);

        transforming = false;
        transformed = transformResult;

        SetNextStateTime();
    }
}