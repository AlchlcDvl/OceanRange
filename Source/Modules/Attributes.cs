namespace OceanRange.Managers;

public enum LoadState
{
    Preload,
    Load,
    Postload
}

[AttributeUsage(AttributeTargets.Class)]
public sealed class ManagerAttribute : Attribute;

[AttributeUsage(AttributeTargets.Method)]
public abstract class ManagerMethodAttribute(int order, LoadState state) : Attribute
{
    public readonly int Order = order;
    public readonly LoadState State = state;
}

public sealed class PreloadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Preload);

public sealed class LoadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Load);

public sealed class PostloadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Postload);