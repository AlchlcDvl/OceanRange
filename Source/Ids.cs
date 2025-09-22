using SRML.Utils.Enum;

// ReSharper disable UnusedMember.Global
// ReSharper disable UnassignedReadonlyField

namespace OceanRange;

[EnumHolder]
public static class Ids
{
    public static readonly SlimeExpression Sleeping;

    public static readonly FoodGroup DIRT;

    public static readonly ProgressType EXCHANGE_LISA;

    public static readonly Category OCEAN;

    public static readonly Zone SWIRLPOOL;
    // public static readonly Zone GREAT_REEF;
    // public static readonly Zone LISA_RANCH;
    // public static readonly Zone BLUE_DEPTHS;
    
    public static readonly Ambiance SWIRLPOOL_AMBIANCE;

    public static readonly PediaId SWIRLPOOL_ENTRY; // TODO: make json versions of fixed pedia entries
}