using System.Reflection;

#if DEBUG
using SRConsole = SRML.Console.Console;
#endif

namespace OceanRange.Managers;

public static class BootStrapper
{
    private static readonly Dictionary<LoadState, MethodInfo[]> MethodCache = new(LoadStateComparer.Instance);

    public static void RegisterAttributes(Assembly assembly)
    {
        var foundMethods = new List<(LoadState State, int MethodOrder, ManagerType ManagerOrder, MethodInfo Method)>();

        foreach (var type in AccessTools.GetTypesFromAssembly(assembly))
        {
            if (type.IsInterface || !type.TryGetAttribute<ManagerAttribute>(out var mngAttr))
                continue;

            if (!type.IsAbstract || !type.IsSealed)
            {
                Main.Console.LogError("ManagerAttribute should only be used on static types!");
                continue;
            }

            foreach (var method in type.GetMethods(AccessTools.all))
            {
                if (method.IsStatic && method.TryGetAttribute<ManagerMethodAttribute>(out var attr))
                    foundMethods.Add((attr.State, attr.Order, mngAttr.Manager, method));
            }
        }

        foreach (var group in foundMethods.GroupBy(x => x.State))
            MethodCache[group.Key] = [.. group.OrderBy(x => x.MethodOrder).ThenBy(x => x.ManagerOrder).Select(x => x.Method)];
    }

    public static void ExecuteLoadState(LoadState state)
    {
        if (!MethodCache.TryGetValue(state, out var methods))
            return;

        foreach (var method in methods)
        {
            try
            {
                method.Invoke(null, null);
            }
            catch
            {
                Main.Console.LogError($"{method.DeclaringType?.Name}.{method.Name} failed:");
                throw;
            }
        }
    }

#if DEBUG
    public static void RegisterCommands()
    {
        foreach (var command in Commands.OceanCommands)
            SRConsole.RegisterCommand(command);
    }
#endif
}