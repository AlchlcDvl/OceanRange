using System.Collections;
using SRML.SR.SaveSystem;
using SRML.SR.SaveSystem.Data;

namespace OceanRange.Slimes;

public sealed class HermitBehaviour : SlimeSubbehaviour, ExtendedData.Participant
{
    private Transform Body;
    private Transform Claw1;
    private Transform Claw2;
    private CalmedByWaterSpray Calmed;
    private bool Hiding;

    public CanMoveHandler CanMove;
    public float Affection;

    private static readonly Vector3 HiddenSize = Vector3.one * 0.1f;

    private const float MaxShyRange = 3f;
    private const float MinShyRange = 1f;

    public override void Awake()
    {
        base.Awake();
        Body = transform.Find("Appearance/slime_default(Clone)");
        Claw1 = transform.Find("Appearance/hermit_claw_1(Clone)");
        Claw2 = transform.Find("Appearance/hermit_claw_2(Clone)");
        Calmed = GetComponent<CalmedByWaterSpray>();
        CanMove = this.EnsureComponent<CanMoveHandler>();
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

        yield return Helpers.PerformTimedAction(2f, t =>
        {
            var scale = Vector3.Lerp(Vector3.one, HiddenSize, t);
            Body.localScale = scale;
            Claw1.localScale = scale;
            Claw2.localScale = scale;
        });

        var player = SceneContext.Instance.Player.transform;

        var range = Mathf.Lerp(MaxShyRange, MinShyRange, Affection);
        range *= range;

        yield return Helpers.WaitWhile(() => (player.position - transform.position).sqrMagnitude <= range);

        yield return Helpers.PerformTimedAction(1f, t =>
        {
            var scale = Vector3.Lerp(Vector3.one, HiddenSize, 1f - t);
            Body.localScale = scale;
            Claw1.localScale = scale;
            Claw2.localScale = scale;
        });

        Hiding = false;
        CanMove.CanMove = true;
    }
}