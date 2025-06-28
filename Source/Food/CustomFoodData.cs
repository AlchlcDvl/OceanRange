namespace TheOceanRange.Food;

public sealed class CustomFoodData
{
    public IdentifiableId Id;

    public FoodGroup Group;

    public int FavouriteModifier;

    public float MinDrive = 1f;

    public IdentifiableId[] FavouredBy;
}