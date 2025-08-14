namespace OceanRange.Managers;

public static class LargoManager
{
    public static void LoadAllLargos()
    {
        SlimeRegistry.CraftLargo(Ids.PINK_COCO_LARGO, Ids.COCO_SLIME, IdentifiableId.PINK_SLIME, SlimeRegistry.LargoProps.GENERATE_NAME | SlimeRegistry.LargoProps.GENERATE_SECRET_STYLES);
    }
}