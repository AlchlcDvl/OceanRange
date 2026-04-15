// ReSharper disable InconsistentNaming

using System.Collections;
using SRML.SR.SaveSystem;
using SRML.SR.SaveSystem.Data;

namespace OceanRange.Slimes;

public sealed class HermitBehaviour : SlimeSubbehaviour, ExtendedData.Participant
{
    private CalmedByWaterSpray calmed;
    private SlimeAppearanceApplicator applicator;
    private bool hiding;

    public CanMoveHandler CanMove;
    public float Affection;

    private const float MaxShyRange = 15f;
    private const float MinShyRange = 1f;

    public override void Awake()
    {
        base.Awake();
        calmed = GetComponent<CalmedByWaterSpray>();
        applicator = GetComponent<SlimeAppearanceApplicator>();
        CanMove = this.EnsureComponent<CanMoveHandler>();
    }

    public void ReadData(CompoundDataPiece piece) => Affection = piece.GetValue<float>("affection");

    public void WriteData(CompoundDataPiece piece) => piece.SetValue("affection", Affection);

    public override float Relevancy(bool _)
    {
        if (calmed.IsCalmed() || Affection >= 1f || hiding || !CanMove.CanMove)
            return 0f;

        var range = Mathf.Lerp(MaxShyRange, MinShyRange, Affection);
        range *= range;
        var diff = SceneContext.Instance.Player.transform.position - transform.position;
        return diff.sqrMagnitude <= range ? 1f : 0f;
    }

    public override void Action() { }

    public override void Selected()
    {
        if (!hiding)
            StartCoroutine(CoHideInShell());
    }

    private IEnumerator CoHideInShell()
    {
        hiding = true;
        CanMove.CanMove = false;

        var player = SceneContext.Instance.Player.transform;
        var range = Mathf.Lerp(MaxShyRange, MinShyRange, Affection);

        while ((player.position - transform.position).sqrMagnitude <= range)
        {
            applicator.SetExpression(SlimeExpression.Alarm);
            yield return null;
        }

        hiding = false;
        CanMove.CanMove = true;
    }
}