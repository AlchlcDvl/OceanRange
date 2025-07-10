using System.Collections;
using DG.Tweening;

namespace TheOceanRange.Slimes;

public sealed class SandBehaviour : SRBehaviour
{
    public static GameObject PlortPrefab;
    public static GameObject ProduceFX;

    private static readonly Vector3 LOCAL_PRODUCE_LOC = new(0f, 0.5f, 0f);
    private static readonly Vector3 LOCAL_PRODUCE_VEL = new(0f, 1f, 0f);
    private const float EatRate = 3f;

    private SlimeEmotions Emotions;
    private SlimeEat SlimeEat;
    private RegionMember RegionMember;
    private float NextChompTime;
    private SlimeAudio slimeAudio;
    private bool Eating;

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
        if (!Eating && Time.time >= NextChompTime && Emotions.GetCurr(SlimeEmotions.Emotion.HUNGER) > SlimeEat.minDriveToEat)
            StartCoroutine(ProduceAfterDelay(1, 2f));
    }

    private void ResetEatClock() => NextChompTime = Time.time + EatRate;

    private IEnumerator ProduceAfterDelay(int count, float delay)
    {
        Eating = true;

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
        ResetEatClock();
        Emotions.Adjust(0, 0f - SlimeEat.drivePerEat);
        Eating = false;
    }
}