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
    public override string Description => "Saves the player's position into a dictionary with the closest cell's name.";
    public override string ExtendedDescription => "Saves the player's position into a dictionary with the closest cell's name as the key to later output into a json file upon quit";

    public override bool Execute(string[] args)
    {
        if (args?.Length is not (null or 0))
            return false;

        var pos = SceneContext.Instance.Player.transform.position;
        var name = DebugUtils.GetClosestCell(pos).name.Replace("cell", "");

        if (!SavedPositions.TryGetValue(name, out var positions))
            SavedPositions[name] = positions = [];

        positions.Add(pos);
        Main.Console.Log("Saved " + name + " at " + pos);
        return true;
    }
}

public sealed class TeleportCommand : ConsoleCommand
{
    public override string ID => "tp";
    public override string Usage => "tp <x,y,z or x y z or x;y;z coordinates>";
    public override string Description => "Teleports the player to the specified position.";

    public override bool Execute(string[] args)
    {
        if (args?.Length is 1)
            args = [.. args[0].TrueSplit(',', ' ', ';')];

        if (args?.Length is not 3)
            return false;

        var pos = SceneContext.Instance.Player.transform.position;

        for (var i = 0; i < 3; i++)
        {
            if (args[i] == "~")
                args[i] = pos[i].ToString();
        }

        var vector = string.Join(",", args);
        SceneContext.Instance.Player.transform.position = DebugUtils.ParseVector(vector);
        Main.Console.Log("Teleported to " + vector);
        return true;
    }
}

public class TesterUnlockProgressCommand : ConsoleCommand
{
    public override string ID => "tester_unlock_progress";
    public override string Usage => "tester_unlock_progress";
    public override string Description => "Unlocks all 7Zee progress to quickly get to the Docks.";

    public override bool Execute(string[] args)
    {
        SceneContext.Instance.ProgressDirector.model.progressDict[ProgressType.CORPORATE_PARTNER] = 999;
        SceneContext.Instance.ProgressDirector.NoteProgressChanged(ProgressType.CORPORATE_PARTNER);

        Main.Console.Log("7Zee unlocked past max! You may have to reload save to apply changes.");
        return true;
    }
}
#endif