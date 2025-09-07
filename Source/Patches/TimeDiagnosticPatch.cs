#if DEBUG
using System.Diagnostics;
using System.Reflection;
using System.Text;

namespace OceanRange.Patches;

[HarmonyPatch, UsedImplicitly]
public static class TimeDiagnosticPatch
{
    private static readonly Dictionary<MethodBase, (string Stage, bool StageIsNull, Stopwatch Watch, bool HasJsonParam)> Watches = [];

    public static IEnumerable<MethodBase> TargetMethods()
    {
        var jsonType = typeof(JsonData);

        foreach (var type in AccessTools.GetTypesFromAssembly(Inventory.Core))
        {
            foreach (var method in AccessTools.GetDeclaredMethods(type))
            {
                var timeDiagnostic = method.GetCustomAttribute<TimeDiagnosticAttribute>();

                if (timeDiagnostic == null)
                    continue;

                Watches[method] = (timeDiagnostic.Stage, timeDiagnostic.Stage == null, new(), jsonType.IsAssignableFrom(method.GetParameters().FirstOrDefault()?.ParameterType));
                yield return method;
            }
        }
    }

    public static void Prefix(MethodBase __originalMethod, object[] __args, ref string __state)
    {
        var (stage, isNull, watch, hasJsonParam) = Watches[__originalMethod];
        watch.Start();

        var sb = new StringBuilder();
        sb.Append(isNull ? __originalMethod.Name : stage);

        if (hasJsonParam)
        {
            sb.Insert(0, ((JsonData)__args[0]).Name + " ");
            sb.Append(" Execut"); // Execut because the ed is added in the postfix so no need to have it here lol
        }

        __state = sb.ToString();
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