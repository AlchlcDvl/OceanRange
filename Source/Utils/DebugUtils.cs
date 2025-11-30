#if DEBUG
using UnityEngine.SceneManagement;

namespace OceanRange.Utils;

public static class DebugUtils
{
    public static void DoLog(this object message) => Main.Console.Log(message?.ToString() ?? "message was null");

    public static void DoLogWarn(this object message) => Main.Console.LogWarning(message?.ToString() ?? "message was null");

    public static void DoLogError(this object message) => Main.Console.LogError(message?.ToString() ?? "message was null");

    public static void LogIf(this object message, bool condition)
    {
        if (condition)
            message.DoLog();
    }

    public static void LogWarningIf(this object message, bool condition)
    {
        if (condition)
            message.DoLogWarn();
    }

    public static void LogErrorIf(this object message, bool condition)
    {
        if (condition)
            message.DoLogError();
    }

    public static GameObject GetClosestCell(Vector3 pos)
    {
        GameObject closest = null;
        var distance = float.MaxValue;

        foreach (var cell in SceneManager.GetActiveScene()
            .GetRootGameObjects()
            .Where(x => x.name.StartsWith("zone", StringComparison.Ordinal))
            .SelectMany(x => x.FindChildrenWithPartialName("cell", true)))
        {
            var diff = (cell.transform.position - pos).sqrMagnitude;

            if (diff >= distance)
                continue;

            closest = cell;
            distance = diff;
        }

        return closest;
    }

    public static string FormatOrientation(Orientation orientation) => $"f {orientation.Position.ToVectorString()},0,0,0";
}
#endif