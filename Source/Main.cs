using SRML;
using static SRML.Console.Console;

namespace TheOceanRange;

public sealed class Main : ModEntryPoint
{
    public static ConsoleInstance Console;

    public override void PreLoad()
    {
        Console = ConsoleInstance;
        Console.Log("Loading Ocean Range!");

        AssetManager.FetchAssetNames();

        FoodManager.PreLoadFoodData();
        SlimeManager.PreLoadSlimeData();
        MailManager.PreLoadMailData();

        HarmonyInstance.PatchAll();
    }

    public override void Load()
    {
        SlimeManager.LoadAllSlimes();
        FoodManager.LoadFoods();

        SystemContext.IsModded = true;
    }

    public override void PostLoad()
    {
        AssetManager.UnloadBundle();
        Console.Log("Loaded Ocean Range!");
    }
}