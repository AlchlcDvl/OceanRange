#if DEBUG
using SRML.Console;

namespace OceanRange.Modules;

public sealed class EchoCommand : ConsoleCommand
{
    public override string ID => "echo";
    public override string Usage => "echo [argument] [argument] ...";
    public override string Description => "Echos whatever arguments you type into the console.";
    public override string ExtendedDescription => "Echos whatever arguments you type into the console, great for passing temporary notes into logs.";

    public override bool Execute(string[] args) => true;
}

public sealed class SavePositionCommand : ConsoleCommand
{
    public readonly Dictionary<string, List<Vector3>> SavedPositions = [];

    public override string ID => "savePos";
    public override string Usage => "savePos [cell name]";
    public override string Description => "Saves the player's position into a dictionary to later output into a json file upon quit";

    public override bool Execute(string[] args)
    {
        if (args?.Length > 1)
            return false;

        var name = Main.SaveRegion.Region + "_" + (args.Length == 1 ? args[0] : "NotSet");

        if (!SavedPositions.TryGetValue(name, out var positions))
            positions = SavedPositions[name] = [];

        positions.Add(SceneContext.Instance.Player.transform.position);
        Main.Console.Log("Saved " + name);
        return true;
    }
}

public sealed class SaveRegionCommand : ConsoleCommand
{
    public string Region = "NoRegion";

    public override string ID => "saveRegion";
    public override string Usage => "saveRegion <region name>";
    public override string Description => "Sets the current debugging region to the one passed by the command";

    public override bool Execute(string[] args)
    {
        if (args?.Length != 1)
            return false;

        Region = args[0];
        Main.Console.Log("Set " + Region);
        return true;
    }
}
#endif