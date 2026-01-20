#if DEBUG
namespace OceanRange.Modules;

[AttributeUsage(AttributeTargets.Method)]
public sealed class TimeDiagnosticAttribute(string stage = null) : Attribute
{
    public readonly string Stage = stage;
}
#endif