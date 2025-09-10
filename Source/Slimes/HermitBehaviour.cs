using System.Collections;
using SRML.SR.SaveSystem;
using SRML.SR.SaveSystem.Data;

namespace OceanRange.Slimes;

public sealed class HermitBehaviour : SlimeSubbehaviour, ExtendedData.Participant
{
    private CalmedByWaterSpray Calmed;
    private SlimeAppearanceApplicator Applicator;
    private bool Hiding;
    private GameObject Shell;
    private Transform Appearance;

    public CanMoveHandler CanMove;
    public float Affection;

    private static readonly Vector3 HiddenSize = Vector3.one * 0.1f;

    private const float MaxShyRange = 3f;
    private const float MinShyRange = 1f;

    public override void Awake()
    {
        base.Awake();
        Calmed = GetComponent<CalmedByWaterSpray>();
        Applicator = GetComponent<SlimeAppearanceApplicator>();
        CanMove = this.EnsureComponent<CanMoveHandler>();
        Shell = gameObject.FindChild("Shell") ?? gameObject.FindChild("Shell(Clone)");
        Appearance = transform.Find("Appearance");
        Shell.SetActive(false);
    }

    public void ReadData(CompoundDataPiece piece) => Affection = piece.GetValue<float>("affection");

    public void WriteData(CompoundDataPiece piece) => piece.SetValue("affection", Affection);

    public override float Relevancy(bool _)
    {
        if (Calmed.IsCalmed() || Affection > 1f || Hiding || !CanMove.CanMove)
            return 0f;

        var range = Mathf.Lerp(MaxShyRange, MinShyRange, Affection);
        range *= range;
        var diff = SceneContext.Instance.Player.transform.position - transform.position;
        return diff.sqrMagnitude <= range ? 1f : 0f;
    }

    public override void Action() { }

    public override void Selected() => StartCoroutine(CoHideInShell());

    private IEnumerator CoHideInShell()
    {
        Hiding = true;
        CanMove.CanMove = false;
        Applicator.SetExpression(SlimeExpression.Alarm);

        Shell.SetActive(true);
        yield return Helpers.PerformTimedAction(2f, t => Appearance.localScale = Vector3.Lerp(Vector3.one, HiddenSize, t));

        var player = SceneContext.Instance.Player.transform;

        var range = Mathf.Lerp(MaxShyRange, MinShyRange, Affection);
        range *= range;

        yield return Helpers.WaitWhile(() => (player.position - transform.position).sqrMagnitude <= range);

        yield return Helpers.PerformTimedAction(1f, t => Appearance.localScale = Vector3.Lerp(HiddenSize, Vector3.one, t));
        Shell.SetActive(false);

        Hiding = false;
        CanMove.CanMove = true;
    }
}