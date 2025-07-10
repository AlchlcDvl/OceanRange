using System.Collections;
using DG.Tweening;

namespace TheOceanRange.Slimes;

public sealed class SandBehaviour : SRBehaviour
{
    public static GameObject PlortPrefab;

    private static readonly Vector3 LOCAL_PRODUCE_LOC = new(0f, 0.5f, 0f);
    private static readonly Vector3 LOCAL_PRODUCE_VEL = new(0f, 1f, 0f);
    private const float EatRate = 3f;

    public GameObject ProduceFX;

    private SlimeEmotions Emotions;
    private SlimeEat SlimeEat;
    private RegionMember RegionMember;
    private float NextChompTime;
    private SlimeAudio slimeAudio;

    public void Awake()
    {
        Emotions = GetComponent<SlimeEmotions>();
        SlimeEat = GetComponent<SlimeEat>();
        slimeAudio = GetComponent<SlimeAudio>();
        RegionMember = GetComponent<RegionMember>();
        ResetEatClock();
    }

    public void Update()
    {
        if (Time.time >= NextChompTime && Emotions.GetCurr(SlimeEmotions.Emotion.HUNGER) > SlimeEat.minDriveToEat)
        {
            StartCoroutine(ProduceAfterDelay(1, 2f));
            OnEat(SlimeEmotions.Emotion.HUNGER, IdentifiableId.NONE);
        }
    }

    private void ResetEatClock() => NextChompTime = Time.time + EatRate;

    private void OnEat(SlimeEmotions.Emotion driver, IdentifiableId otherId)
    {
        ResetEatClock();
        Emotions.Adjust(driver, 0f - SlimeEat.drivePerEat);

        if (otherId != IdentifiableId.PLAYER)
            Emotions.Adjust(SlimeEmotions.Emotion.AGITATION, 0f - SlimeEat.agitationPerEat);
    }

    private IEnumerator ProduceAfterDelay(int count, float delay)
    {
        yield return new WaitForSeconds(delay);

        if (!gameObject)
            yield break;

        for (var i = 0; i < count; i++)
        {
            var position = transform.TransformPoint(LOCAL_PRODUCE_LOC);
            var velocity = transform.TransformVector(LOCAL_PRODUCE_VEL);

            if (ProduceFX != null)
                SpawnAndPlayFX(ProduceFX, position, transform.rotation);

            var gameObject = InstantiateActor(PlortPrefab, RegionMember.setId, position, transform.rotation);

            if (gameObject.TryGetComponent<Rigidbody>(out var component))
                component.velocity = velocity;

            if (gameObject.TryGetComponent<PlortInvulnerability>(out var component2))
                component2.GoInvulnerable();

            gameObject.transform.DOScale(gameObject.transform.localScale, 0.5f).From(0.001f);
        }

        slimeAudio.Play(slimeAudio.slimeSounds.plortCue);
    }
}