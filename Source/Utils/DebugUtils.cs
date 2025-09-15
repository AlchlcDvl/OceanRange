#if DEBUG
using UnityEngine.SceneManagement;

namespace OceanRange.Utils;

public static class DebugUtils
{
    public static void DoLog(this object message) => Main.Console.Log(message ?? "message was null");

    public static void LogIf(this object message, bool condition)
    {
        if (condition)
            message.DoLog();
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
}
#endif