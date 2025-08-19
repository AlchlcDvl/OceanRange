#if DEBUG
using System.Diagnostics;
using System.Reflection;

namespace OceanRange.Patches;

[HarmonyPatch]
public static class TimeDiagnosticPatch
{
    private static readonly Dictionary<MethodBase, (string Stage, bool StageIsNull, Stopwatch Watch, bool HasJsonParam)> Watches = [];

    public static IEnumerable<MethodBase> TargetMethods()
    {
        var jsonType = typeof(JsonData);

        foreach (var type in AccessTools.GetTypesFromAssembly(AssetManager.Core))
        {
            foreach (var method in AccessTools.GetDeclaredMethods(type))
            {
                var timeDiagnostic = method.GetCustomAttribute<TimeDiagnosticAttribute>();

                if (timeDiagnostic == null)
                    continue;

                Watches[method] = (timeDiagnostic.Stage, timeDiagnostic.Stage == null, new(), method.GetParameters().FirstOrDefault()?.ParameterType == jsonType);
                yield return method;
            }
        }
    }

    public static void Prefix(MethodBase __originalMethod, object[] __args, ref string __state)
    {
        var (stage, isNull, watch, hasJsonParam) = Watches[__originalMethod];
        watch.Start();

        if (isNull)
        {
            var name = __originalMethod.Name + " Execut"; // Execut because the ed is added in the postfix so no need to have it here lol

            if (hasJsonParam)
                __state = ((JsonData)__args[0]).Name + $" {name}";
            else
                __state = name;
        }
        else
            __state = stage;
    }

    public static void Postfix(MethodBase __originalMethod, ref string __state)
    {
        var (_, _, watch, _) = Watches[__originalMethod];
        watch.Stop();
        Main.Console.Log($"{__state}ed in {watch.ElapsedMilliseconds}ms!");
        watch.Restart(); // Since some methods are executed repeatedly, restart the watch for recyclability
    }
}
#endif