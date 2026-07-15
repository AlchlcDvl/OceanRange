namespace OceanRange.Slimes;

public sealed class FlashbangEffect : MonoBehaviour
{
    public CanvasGroup canvasGroup;

    public float fadeSpeed = 0.5f;
    public float flashDuration = 2f;

    private float _timer;

    public void Update()
    {
        if (!canvasGroup)
            return;

        var delta = Time.deltaTime;
        _timer += delta;

        if (_timer < flashDuration)
            return;

        canvasGroup.alpha -= fadeSpeed * Time.deltaTime;

        if (canvasGroup.alpha <= 0f)
            Destroy(gameObject);
    }

    public void SetFlashDuration(float duration) => flashDuration = duration;

    public void SetFadeDuration(float duration) => fadeSpeed = 1 / duration;
}