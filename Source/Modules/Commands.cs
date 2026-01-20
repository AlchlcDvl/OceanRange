#if DEBUG
using SRML.Console;

namespace OceanRange.Modules;

public sealed class OceanCommand(string id, string usage, string description, string extendedDescription, Func<string[], bool> execute) : ConsoleCommand
{
    public override string ID => id;
    public override string Usage => usage;
    public override string Description => description;
    public override string ExtendedDescription => extendedDescription;

    private readonly Func<string[], bool> _execute = execute;

    public override bool Execute(string[] args) => _execute(args);
}

public static class Commands
{
    public static readonly Dictionary<string, Dictionary<string, List<string>>> SavedPositions = [];

    public static readonly OceanCommand[] OceanCommands =
    [
        new("echo", "echo [argument] [argument] ...", "Echos whatever arguments you type into the console.", "Echos whatever arguments you type into the console, great for passing temporary notes into logs.", Echo),
        new("tp", "tp <x,y,z or x y z or x;y;z coordinates>", "Teleports the player to the specified position.", "Teleports the player to the specified position. You can use commas, spaces, or semicolons as separators. Use '~' to keep the current coordinate for that axis.", Teleport),
        new("savePos", "savePos", "Saves the player's position into a dictionary with the closest cell's name.", "Saves the player's position into a dictionary with the closest cell's name as the key to later output into a json file upon quit.", SavePos),
        // new("tester_unlock_progress", "tester_unlock_progress", "Unlocks all 7Zee progress to quickly get to the Docks.", "Unlocks all 7Zee progress to quickly get to the Docks. You may have to reload your save to apply changes.", TesterUnlockProgress)
    ];

    private static bool Echo(string[] _) => true;

    private static bool SavePos(string[] args)
    {
        if (args?.Length is > 0)
            Main.Console.LogWarning("This command does not have arguments!");

        var pos = SceneContext.Instance.Player.transform.position;
        var name = DebugUtils.GetClosestCell(pos).name.Replace("cell", string.Empty);
        var zone = name.TrueSplit('_')[0].ToUpperInvariant();

        if (!SavedPositions.TryGetValue(zone, out var positions))
            SavedPositions[zone] = positions = [];

        if (!positions.TryGetValue(name, out var positions2))
            positions[name] = positions2 = [];

        positions2.Add(DebugUtils.FormatOrientation(new(pos, Vector3.zero)));

        Main.Console.Log("Saved " + name + " at " + pos);
        return true;
    }

    private static bool Teleport(string[] args)
    {
        if (args?.Length is 1)
            args = [.. args[0].TrueSplit(',', ' ', ';')];

        if (args?.Length is not 3)
        {
            Main.Console.LogError("Incorrect number of coordinate components!");
            return false;
        }

        var pos = SceneContext.Instance.Player.transform.position;

        for (var i = 0; i < 3; i++)
        {
            if (args[i] == "~")
                args[i] = pos[i].ToString();
        }

        var vector = string.Join(",", args);
        SceneContext.Instance.Player.transform.position = Helpers.ParseVector(vector);

        Main.Console.Log("Teleported to " + vector);
        return true;
    }

    // public static bool TesterUnlockProgress(string[] args)
    // {
    //     if (args?.Length is > 0)
    //         Main.Console.LogWarning("This command does not have arguments!");

    //     SceneContext.Instance.ProgressDirector.model.progressDict[ProgressType.CORPORATE_PARTNER] = 999;
    //     SceneContext.Instance.ProgressDirector.NoteProgressChanged(ProgressType.CORPORATE_PARTNER);

    //     Main.Console.Log("7Zee unlocked past max! You may have to reload save to apply changes.");
    //     return true;
    // }
}
#endif