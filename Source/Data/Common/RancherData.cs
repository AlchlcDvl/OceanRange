// ReSharper disable UnassignedField.Global

namespace OceanRange.Data;

[Serializable]
public sealed partial class RancherData : JsonData
{
    protected override bool SerialiseName => true;
}
