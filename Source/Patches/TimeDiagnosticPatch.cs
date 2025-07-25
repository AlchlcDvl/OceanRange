#if DEBUG
using System.Diagnostics;
using System.Reflection;

namespace OceanRange.Patches;

[HarmonyPatch]
public static class TimeDiagnosticPatch
{
    private static readonly Dictionary<MethodBase, (string Stage, Stopwatch Watch)> Watches = [];

    public static IEnumerable<MethodBase> TargetMethods()
    {
        foreach (var type in AccessTools.GetTypesFromAssembly(AssetManager.Core))
        {
            foreach (var method in AccessTools.GetDeclaredMethods(type))
            {
                var timeDiagnostic = method.GetCustomAttribute<TimeDiagnosticAttribute>();

                if (timeDiagnostic == null)
                    continue;

                Watches[method] = (timeDiagnostic.Stage, new());
                yield return method;
            }
        }
    }

    public static void Prefix(MethodBase __originalMethod, object[] __args, ref string __state)
    {
        var (stage, watch) = Watches[__originalMethod];
        watch.Start();

        if (stage == null)
        {
            var name = __originalMethod.Name + " Execut"; // Execut because the ed is added in the postfix so no need to have it here lol

            try
            {
                __state = __args[0] switch
                {
                    JsonData json => json.Name,
                    CustomMailData mail => mail.Id,
                    _ => throw new() // Move to catch block
                };
                __state += $" {name}";
            }
            catch
            {
                __state = name;
            }
        }
        else
            __state = stage;
    }

    public static void Postfix(MethodBase __originalMethod, ref string __state)
    {
        var (_, watch) = Watches[__originalMethod];
        watch.Stop();
        Main.Console.Log($"{__state}ed in {watch.ElapsedMilliseconds}ms!");
        watch.Restart(); // Since some methods are executed repeatedly, restart the watch for recyclability
    }
}
#endif