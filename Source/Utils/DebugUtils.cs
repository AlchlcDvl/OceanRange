#if DEBUG
using System.Globalization;
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

    private static readonly CultureInfo InvariantCulture = CultureInfo.InvariantCulture;

    public static Vector3 ParseVector(string value)
    {
        var parts = value.TrueSplit(',');

        if (parts.Count is not (2 or 3))
            throw new FormatException("Incorrect vector format! Expected x,y or x,y,z");

        return new
        (
            float.Parse(parts[0], NumberStyles.Float | NumberStyles.AllowThousands, InvariantCulture),
            float.Parse(parts[1], NumberStyles.Float | NumberStyles.AllowThousands, InvariantCulture),
            parts.Count == 3 ? float.Parse(parts[2], NumberStyles.Float | NumberStyles.AllowThousands, InvariantCulture) : 0f
        );
    }
}
#endif