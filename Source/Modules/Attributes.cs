namespace OceanRange.Modules;

public enum LoadState : byte
{
    Preload,
    Load,
    Postload,
    Unload
}

public enum ManagerType : byte
{
    Atlas,
    FloppyDisk,
    Cookbook,
    Refinery,
    Slimepedia,
    Largopedia,
    Mailbox,
    Contacts,
    Blueprints,
    Translator
}

[AttributeUsage(AttributeTargets.Class), MeansImplicitUse(ImplicitUseTargetFlags.WithMembers)]
public sealed class ManagerAttribute(ManagerType manager) : Attribute
{
    public readonly ManagerType Manager = manager;
}

[AttributeUsage(AttributeTargets.Method)]
public abstract class ManagerMethodAttribute(int order, LoadState state) : Attribute
{
    public readonly int Order = order;
    public readonly LoadState State = state;
}

public sealed class PreloadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Preload);

public sealed class LoadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Load);

public sealed class PostloadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Postload);

// public sealed class UnloadMethodAttribute(int order = int.MaxValue) : ManagerMethodAttribute(order, LoadState.Unload);