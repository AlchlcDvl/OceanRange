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
    public override string Usage => "savePos";
    public override string Description => "Saves the player's position into a dictionary with the closest cell's name as the key to later output into a json file upon quit";

    public override bool Execute(string[] args)
    {
        if (args?.Length is not (null or 0))
            return false;

        var pos = SceneContext.Instance.Player.transform.position;
        var name = Helpers.GetClosestCell(pos).name.Replace("cell", "");

        if (!SavedPositions.TryGetValue(name, out var positions))
            positions = SavedPositions[name] = [];

        positions.Add(pos);
        Main.Console.Log("Saved " + name + " at " + pos.ToString());
        return true;
    }
}

public sealed class TeleportCommand : ConsoleCommand
{
    public override string ID => "tp";
    public override string Usage => "tp";
    public override string Description => "Teleports the player to the specified position";

    public override bool Execute(string[] args)
    {
        if (args?.Length is not (1 or 3))
            return false;

        if (args.Length == 1)
            args = args[0].TrueSplit(',', ' ');

        var vector = string.Join(",", args);
        SceneContext.Instance.Player.transform.position = Helpers.ParseVector(vector);
        Main.Console.Log("Teleported to " + vector);
        return true;
    }
}
#endif