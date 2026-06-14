namespace OceanRange.Slimes;

public sealed class FlashbangEffect : MonoBehaviour
{
    private CanvasGroup canvasGroup;

    private float fadeSpeed = 0.5f;
    private float flashDuration = 2f;

    private float timer;

    public void Awake()
    {
        canvasGroup = GetComponent<CanvasGroup>();
        canvasGroup.alpha = 1f;
    }

    public void Update()
    {
        if (!canvasGroup)
            return;

        var delta = Time.deltaTime;
        timer += delta;

        if (timer < flashDuration)
            return;

        canvasGroup.alpha -= fadeSpeed * Time.deltaTime;

        if (canvasGroup.alpha <= 0f)
            Destroy(gameObject);
    }

    public void SetFlashDuration(float duration) => flashDuration = duration;

    public void SetFadeDuration(float duration) => fadeSpeed = 1 / duration;
}