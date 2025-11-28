using System.Reflection;

namespace OceanRange.Managers;

public static class BootStrapper
{
    private static readonly Dictionary<LoadState, MethodInfo[]> MethodCache = new(LoadStateComparer.Instance);

    public static void RegisterManagers(Assembly assembly)
    {
        var foundMethods = new List<(LoadState State, int MethodOrder, ManagerType ManagerOrder, MethodInfo Method)>();

        foreach (var type in AccessTools.GetTypesFromAssembly(assembly))
        {
            if (type.IsInterface || !type.IsAbstract || !type.IsSealed || !type.TryGetAttribute<ManagerAttribute>(out var mngAttr))
                continue;

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
            catch (Exception ex)
            {
                var realError = ex.InnerException ?? ex;
                Main.Console.LogError($"{method.DeclaringType?.Name}.{method.Name} failed: {realError}");
                throw realError;
            }
        }
    }
}