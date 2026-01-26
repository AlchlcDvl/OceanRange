using System.Collections;
using DG.Tweening;

namespace OceanRange.Slimes;

public sealed class SandBehaviour : SRBehaviour
{
    public static GameObject PlortPrefab;
    public static GameObject ProduceFX;

    private static readonly Vector3 LocalProduceLoc = new(0f, 0.5f, 0f);
    private static readonly Vector3 LocalProduceVel = new(0f, 1f, 0f);
    private const float EatRate = 10f;

    private SlimeEmotions emotions;
    private SlimeEat slimeEat;
    private RegionMember regionMember;
    private float nextChompTime;
    private SlimeAudio slimeAudio;
    private bool eating;

    public void Awake()
    {
        emotions = GetComponent<SlimeEmotions>();
        slimeEat = GetComponent<SlimeEat>();
        slimeAudio = GetComponent<SlimeAudio>();
        regionMember = GetComponent<RegionMember>();
        ResetEatClock();
    }

    public void Update()
    {
        if (!eating && Time.time >= nextChompTime && emotions.GetCurr(SlimeEmotions.Emotion.HUNGER) > slimeEat.minDriveToEat)
            StartCoroutine(ProduceAfterDelay(1, 2f));
    }

    private void ResetEatClock() => nextChompTime = Time.time + EatRate;

    private IEnumerator ProduceAfterDelay(int count, float delay)
    {
        eating = true;

        yield return new WaitForSeconds(delay);

        if (!gameObject)
            yield break;

        for (var i = 0; i < count; i++)
        {
            var position = transform.TransformPoint(LocalProduceLoc);
            var velocity = transform.TransformVector(LocalProduceVel);

            if (ProduceFX)
                SpawnAndPlayFX(ProduceFX, position, transform.rotation);

            var go = InstantiateActor(PlortPrefab, regionMember.setId, position, transform.rotation);

            if (go.TryGetComponent<Rigidbody>(out var component))
                component.velocity = velocity;

            if (go.TryGetComponent<PlortInvulnerability>(out var component2))
                component2.GoInvulnerable();

            go.transform.DOScale(go.transform.localScale, 0.5f).From(0.001f);
        }

        slimeAudio.Play(slimeAudio.slimeSounds.plortCue);
        ResetEatClock();
        emotions.Adjust(0, 0f - slimeEat.drivePerEat);
        eating = false;
    }
}