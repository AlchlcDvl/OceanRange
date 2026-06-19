// ReSharper disable InconsistentNaming

using System.Collections;
using SRML.SR.SaveSystem;
using SRML.SR.SaveSystem.Data;

namespace OceanRange.Slimes;

public sealed class HermitBehaviour : SlimeSubbehaviour, ExtendedData.Participant
{
    private CalmedByWaterSpray calmed;
    private SlimeAppearanceApplicator applicator;
    private SlimeFaceAnimator faceAnimator;

    public bool IsHiding { get; private set; }

    public CanMoveHandler CanMove;
    public float Affection;

    private const float MaxShyRange = 15f;
    private const float MinShyRange = 1f;

    public override void Awake()
    {
        base.Awake();
        calmed = GetComponent<CalmedByWaterSpray>();
        applicator = GetComponent<SlimeAppearanceApplicator>();
        faceAnimator = GetComponent<SlimeFaceAnimator>();
        CanMove = this.EnsureComponent<CanMoveHandler>();
    }

    public void ReadData(CompoundDataPiece piece) => Affection = piece.GetValue<float>("affection");

    public void WriteData(CompoundDataPiece piece) => piece.SetValue("affection", Affection);

    public override float Relevancy(bool _)
    {
        if (Affection >= 1f || IsHiding || !CanMove.CanMove || calmed.IsCalmed())
            return 0f;

        var range = Mathf.Lerp(MaxShyRange, MinShyRange, Affection);
        range *= range;
        var diff = SceneContext.Instance.Player.transform.position - transform.position;
        return diff.sqrMagnitude <= range ? 1f : 0f;
    }

    public override void Action() { }

    public override void Selected()
    {
        if (!IsHiding)
            StartCoroutine(CoHideInShell());
    }

    private IEnumerator CoHideInShell()
    {
        IsHiding = true;
        CanMove.CanMove = false;

        applicator.SetExpression(SlimeExpression.Alarm);

        var player = SceneContext.Instance.Player.transform;
        var range = Mathf.Lerp(MaxShyRange, MinShyRange, Affection);

        while ((player.position - transform.position).sqrMagnitude <= range)
            yield return null;

        IsHiding = false;
        CanMove.CanMove = true;

        faceAnimator.SetTrigger("triggerMinorWince");
    }
}