using System.Reflection;

namespace OceanRange.Managers;

public enum LoadState
{
    Preload,
    Load,
    Postload
}

[AttributeUsage(AttributeTargets.Class)]
public sealed class ManagerAttribute : Attribute
{
    private static readonly Dictionary<LoadState, MethodInfo[]> Loads = new(LoadStateComparer.Instance);

    public static void RegisterManagers()
    {
        var loads = new Dictionary<LoadState, List<ManagerMethodAttribute>>(LoadStateComparer.Instance)
        {
            [LoadState.Preload] = [],
            [LoadState.Load] = [],
            [LoadState.Postload] = [],
        };

        foreach (var manager in AccessTools.GetTypesFromAssembly(Inventory.Core))
        {
            if (manager.IsInterface || !manager.IsAbstract || !manager.IsSealed || !manager.IsDefined<ManagerAttribute>())
                continue;

            foreach (var method in manager.GetMethods(AccessTools.all))
            {
                if (!method.IsStatic || !method.TryGetAttribute<ManagerMethodAttribute>(out var loadMethod))
                    continue;

                loadMethod.AttachedMethod = method;
                loads[loadMethod.State].Add(loadMethod);
            }
        }

        foreach (var (state, methods) in loads)
            Loads[state] = [.. methods.OrderBy(x => x.Order).Select(x => x.AttachedMethod)];
    }

    public static void ExecuteLoadState(LoadState state)
    {
        foreach (var method in Loads[state])
            method.Invoke(null, null);
    }
}

[AttributeUsage(AttributeTargets.Method)]
public abstract class ManagerMethodAttribute(int order, LoadState state) : Attribute
{
    public readonly int Order = order;
    public readonly LoadState State = state;

    public MethodInfo AttachedMethod;
}

public sealed class PreloadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Preload);

public sealed class LoadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Load);

public sealed class PostloadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Postload);